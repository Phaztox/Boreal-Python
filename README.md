# Installation
1. If you haven't already, download and install Python 3.14 or higher from the official website: `https://www.python.org/downloads/`
   - Make sure to add Python to your system PATH during installation. This will allow you to run Python and pip from the command line.
2. Download the project files:
   - **Option A (Easiest):** Download this repository as a ZIP file (click the green `Code` button at the top of the GitHub page and select `Download ZIP`) and extract it to a folder of your choice.
   - **Option B (For easy updates/developers):** If you have Git installed, clone the repository using your terminal: `git clone https://github.com/Phaztox/Boreal-Python.git` in the directory where you want the project to be located.
3. Navigate to the extracted project directory : `cd Boreal-Python`
   And create a virtual environment: `py -3.14 -m venv .venv` (here, choose whichever version you downloaded/want to use, "3.14" is an example for Python 3.14).
4. Activate the virtual environment:
   - On Windows: `.venv\Scripts\activate`
   - On macOS/Linux: `source .venv/bin/activate`
5. Install the required dependencies: `pip install -r requirements.txt`

# Usage
1. Run the GUI: `GUI_launch.bat` (Windows) or `python GUI_launch.py` (macOS/Linux)
2. Follow the prompts in the GUI to select your input binary flight data file, set any desired offsets, and choose whether to extract data, resample and clean data, launch the dashboard or either combination of these options.
3. Once the processing is complete, you can launch the dashboard to visualize the processed data. The dashboard will automatically open in your default web browser. You can also access it by navigating to `http://localhost:8501` in your browser.

## GUI Details
* The first two lines allow to choose the input file and the output directory (`Processes data`) by default. The output directory is where the extracted and cleaned data will be saved. Right below is the directory where the **Dashboard** will search for h5 files. By default set to `Processed data`, this path can also be changed in the dashboard UI. 
* The GUI allows you to select a binary flight data file (`.bin`) and specify offsets to trim the start (**Offset 1**) and end (**Offset 2**) of the recording when extracting data. 
* In the Resample and Clean section, there are two types of Offsets : 
  * **Offset 1**: This offset is used to trim the start of the recording. It is applied to all datasets using 100Hz recording (AD_NAVIGATION, IMU, ...).
  * **Offset 2**: This offset is applied to the same datasets as Offset 1 but is used to trim the end of the recording. 
  * **Offset P1**: This offset is used to trim the start of the recording for the MOTUSRAW and Pressures datasets, which are recording data at 1000Hz. It will generally be 10 times the value of Offset 1. 
  * **Offset P2**: This offset is applies to the same datasets as Offset P1 but is used to trim the end of the recording.
* There are two buttons to shutdown Streamlit processes. `Shutdown Dashboard` will shutdown the last dashboard process launched by the GUI, while `Kill Streamlit Processes` will kill all Streamlit processes running on the system (useful if you have multiple dashboards running).

# Documentation
## Short explanation of the files in the repository: <br/>
* **`GUI_launch.bat`**: A batch file that runs the GUI process data script. It's the only file that needs to be executed to start the GUI and start the application. 
* **`GUI_launch.py`**: The main Python script that contains the code for the GUI. Basically the code that runs when you execute the GUI_launch.bat file.
* **`extract_data.py`**: A Python script that contains the code used by the GUI to extract data from the input binary flight data file. This script is called by the GUI_launch.py script when the user uses the "Extract Data" function in the GUI.
* **`resample_and_clean.py`**: A Python script that contains the code used by the GUI to resample and clean the extracted data. This script is called by the GUI_launch.py script when the user uses the "Resample and Clean Data" function in the GUI.
* **`dashboard.py`**: A Python script that contains the code used by the GUI to create a dashboard to visualize the extracted and cleaned data. This script is called by the GUI_launch.py script when the user clicks the "Launch Dashboard" button in the GUI. 
* **`data_utils.py`**: A Python script that contains utility functions used by the other scripts (e.g., `dashboard.py` or `resample_and_clean.py`) to process the data. This script is imported by the other scripts to use the functions defined in it. 
* **`requirements.txt`**: A file that lists the required Python packages for the project. 
* **`Processed Data/`**: A folder that contains the processed data files (e.g., extracted files, resampled files). This folder is the default output folder.
* **`.venv/`**: A folder that contains the Python virtual environment for the project. 
* **`.streamlit/`**: A folder that contains the Streamlit configuration files for the dashboard. Mostly used to set the max upload size for the dashboard drag and drop functionality. 

## Deeper explanation of the main code files: <br/>
### `GUI_launch.py`
This file uses **Tkinter** for the UI and acts as the orchestrator for the project.

#### 1. Architecture
*   **Class-Based GUI**: The entire application is wrapped in the `FlightDataProcessorGUI` class.
*   **Tkinter Variables**: UI state (checkboxes, file paths, offsets) is heavily coupled to `tk.StringVar()`, `tk.BooleanVar()`, and `tk.IntVar()`. These allow the UI and the underlying logic to sync automatically without manual getters/setters.
*   **Threading**: To prevent the Tkinter `mainloop()` from freezing during `.h5` operations or data extraction, the actual workload is offloaded to a separate thread. When "Process Data" is clicked, `process_data()` spawns a `threading.Thread` targeting `run_processing()`.

