import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
import subprocess
import os
import time
import sys
import re
from extract_data import extract_flight_data
from resample_and_clean import resample_and_clean_data

class FlightDataProcessorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Flight Data Processor")
        self.root.geometry("725x750")
        
        # Variables
        self.input_file_var = tk.StringVar()
        self.output_dir_var = tk.StringVar(value="Processed Data")
        
        # Extract function variables
        self.enable_extract = tk.BooleanVar(value=True)
        self.extract_offset1 = tk.IntVar(value=1)
        self.extract_offset2 = tk.IntVar(value=0)
        
        # Resample function variables
        self.enable_resample = tk.BooleanVar(value=True)
        self.resample_offset1 = tk.IntVar(value=0)
        self.resample_offset2 = tk.IntVar(value=0)
        self.resample_offsetP1 = tk.IntVar(value=0)
        self.resample_offsetP2 = tk.IntVar(value=0)
        self.use_extract_output = tk.BooleanVar(value=True)
        self.resample_input_file_var = tk.StringVar()
        
        # Options
        self.launch_dashboard = tk.BooleanVar(value=True)
        
        # Progress tracking
        self.start_time = None
        self.dashboard_process = None
        
        # Checkpoint tracking
        self.extract_checkpoints = [
            "Loading and parsing input data",
            "Processing AD_NAVIGATION, IMU, and counters",
            "Processing Air Data, Wind, and Pressures", 
            "Processing Pattern and Temperature/Humidity",
            "Processing MOTUS RAW and ORI",
            "Saving data to HDF5 file"
        ]
        self.resample_checkpoints = [
            "Loading HDF5 file and extracting datasets",
            "Processing AD_NAVIGATION resampling",
            "Processing Pressures resampling", 
            "Processing Temperature data with outlier detection",
            "Processing IMU data with outlier detection and interpolation",
            "Processing MOTUSORI data with outlier detection and interpolation",
            "Processing MOTUSRAW data with outlier detection and interpolation",
            "Saving resampled data to HDF5 file"
        ]
        
        # Expected times for ETA calculation - 6 extract steps + 8 resample steps
        self.extract_expected_times = [0.5, 1.8, 2.5, 4, 15.4, 40.6]
        self.resample_expected_times = [9, 1, 6, 1.1, 0.9, 1, 30, 19]
        
        # Simplified ETA tracking
        self.eta_timer = None
        self.current_eta = 0
        self._timer_stopped = False
        
        # Tracking variables
        self.current_checkpoints = []
        self.checkpoint_start_times = []
        self.performance_ratios = []
        
        self.setup_ui()
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.detect_existing_dashboard()
    
    def setup_ui(self):
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), padx=10, pady=0)
        main_frame.columnconfigure(1, weight=1)
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        
        row = 0
        
        # Title
        title_label = ttk.Label(main_frame, text="Flight Data Processor", font=("Arial", 16, "bold"))
        title_label.grid(row=row, column=0, columnspan=3, pady=(0, 10))
        row += 1
        
        # Input file selection
        ttk.Label(main_frame, text="Input File:").grid(row=row, column=0, sticky=tk.W, pady=5)
        ttk.Entry(main_frame, textvariable=self.input_file_var, width=50).grid(row=row, column=1, sticky=(tk.W, tk.E), padx=(5, 5))
        ttk.Button(main_frame, text="Browse", command=self.browse_input_file).grid(row=row, column=2, padx=(5, 0))
        row += 1
        
        # Output directory
        ttk.Label(main_frame, text="Output Directory:").grid(row=row, column=0, sticky=tk.W, pady=5)
        ttk.Entry(main_frame, textvariable=self.output_dir_var, width=50).grid(row=row, column=1, sticky=(tk.W, tk.E), padx=(5, 5))
        ttk.Button(main_frame, text="Browse", command=self.browse_output_dir).grid(row=row, column=2, padx=(5, 0))
        row += 1

        # Line to only launch the dashboard without processing
        ttk.Label(main_frame, text="Launch Dashboard Only:", font=("Arial", 9, "italic")).grid(row=row, column=0, sticky=tk.W, pady=5)
        ttk.Entry(main_frame, textvariable=self.output_dir_var, width=50).grid(row=row, column=1, sticky=(tk.W, tk.E), padx=(5, 5)) # Reusing output directory entry for dashboard launch, can be left empty
        ttk.Button(main_frame, text="Launch Dashboard", command=self.launch_dashboard_app).grid(row=row, column=2, padx=(5, 0))
        row += 1
        
        # Separator
        ttk.Separator(main_frame, orient='horizontal').grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        row += 1
        
        # Extract function section
        extract_frame = ttk.LabelFrame(main_frame, text="Extract Function", padding="10")
        extract_frame.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        extract_frame.columnconfigure(1, weight=1)
        
        ttk.Checkbutton(extract_frame, text="Enable Extract Function", variable=self.enable_extract).grid(row=0, column=0, columnspan=2, sticky=tk.W, pady=5)
        
        ttk.Label(extract_frame, text="Offset 1:").grid(row=1, column=0, sticky=tk.W, pady=2)
        ttk.Entry(extract_frame, textvariable=self.extract_offset1, width=10).grid(row=1, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(extract_frame, text="(Number of rows to skip from the start of the file. e.g. 0 for no offset, 1 to shift by one row)").grid(row=1, column=2, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(extract_frame, text="Offset 2:").grid(row=2, column=0, sticky=tk.W, pady=2)
        ttk.Entry(extract_frame, textvariable=self.extract_offset2, width=10).grid(row=2, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(extract_frame, text="(Number of rows to skip from the end of the file. e.g. 0 for no offset, 1 to shift by one row)").grid(row=2, column=2, sticky=tk.W, padx=(5, 0))
        
        row += 1
        
        # Resample function section
        resample_frame = ttk.LabelFrame(main_frame, text="Resample & Clean Function", padding="10")
        resample_frame.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        resample_frame.columnconfigure(1, weight=1)
        
        ttk.Checkbutton(resample_frame, text="Enable Resample & Clean Function", variable=self.enable_resample, command=self.update_resample_ui).grid(row=0, column=0, columnspan=3, sticky=tk.W, pady=5)
        
        # Workflow control
        workflow_frame = ttk.Frame(resample_frame)
        workflow_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        ttk.Checkbutton(workflow_frame, text="Use output from extraction (if enabled)", 
                       variable=self.use_extract_output, command=self.update_resample_ui).grid(row=0, column=0, sticky=tk.W)
        
        # Resample input file (only shown when not using extract output)
        self.resample_input_label = ttk.Label(resample_frame, text="Input File for Resampling:")
        self.resample_input_entry = ttk.Entry(resample_frame, textvariable=self.resample_input_file_var, width=40)
        self.resample_input_button = ttk.Button(resample_frame, text="Browse", command=self.browse_resample_input_file)
        
        ttk.Label(resample_frame, text="Offset 1:").grid(row=3, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offset1, width=10).grid(row=3, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(resample_frame, text="(Number of rows to skip from the start of the file.)").grid(row=3, column=2, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(resample_frame, text="Offset 2:").grid(row=4, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offset2, width=10).grid(row=4, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(resample_frame, text="(Number of rows to skip from the end of the file.)").grid(row=4, column=2, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(resample_frame, text="Offset P1:").grid(row=5, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offsetP1, width=10).grid(row=5, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(resample_frame, text="(Number of rows to skip from the start of the file for the Pressure data.)").grid(row=5, column=2, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(resample_frame, text="Offset P2:").grid(row=6, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offsetP2, width=10).grid(row=6, column=1, sticky=tk.W, padx=(5, 0))
        ttk.Label(resample_frame, text="(Number of rows to skip from the end of the file for the Pressure data.)").grid(row=6, column=2, sticky=tk.W, padx=(5, 0))
        
        # Initialize UI state
        self.update_resample_ui()
        
        row += 1
        
        # Dashboard launch option
        dashboard_frame = ttk.LabelFrame(main_frame, text="Post-Processing Options", padding="10")
        dashboard_frame.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        
        ttk.Checkbutton(dashboard_frame, text="Launch Dashboard after processing", variable=self.launch_dashboard).grid(row=0, column=0, sticky=tk.W, pady=5)
        
        # Add dashboard control buttons
        ttk.Button(dashboard_frame, text="Shutdown Dashboard", command=self.shutdown_dashboard).grid(row=0, column=1, padx=(20, 5), pady=5)
        ttk.Button(dashboard_frame, text="Kill All Dashboards", command=self.kill_streamlit_processes).grid(row=0, column=2, padx=(5, 0), pady=5)
        
        row += 1
        
        # Separator
        ttk.Separator(main_frame, orient='horizontal').grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        row += 1
        
        # Process button
        process_button = ttk.Button(main_frame, text="Process Data", command=self.process_data)
        process_button.grid(row=row, column=0, columnspan=3, pady=10)
        row += 1
        
        # Progress bar
        self.progress = ttk.Progressbar(main_frame, mode='determinate')
        self.progress.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        row += 1
        
        # Status label
        self.status_label = ttk.Label(main_frame, text="Ready to process data...")
        self.status_label.grid(row=row, column=0, columnspan=3, pady=5)
    
    def browse_input_file(self):
        filename = filedialog.askopenfilename(
            title="Select Input File",
            filetypes=[("Binary files", "*.bin"), ("All files", "*.*")]
        )
        if filename:
            self.input_file_var.set(filename)
    
    def browse_output_dir(self):
        directory = filedialog.askdirectory(title="Select Output Directory")
        if directory:
            self.output_dir_var.set(directory)
    
    def browse_resample_input_file(self):
        filename = filedialog.askopenfilename(
            title="Select Input File for Resampling",
            filetypes=[("HDF5 files", "*.h5"), ("Binary files", "*.bin"), ("All files", "*.*")]
        )
        if filename:
            self.resample_input_file_var.set(filename)
    
    def update_resample_ui(self):
        """Update the resample UI based on current settings"""
        if self.enable_resample.get() and not self.use_extract_output.get():
            # Show resample input file selection
            self.resample_input_label.grid(row=2, column=0, sticky=tk.W, pady=5)
            self.resample_input_entry.grid(row=2, column=1, sticky=(tk.W, tk.E), padx=(5, 5))
            self.resample_input_button.grid(row=2, column=2, padx=(5, 0))
        else:
            # Hide resample input file selection
            self.resample_input_label.grid_remove()
            self.resample_input_entry.grid_remove()
            self.resample_input_button.grid_remove()
    
    def log_message(self, message):
        print(message)    
    def setup_checkpoint_tracking(self):
        """Setup checkpoint tracking based on enabled functions"""
        self.current_checkpoints = []
        expected_times = []
        
        if self.enable_extract.get():
            self.current_checkpoints.extend([("extract", i, desc) for i, desc in enumerate(self.extract_checkpoints)])
            expected_times.extend(self.extract_expected_times)
        
        if self.enable_resample.get():
            self.current_checkpoints.extend([("resample", i, desc) for i, desc in enumerate(self.resample_checkpoints)])
            expected_times.extend(self.resample_expected_times)
        
        self.current_eta = sum(expected_times)
        self.checkpoint_start_times = []
        self.performance_ratios = []
        self.start_eta_timer()
    
    def start_eta_timer(self):
        """Start the ETA update timer"""
        self._timer_stopped = False
        if self.eta_timer:
            self.root.after_cancel(self.eta_timer)
        self.eta_timer = self.root.after(1000, self.update_eta_continuously)
    
    def stop_eta_timer(self):
        """Stop the ETA update timer"""
        self._timer_stopped = True
        if self.eta_timer:
            self.root.after_cancel(self.eta_timer)
            self.eta_timer = None
    
    def update_eta_continuously(self):
        """Update ETA and progress every second"""
        if self._timer_stopped or not self.start_time:
            return
            
        if self.current_eta > 0:
            self.current_eta = max(0, self.current_eta - 1)
        
        # Calculate smooth progress based on elapsed time vs total estimated time
        total_elapsed = time.time() - self.start_time
        
        # Calculate total estimated time based on ONLY enabled functions
        total_estimated = 0
        if self.enable_extract.get():
            total_estimated += sum(self.extract_expected_times)
        if self.enable_resample.get():
            total_estimated += sum(self.resample_expected_times)
        
        # Adjust total estimated time based on performance if we have data
        if self.performance_ratios:
            avg_ratio = sum(self.performance_ratios) / len(self.performance_ratios)
            total_estimated *= avg_ratio
        
        # Calculate progress percentage based on time
        if total_estimated > 0:
            time_progress = min((total_elapsed / total_estimated) * 100, 99)
            # Ensure progress never goes backwards
            current_progress = self.progress['value']
            smooth_progress = max(time_progress, current_progress)
            self.progress['value'] = smooth_progress
        
        # Only update status from ETA timer if no recent checkpoint activity
        # This prevents conflicts with checkpoint-specific status updates
        started_checkpoints = len(self.checkpoint_start_times)
        completed_checkpoints = len(self.performance_ratios)
        total_checkpoints = len(self.current_checkpoints)
        
        # Only update if we're not currently processing a checkpoint
        current_time = time.time()
        recent_checkpoint_activity = False
        if self.checkpoint_start_times:
            time_since_last_checkpoint = current_time - self.checkpoint_start_times[-1]
            recent_checkpoint_activity = time_since_last_checkpoint < 2  # Within 2 seconds
        
        # Update status only if no recent checkpoint activity
        if not recent_checkpoint_activity and total_checkpoints > 0:
            if completed_checkpoints < total_checkpoints:
                next_checkpoint = self.current_checkpoints[completed_checkpoints][2]
                eta_str = f"{self.current_eta / 60:.1f} min" if self.current_eta > 60 else f"{self.current_eta:.0f} sec"
                status_text = f"Waiting [{completed_checkpoints + 1}/{total_checkpoints}] {next_checkpoint}... (ETA: {eta_str})"
                self.status_label.config(text=status_text)
        
        if not self._timer_stopped:
            self.eta_timer = self.root.after(1000, self.update_eta_continuously)
    
    def recalibrate_eta(self, completed_checkpoint_index):
        """Recalibrate ETA based on performance"""
        if not self.performance_ratios:
            return
        
        # Calculate average performance ratio from completed checkpoints
        valid_ratios = [r for r in self.performance_ratios if r is not None]
        if not valid_ratios:
            return
        
        # Use a weighted average that gives more weight to recent performance
        if len(valid_ratios) == 1:
            avg_ratio = valid_ratios[0]
        else:
            # Weight recent ratios more heavily
            weights = [i + 1 for i in range(len(valid_ratios))]
            weighted_sum = sum(ratio * weight for ratio, weight in zip(valid_ratios, weights))
            weight_total = sum(weights)
            avg_ratio = weighted_sum / weight_total
        
        # Calculate remaining expected time based on actual performance
        remaining_time = 0
        for i in range(completed_checkpoint_index + 1, len(self.current_checkpoints)):
            func_type, func_step, _ = self.current_checkpoints[i]
            expected_time = self.extract_expected_times[func_step] if func_type == "extract" else self.resample_expected_times[func_step]
            remaining_time += expected_time * avg_ratio
        
        # Smooth the ETA change to prevent sudden jumps
        new_eta = max(0, remaining_time)
        if self.current_eta > 0:
            # Blend old and new ETA to smooth transitions (70% new, 30% old)
            self.current_eta = 0.7 * new_eta + 0.3 * self.current_eta
        else:
            self.current_eta = new_eta
    
    def parse_checkpoint_output(self, output_line):
        """Parse output line to detect checkpoint progress"""
        line = output_line.strip()
        
        # Check for checkpoint start pattern - accept any [X/Y] format
        start_match = re.search(r'\[(\d+)/(\d+)\]\s*(.+?)\.\.\.\s*$', line)
        if start_match:
            step_num = int(start_match.group(1))
            total_steps = int(start_match.group(2))
            checkpoint_desc = start_match.group(3).strip()
            
            # Record the start time for this checkpoint
            self.checkpoint_start_times.append(time.time())
            
            # Update status with our own checkpoint tracking
            current_checkpoint_index = len(self.checkpoint_start_times) - 1
            if current_checkpoint_index < len(self.current_checkpoints):
                our_checkpoint_desc = self.current_checkpoints[current_checkpoint_index][2]
                eta_str = f"{self.current_eta / 60:.1f} min" if self.current_eta > 60 else f"{self.current_eta:.0f} sec"
                status_text = f"[{current_checkpoint_index + 1}/{len(self.current_checkpoints)}] {our_checkpoint_desc}... (ETA: {eta_str})"
                self.status_label.config(text=status_text)
        
        # Check for completion pattern
        completion_match = re.search(r'\[OK\]\s*(.+?):\s*([\d\.]+)s', line)
        if completion_match and len(self.checkpoint_start_times) > len(self.performance_ratios):
            actual_time = float(completion_match.group(2))
            checkpoint_index = len(self.performance_ratios)
            
            if checkpoint_index < len(self.current_checkpoints):
                func_type, func_step, _ = self.current_checkpoints[checkpoint_index]
                expected_time = self.extract_expected_times[func_step] if func_type == "extract" else self.resample_expected_times[func_step]
                ratio = actual_time / expected_time if expected_time > 0 else 1.0
                self.performance_ratios.append(ratio)
                self.recalibrate_eta(checkpoint_index)
                
                # Update status when checkpoint completes
                eta_str = f"{self.current_eta / 60:.1f} min" if self.current_eta > 60 else f"{self.current_eta:.0f} sec"
                status_text = f"✓ [{checkpoint_index + 1}/{len(self.current_checkpoints)}] {self.current_checkpoints[checkpoint_index][2]} (ETA: {eta_str})"
                self.status_label.config(text=status_text)
    
    def update_progress(self, step_name):
        """Update progress display"""
        self.status_label.config(text=step_name)
        self.root.update_idletasks()
    
    def process_data(self):
        # Validation
        if self.enable_extract.get() and not self.input_file_var.get():
            messagebox.showerror("Error", "Please select an input file for extraction")
            return
        
        if not self.output_dir_var.get():
            messagebox.showerror("Error", "Please select an output directory")
            return
        
        if not self.enable_extract.get() and not self.enable_resample.get():
            messagebox.showerror("Error", "Please enable at least one function")
            return
        
        # Additional validation for resample function
        if self.enable_resample.get() and not self.use_extract_output.get():
            if not self.resample_input_file_var.get():
                messagebox.showerror("Error", "Please select an input file for resampling or enable 'Use output from extraction'")
                return
        
        if self.enable_resample.get() and self.use_extract_output.get() and not self.enable_extract.get():
            messagebox.showerror("Error", "Cannot use extraction output if extraction is disabled. Either enable extraction or provide a separate input file for resampling.")
            return
        
        # Start processing in a separate thread to avoid UI freezing
        thread = threading.Thread(target=self.run_processing)
        thread.daemon = True
        thread.start()
    
    def capture_function_output(self, func, *args, **kwargs):
        """Capture function output and parse checkpoints"""
        original_stdout = sys.stdout
        
        class TeeOutput:
            def __init__(self, parent):
                self.parent = parent
                
            def write(self, text):
                original_stdout.write(text)
                for line in text.splitlines():
                    if line.strip():
                        self.parent.parse_checkpoint_output(line)
            
            def flush(self):
                original_stdout.flush()
        
        sys.stdout = TeeOutput(self)
        
        try:
            return func(*args, **kwargs)
        finally:
            sys.stdout = original_stdout
    
    def run_processing(self):
        try:
            # Initialize progress
            self.start_time = time.time()
            self.setup_checkpoint_tracking()
            self.progress['value'] = 0
            
            input_file = self.input_file_var.get()
            output_dir = self.output_dir_var.get()
            extracted_file = None
            
            # Run extract function if enabled
            if self.enable_extract.get():
                self.update_progress("Starting flight data extraction...")
                start_extract = time.time()
                self.log_message("Starting flight data extraction...")
                
                extracted_file = self.capture_function_output(
                    extract_flight_data,
                    input_file,
                    offset1=self.extract_offset1.get(),
                    offset2=self.extract_offset2.get(),
                    output_dir=output_dir
                )
                extract_time = time.time() - start_extract
                self.log_message(f"Successfully created: {extracted_file}")
                self.log_message(f"Extraction completed in {extract_time:.2f} seconds")
            
            # Run resample function if enabled
            if self.enable_resample.get():
                self.update_progress("Starting resampling and cleaning...")
                start_resample = time.time()
                self.log_message("Starting resampling and cleaning...")
                
                # Determine input file for resampling
                if self.use_extract_output.get() and extracted_file:
                    resample_input = extracted_file
                    self.log_message(f"Using extraction output: {extracted_file}")
                elif not self.use_extract_output.get():
                    resample_input = self.resample_input_file_var.get()
                    self.log_message(f"Using specified input file: {resample_input}")
                else:
                    # This should not happen due to validation, but just in case
                    raise ValueError("No valid input file for resampling")
                
                resampled_file = self.capture_function_output(
                    resample_and_clean_data,
                    resample_input,
                    offset1=self.resample_offset1.get(),
                    offset2=self.resample_offset2.get(),
                    offsetP1=self.resample_offsetP1.get(),
                    offsetP2=self.resample_offsetP2.get(),
                    output_dir=output_dir
                )
                resample_time = time.time() - start_resample
                self.log_message(f"Successfully created: {resampled_file}")
                self.log_message(f"Resampling completed in {resample_time:.2f} seconds")
            
            total_time = time.time() - self.start_time
            self.stop_eta_timer()
            self.progress['value'] = 100
            self.status_label.config(text="Processing completed successfully!")
            self.log_message(f"[SUCCESS] All processing completed successfully!")
            self.log_message(f"Total processing time: {total_time:.2f} seconds")
            
            # Launch dashboard if option is enabled
            if self.launch_dashboard.get():
                self.launch_dashboard_app()
            
        except Exception as e:
            # Ensure stdout is restored and ETA timer is stopped
            sys.stdout = sys.__stdout__
            self.stop_eta_timer()
            self.status_label.config(text="Error occurred during processing")
            self.log_message(f"[ERROR] Error: {str(e)}")
            messagebox.showerror("Error", f"An error occurred: {str(e)}")
        
        finally:
            # Ensure stdout is always restored and ETA timer is stopped
            sys.stdout = sys.__stdout__
            self.stop_eta_timer()
    
    def launch_dashboard_app(self):
        """Launch the dashboard using streamlit with the output directory"""
        try:
            self.log_message("\n[INFO] Launching dashboard...")
            output_dir = self.output_dir_var.get()
            
            # Launch streamlit directly with the output directory as argument
            venv_python = os.path.join(os.getcwd(), ".venv", "Scripts", "python.exe")
            dashboard_script = os.path.join(os.getcwd(), "dashboard.py")
            
            if os.path.exists(venv_python) and os.path.exists(dashboard_script):
                cmd = [venv_python, "-m", "streamlit", "run", dashboard_script, "--", output_dir]
                self.dashboard_process = subprocess.Popen(cmd)
                self.log_message(f"[SUCCESS] Dashboard launched successfully with data directory: {output_dir}")
            else:
                self.log_message(f"[ERROR] Python or dashboard script not found")
                messagebox.showwarning("Warning", "Could not find Python environment or dashboard script")
                
        except Exception as e:
            self.log_message(f"[ERROR] Error launching dashboard: {str(e)}")
            messagebox.showerror("Error", f"Failed to launch dashboard: {str(e)}")
    
    def detect_existing_dashboard(self):
        """Detect if dashboard is already running"""
        try:
            result = subprocess.run(['netstat', '-ano'], capture_output=True, text=True, shell=True, encoding='utf-8', errors='ignore')
            ports_found = []
            
            for line in result.stdout.split('\n'):
                for port in range(8501, 8550):
                    if f':{port}' in line and 'LISTENING' in line and str(port) not in ports_found:
                        ports_found.append(str(port))
            
            if ports_found:
                self.log_message(f"[INFO] Detected existing dashboard(s) on port(s): {', '.join(ports_found)}")
        except Exception:
            pass
    
    def shutdown_dashboard(self):
        """Shutdown the dashboard process"""
        try:
            if self.dashboard_process:
                self.dashboard_process.terminate()
                self.log_message("[INFO] Dashboard process terminated")
                self.dashboard_process = None
        except Exception as e:
            self.log_message(f"[ERROR] Error shutting down dashboard: {str(e)}")
    
    def kill_streamlit_processes(self):
        """Force kill Streamlit processes using common ports"""
        try:
            result = subprocess.run(['netstat', '-ano'], capture_output=True, text=True, shell=True, encoding='utf-8', errors='ignore')
            killed = 0
            
            for line in result.stdout.split('\n'):
                for port in range(8501, 8550):
                    if f':{port}' in line and 'LISTENING' in line:
                        parts = line.split()
                        if len(parts) > 4 and parts[-1].isdigit():
                            subprocess.run(['taskkill', '/f', '/pid', parts[-1]], capture_output=True, encoding='utf-8', errors='ignore')
                            killed += 1
            
            # Also kill by process name
            subprocess.run(['taskkill', '/f', '/im', 'streamlit.exe'], capture_output=True, encoding='utf-8', errors='ignore')
            
            if killed > 0:
                self.log_message(f"[SUCCESS] Killed {killed} dashboard processes")
            else:
                self.log_message("[INFO] No dashboard processes found")
                
        except Exception as e:
            self.log_message(f"[ERROR] Error during process cleanup: {str(e)}")
    
    def on_closing(self):
        """Handle GUI closing event"""
        if self.dashboard_process:
            if messagebox.askokcancel("Quit", "Dashboard is running. Close dashboard and quit?"):
                self.shutdown_dashboard()
                self.root.destroy()
                sys.exit(0)
        else:
            self.root.destroy()
            sys.exit(0)

def GUI_launch():
    root = tk.Tk()
    app = FlightDataProcessorGUI(root)
    root.mainloop()

if __name__ == '__main__':
    GUI_launch()