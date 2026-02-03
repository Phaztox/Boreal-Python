import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
import subprocess
import os
import time
from extract_data import extract_flight_data
from resample_and_clean import resample_and_clean_data

class FlightDataProcessorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Flight Data Processor")
        self.root.geometry("800x750")
        
        # Variables
        self.input_file_var = tk.StringVar()
        self.output_dir_var = tk.StringVar(value="Project Results")
        
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
        self.current_step = 0
        self.total_steps = 0
        self.dashboard_process = None
        
        self.setup_ui()
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)
        self.detect_existing_dashboard()
    
    def setup_ui(self):
        # Main frame with scrollbar
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), padx=10, pady=10)
        main_frame.columnconfigure(1, weight=1)
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        
        row = 0
        
        # Title
        title_label = ttk.Label(main_frame, text="Flight Data Processor", font=("Arial", 16, "bold"))
        title_label.grid(row=row, column=0, columnspan=3, pady=(0, 20))
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
        
        # Separator
        ttk.Separator(main_frame, orient='horizontal').grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)
        row += 1
        
        # Extract function section
        extract_frame = ttk.LabelFrame(main_frame, text="Extract Function", padding="10")
        extract_frame.grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=5)
        extract_frame.columnconfigure(1, weight=1)
        
        ttk.Checkbutton(extract_frame, text="Enable Extract Function", variable=self.enable_extract).grid(row=0, column=0, columnspan=2, sticky=tk.W, pady=5)
        
        ttk.Label(extract_frame, text="Offset 1:").grid(row=1, column=0, sticky=tk.W, pady=2)
        ttk.Entry(extract_frame, textvariable=self.extract_offset1, width=10).grid(row=1, column=1, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(extract_frame, text="Offset 2:").grid(row=2, column=0, sticky=tk.W, pady=2)
        ttk.Entry(extract_frame, textvariable=self.extract_offset2, width=10).grid(row=2, column=1, sticky=tk.W, padx=(5, 0))
        
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
        
        ttk.Label(resample_frame, text="Offset 2:").grid(row=4, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offset2, width=10).grid(row=4, column=1, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(resample_frame, text="Offset P1:").grid(row=5, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offsetP1, width=10).grid(row=5, column=1, sticky=tk.W, padx=(5, 0))
        
        ttk.Label(resample_frame, text="Offset P2:").grid(row=6, column=0, sticky=tk.W, pady=2)
        ttk.Entry(resample_frame, textvariable=self.resample_offsetP2, width=10).grid(row=6, column=1, sticky=tk.W, padx=(5, 0))
        
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
        ttk.Separator(main_frame, orient='horizontal').grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)
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
        self.root.update_idletasks()    
    def update_progress(self, step_name, current_step=None):
        """Update progress bar and show ETA"""
        if current_step is not None:
            self.current_step = current_step
        else:
            self.current_step += 1
            
        if self.total_steps > 0:
            progress_percent = (self.current_step / self.total_steps) * 100
            self.progress['value'] = progress_percent
            
            # Calculate ETA
            if self.start_time and self.current_step > 0:
                elapsed = time.time() - self.start_time
                if self.current_step < self.total_steps:
                    avg_time_per_step = elapsed / self.current_step
                    remaining_steps = self.total_steps - self.current_step
                    eta = avg_time_per_step * remaining_steps
                    eta_str = f" (ETA: {eta:.0f}s)"
                else:
                    eta_str = " (Complete)"
                    
                progress_text = f"{step_name} - {progress_percent:.1f}%{eta_str}"
                self.status_label.config(text=progress_text)
            else:
                self.status_label.config(text=f"{step_name} - {progress_percent:.1f}%")
        else:
            self.status_label.config(text=step_name)
        
        self.root.update_idletasks()
    
    def process_data(self):
        # Validation
        if not self.input_file_var.get():
            messagebox.showerror("Error", "Please select an input file")
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
    
    def run_processing(self):
        try:
            # Initialize progress
            self.start_time = time.time()
            self.current_step = 0
            
            # Calculate total steps
            self.total_steps = 0
            if self.enable_extract.get():
                self.total_steps += 1
            if self.enable_resample.get():
                self.total_steps += 1
            
            self.progress['value'] = 0
            
            input_file = self.input_file_var.get()
            output_dir = self.output_dir_var.get()
            
            extracted_file = None
            
            # Run extract function if enabled
            if self.enable_extract.get():
                self.update_progress("Extracting data...", 1)
                start_extract = time.time()
                self.log_message("Starting flight data extraction...")
                
                extracted_file = extract_flight_data(
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
                next_step = 1 if not self.enable_extract.get() else 2
                self.update_progress("Resampling and cleaning data...", next_step)
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
                
                resampled_file = resample_and_clean_data(
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
            self.update_progress("Processing completed successfully!", self.total_steps)
            self.log_message(f"[SUCCESS] All processing completed successfully!")
            self.log_message(f"Total processing time: {total_time:.2f} seconds")
            
            # Launch dashboard if option is enabled
            if self.launch_dashboard.get():
                self.launch_dashboard_app()
            
        except Exception as e:
            self.status_label.config(text="Error occurred during processing")
            self.log_message(f"[ERROR] Error: {str(e)}")
            messagebox.showerror("Error", f"An error occurred: {str(e)}")
        
        finally:
            # Only set progress to 100% if we completed all steps successfully
            if hasattr(self, 'current_step') and hasattr(self, 'total_steps'):
                if self.current_step >= self.total_steps:
                    self.progress['value'] = 100
    
    def launch_dashboard_app(self):
        """Launch the dashboard using the batch file"""
        try:
            self.log_message("\n[INFO] Launching dashboard...")
            bat_file_path = os.path.join(os.getcwd(), "launch_dashboard.bat")
            
            if os.path.exists(bat_file_path):
                self.dashboard_process = subprocess.Popen([bat_file_path], shell=True)
                self.log_message("[SUCCESS] Dashboard launched successfully!")
            else:
                self.log_message(f"[ERROR] Dashboard batch file not found: {bat_file_path}")
                messagebox.showwarning("Warning", f"Dashboard batch file not found: {bat_file_path}")
                
        except Exception as e:
            self.log_message(f"[ERROR] Error launching dashboard: {str(e)}")
            messagebox.showerror("Error", f"Failed to launch dashboard: {str(e)}")
    
    def detect_existing_dashboard(self):
        """Detect if dashboard is already running"""
        try:
            result = subprocess.run(['netstat', '-ano'], capture_output=True, text=True, shell=True, encoding='utf-8', errors='ignore')
            dashboard_ports = []
            
            for line in result.stdout.split('\n'):
                for port in ['8501', '8502', '8503']:
                    if f':{port}' in line and 'LISTENING' in line:
                        dashboard_ports.append(port)
            
            if dashboard_ports:
                unique_ports = list(set(dashboard_ports))
                self.log_message(f"[INFO] Detected existing dashboard(s) on port(s): {', '.join(unique_ports)}")
        except Exception:
            pass
    
    def shutdown_dashboard(self):
        """Shutdown the dashboard process"""
        try:
            if self.dashboard_process:
                self.dashboard_process.terminate()
                self.log_message("[INFO] Dashboard process terminated")
                self.dashboard_process = None
            self.kill_streamlit_processes()
        except Exception as e:
            self.log_message(f"[ERROR] Error shutting down dashboard: {str(e)}")
    
    def kill_streamlit_processes(self):
        """Force kill Streamlit processes using common ports"""
        try:
            # Kill by port
            netstat_result = subprocess.run(['netstat', '-ano'], capture_output=True, text=True, shell=True, encoding='utf-8', errors='ignore')
            processes_killed = 0
            
            for line in netstat_result.stdout.split('\n'):
                for port in ['8501', '8502', '8503']:
                    if f':{port}' in line and 'LISTENING' in line:
                        parts = line.split()
                        if len(parts) > 4 and parts[-1].isdigit():
                            subprocess.run(['taskkill', '/f', '/pid', parts[-1]], capture_output=True, encoding='utf-8', errors='ignore')
                            processes_killed += 1
            
            # Kill by process name
            subprocess.run(['taskkill', '/f', '/im', 'streamlit.exe'], capture_output=True, encoding='utf-8', errors='ignore')
            
            if processes_killed > 0:
                self.log_message(f"[SUCCESS] Killed {processes_killed} dashboard processes")
            else:
                self.log_message("[INFO] No dashboard processes found")
                
        except Exception as e:
            self.log_message(f"[ERROR] Error during process cleanup: {str(e)}")

    
    def on_closing(self):
        """Handle GUI closing event"""
        if self.dashboard_process and messagebox.askokcancel("Quit", "Dashboard is running. Close dashboard and quit?"):
            self.shutdown_dashboard()
        self.root.destroy()

def main():
    root = tk.Tk()
    app = FlightDataProcessorGUI(root)
    root.mainloop()

if __name__ == '__main__':
    main()