#### 2. Key Methods 
*   **`setup_ui(self)`**: Initializes the grid-based UI using `tkinter.ttk` (themed Tkinter) for modern-looking widgets.
*   **`process_data(self)`**: The entry point for execution. Validates UI inputs, locks the interface to prevent duplicate runs, and starts the background worker thread.
*   **`run_processing(self)`**: The background worker payload. It conditionally calls `extract_flight_data()` and `resample_and_clean_data()` based on UI flags.

#### 3. Progress Tracking
Since the data processing functions (extract_data.py, resample_and_clean.py) are designed as independent scripts that print to standard output, GUI_launch.py uses a stdout-interception pattern to drive its progress bar.
*   **`capture_function_output(self, func, *args)`**: A wrapper function that temporarily redirects `sys.stdout`. It reads the output of the data functions line-by-line.
*   **`parse_checkpoint_output(self, output_line)`**: Analyzes the intercepted strings to detect specific log formats (e.g., `[1/6]`).
*   **ETA System (`start_eta_timer`, `update_eta_continuously`, `recalibrate_eta`)**: Uses hardcoded time estimates (`self.extract_expected_times`) for different processing steps. `update_eta_continuously()` is scheduled recursively using Tkinter's `root.after(1000, ...)` to smoothly interpolate the progress bar and ETA label even when stdout is quiet.

#### 4. Streamlit Dashboard Lifecycle
*   **`launch_dashboard_app(self)`**: Spawns the Streamlit dashboard asynchronously using `subprocess.Popen(["streamlit", "run", "dashboard.py", ...])`. 
*   **Process Management (`detect_existing_dashboard`, `kill_streamlit_processes`)**: Uses the `psutil` library to scan system processes and terminate lingering `streamlit` executables, preventing port conflicts (default 8501).

*** 

### `extract_data.py`
This file is responsible for parsing the raw binary flight logs (`.bin`) and converting them into structured, readable datasets saved in HDF5 (`.h5`) format. It relies heavily on **NumPy** for high-performance matrix operations and bitwise decoding.

#### 1. Optimization & Data Loading
*   **Memory Mapping (`load_binary_data`)**: Instead of loading the entire binary file into RAM, it uses `np.memmap(..., mode='r')` to map the file directly from disk. The 1D byte array is reshaped into a 2D matrix where each row represents a data frame of exactly 1024 bytes (columns).
*   **Data Cleaning**: It handles UI-defined offsets to trim the start/end of the recording and filters out invalid or empty lines (e.g., frames entirely filled with `FF` or `255`).

#### 2. Bitwise Conversions & Decoding
The raw matrix consists of `uint8` bytes. The script contains several specialized inner functions to decode these bytes back into physical measurements according to the telemetry protocol:
*   **`dec2single` & `dec2double`**: Reads 4-byte or 8-byte sequences and decodes them into standard IEEE floating-point numbers (e.g., for GPS coordinates).
*   **`extract_uint64_forward` / `reverse`**: Handles Endianness (byte order) challenges to reconstruct large counters and timestamps (Unix Time, microseconds). 

#### 3. Matrix Demultiplexing & Resampling
The main function pre-allocates large zero-filled NumPy arrays (`AD_NAVIGATION`, `IMU`, `Pressures`, etc.) before population to ensure maximum speed.
*   **Column Mapping**: It extracts data by targeting specific hardware packet offsets. 
*   **Frequency Handling**: Different sensors sample at different frequencies. The script handles high-frequency data (like `MOTUSRAW` or `Pressures` at 1000Hz vs 100Hz baseline) by allocating $10 \times \text{line count}$ rows and using NumPy functions like `.repeat(10)` to synchronize slower timestamps alongside high-frequency sensor readings.

#### 4. GUI Synchronization 
*   **Checkpointing (`checkpoint`)**: Throughout the execution, the script prints specific formatted strings (like `[2/6] Processing AD_NAVIGATION...`). These are not just console logs; they are specifically designed to be intercepted by `GUI_launch.py`'s `parse_checkpoint_output` to drive the GUI's progress bar and ETA calculations.

### `resample_and_clean.py`
This file takes the raw, extracted `.h5` datasets and normalizes them. Because different sensors on the aircraft log data at different, sometimes irregular frequencies (e.g., 25Hz, 100Hz, 1000Hz), this script interpolates everything onto uniform time grids and aggressively cleans noise and outliers.

#### 1. Outlier Detection (`detect_and_fill_outliers`)
*   **IQR Filtering**: Before resampling, the script uses the Interquartile Range (IQR) method to identify statistical outliers (spikes, bad sensor reads). It calculates Q1 and Q3, and anything outside $Q1 - (multiplier \times IQR)$ and $Q3 + (multiplier \times IQR)$ is flagged.
*   **Linear Interpolation**: Flagged outliers are treated as missing data and are immediately replaced using linear interpolation (`np.interp`) against valid neighboring points, ensuring the data remains continuous.

#### 2. Resampling & Frequency Normalization
The core function `resample_and_clean_data` processes each dataset individually block-by-block (tracked by `checkpoint` prints for the GUI):
*   **Deduplication**: It first strips out rows with duplicate timestamps (which occur because lower-frequency telemetry was repeated to match the highest-frequency clock).
*   **Time Grid Generation**: For each dataset, a new perfectly uniform linear time grid is created using `np.linspace(start_time, end_time, num_samples)`.
*   **Interpolation (`np.interp`)**: The existing data points are linearly interpolated to fit this new perfect grid. 
    *   `AD_NAVIGATION`: Upsampled from 25Hz to 100Hz.
    *   `Pressures`: Downsampled from 1000Hz to 100Hz using a moving average block (`np.mean(..., axis=0)`).
    *   `MOTUSRAW`: Complex split processing. 1000Hz channels are cleaned and kept at 1000Hz, while 100Hz channels within the same packet are upsampled to 1000Hz, and then merged back together.

#### 3. Data Optimization & Storage
*   **Precision Tweaking**: To radically reduce the final file size, the script casts most floating-point telemetry arrays (which are naturally 64-bit `np.float64` in Python) down to 32-bit floats (`np.float32`) in cases where that extra precision is not necessary. 
*   **Compression**: The cleaned, normalized datasets are saved back into a new `.h5` file, utilizing `h5py` with `compression="gzip"` and `compression_opts=4`.

### `dashboard.py`
This file is a standalone web application built with **Streamlit**. It provides an interface for researchers to visually explore the processed `.h5` flight files without needing to write custom plotting scripts. 

#### 1. Architecture & State Management
*   **Web Framework**: Streamlit handles the web server, reactive UI rendering, and routing automatically by executing the file top-to-bottom on every user interaction.
*   **Session State (`st.session_state`)**: Because Streamlit re-runs the whole script on every input, variables must be cached in `st.session_state` to persist across renders (e.g., remembering which directory was browsed, temporarily uploaded files, or caching generated graphs to prevent heavy re-calculation). 

#### 2. File Ingestion & Data Handling
*   **Folder Browsing**: It interfaces with the OS via a hidden `tkinter` dialogue (launched via an external `subprocess` call to prevent thread-locking issues with Streamlit) to let users pick folders. 
*   **Drag & Drop**: If a file is dragged into the UI, it writes the buffer to a temporary file (`tempfile.NamedTemporaryFile`) so `h5py` can read it natively from the disk. 
*   **Data Read**: Utilizes helper functions from `data_utils.py` to securely read datasets and metadata without loading the entire multi-gigabyte `.h5` file into memory at once. Data is loaded into **Pandas DataFrames** only when explicitly requested by a specific tab.

#### 3. Core Features (Tabs)
*   **Overview & Data Explorer**: Provides high-level metadata (shapes, sizes) and a paginated, searchable, interactive spreadsheet view of the raw numbers. Users can download snippets to `.csv` or `.h5`.
*   **Visualization (2D & 3D)**: Leverages **Plotly** (`plotly.graph_objects` & `plotly.express`) for hardware-accelerated interactive web plots. 
    *   2D Visualization & Export Engine: The interactive graphs are rendered in Plotly, but Streamlit/Plotly native image downloads can struggle with huge datasets. To fix this, the dashboard dynamically spins up a hidden **Matplotlib** backend (`matplotlib.use('Agg')` for headless rendering) to regenerate the exact same plot in the background when a user requests a download. This enables high-performance exporting to multiple formats natively (`.png`, `.svg` for vector graphics, and `.html` for standalone interactive plots).
    *   The 3D plot allows custom XYZ mapping (e.g., mapping Longitude, Latitude, and Height).
    *   To prevent browser crashes on massive datasets, it includes an adjustable downsampling slider (`sample_rate_3d`).
*   **Straight Flight Detector**: Detects straight flight sequences from trajectory and attitude constraints (Latitude/Longitude path stability, Roll threshold, and altitude min/max bounds).
    *   Sequences are listed with start/end row indices and length, with a verification trajectory plot that highlights detected segments.
    *   A sequence can be imported directly into the global **Row Range Filter** (start/end rows) to continue analysis in the other tabs.
    *   Detected sequences can be exported to a dedicated `.h5` file with per-sequence datasets (`SEQxxx_*`) and detection metadata.
*   **Spectrum Analysis**: Integrates `scipy.signal` to perform advanced mathematical analysis directly in the browser. It includes:
    *   PSD (Power Spectral Density) computations.
    *   Optional Multitaper method utilizing discrete prolate spheroidal sequences (DPSS).
    *   A configurable Bessel Low-Pass filter (`filtfilt`) to clean noise before running FFTs. 
*   **Statistics**: Computes standard descriptive statistics (mean, std, quartiles, skewness, kurtosis) and renders instantaneous distribution histograms via Plotly.
