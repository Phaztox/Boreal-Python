import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import threading
import subprocess
import os
import time
import sys
import io
import re
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
        
        # Checkpoint tracking
        self.extract_checkpoints = [
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
            "Saving resampled data to HDF5 file"
        ]
        
        # Expected times (in seconds) based on reference log (removed first checkpoint that has no timing)
        # Extract: [1.81s, 2.47s, 2.64s, 15.36s, 40.61s] = ~62.89s
        self.extract_expected_times = [1.8, 2.5, 2.6, 15.4, 40.6]  
        # Resample: [9.43s, 0.88s, 6.04s, 1.05s, 10.13s] = ~27.53s
        self.resample_expected_times = [9.4, 0.9, 6.0, 1.1, 10.1]
        
        # Continuous ETA tracking
        self.eta_timer = None
        self.last_eta_update = None
        self.current_eta = 0
        self.eta_update_interval = 1000  # Update every 1000ms (1 second)
        self.checkpoint_weights = []  # Weight of each checkpoint in total time
        self._parsing_checkpoint = False  # Prevent recursion in checkpoint parsing
        self._updating_eta = False  # Prevent recursion in ETA updates  
        self._timer_stopped = False  # Flag to control timer stopping
        
        # Tracking variables
        self.current_checkpoints = []
        self.checkpoint_start_times = []
        self.checkpoint_actual_times = []
        self.performance_ratios = []  # Actual time / Expected time
        self.total_expected_time = 0
        self.current_function = None
        
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
        
        self.total_expected_time = sum(expected_times)
        self.checkpoint_start_times = []
        self.checkpoint_actual_times = []
        self.performance_ratios = []
        
        # Calculate weights for each checkpoint (percentage of total time)
        self.checkpoint_weights = [t / self.total_expected_time for t in expected_times]
        
        # Initialize ETA
        self.current_eta = self.total_expected_time
        self.last_eta_update = time.time()
        
        # Start ETA timer
        self.start_eta_timer()
        
        # Debug: Show checkpoint setup
        self.log_message(f"[DEBUG] Setup {len(self.current_checkpoints)} checkpoints:")
        for i, (func_type, func_step, desc) in enumerate(self.current_checkpoints):
            expected_time = expected_times[i] if i < len(expected_times) else 0
            self.log_message(f"[DEBUG] {i}: {func_type}[{func_step}] - {desc} (expected: {expected_time}s)")
    
    def start_eta_timer(self):
        """Start the continuous ETA update timer"""
        self._timer_stopped = False
        if self.eta_timer:
            self.root.after_cancel(self.eta_timer)
        # Schedule the first update instead of calling directly to prevent recursion
        self.eta_timer = self.root.after(self.eta_update_interval, self.update_eta_continuously)
    
    def stop_eta_timer(self):
        """Stop the continuous ETA update timer"""
        self._timer_stopped = True
        if self.eta_timer:
            self.root.after_cancel(self.eta_timer)
            self.eta_timer = None
    
    def update_eta_continuously(self):
        """Update ETA every second, independent of checkpoints"""
        try:
            # Prevent multiple simultaneous updates
            if getattr(self, '_updating_eta', False):
                return
            
            self._updating_eta = True
            
            if self.start_time and self.current_eta > 0:
                current_time = time.time()
                
                # Decrease ETA by elapsed time since last update
                if self.last_eta_update:
                    time_passed = current_time - self.last_eta_update
                    self.current_eta = max(0, self.current_eta - time_passed)
                
                self.last_eta_update = current_time
                
                # Update the status label if we're not in the middle of a checkpoint update
                if hasattr(self, 'checkpoint_actual_times'):
                    completed_checkpoints = len(self.checkpoint_actual_times)
                    total_checkpoints = len(self.current_checkpoints)
                    
                    if completed_checkpoints < total_checkpoints:
                        # Calculate progress percentage
                        elapsed_total = sum(self.checkpoint_actual_times)
                        total_estimated = elapsed_total + self.current_eta
                        progress_percent = (elapsed_total / total_estimated) * 100 if total_estimated > 0 else 0
                        
                        # Ensure minimum progress based on completed checkpoints
                        min_progress = (completed_checkpoints / total_checkpoints) * 100
                        progress_percent = max(progress_percent, min_progress)
                        
                        self.progress['value'] = min(progress_percent, 100)
                        
                        # Update status with live ETA
                        if completed_checkpoints < len(self.current_checkpoints):
                            if completed_checkpoints < len(self.checkpoint_start_times):
                                # Currently processing a checkpoint
                                current_checkpoint_desc = self.current_checkpoints[completed_checkpoints][2]
                                status = f"{current_checkpoint_desc}... ({completed_checkpoints + 1}/{total_checkpoints})"
                            else:
                                # Between checkpoints or waiting for next
                                status = f"Processing... ({completed_checkpoints}/{total_checkpoints})"
                            
                            if self.current_eta > 0:
                                status += f" (ETA: {int(self.current_eta)}s)"
                            
                            self.status_label.config(text=status)
                
                # Schedule next update if ETA is still positive
                if self.current_eta > 0 and not getattr(self, '_timer_stopped', False):
                    self.eta_timer = self.root.after(self.eta_update_interval, self.update_eta_continuously)
                
        except Exception as e:
            # Silently handle any errors in ETA updates to not disrupt processing
            pass
        finally:
            self._updating_eta = False
    
    def recalibrate_eta(self, completed_checkpoint_index):
        """Recalibrate ETA based on completed checkpoint performance"""
        if not self.performance_ratios:
            return
        
        # Calculate average performance ratio
        avg_ratio = sum(self.performance_ratios) / len(self.performance_ratios)
        
        # Calculate remaining expected time
        remaining_expected_time = 0
        for i in range(completed_checkpoint_index + 1, len(self.current_checkpoints)):
            func_type, func_step, _ = self.current_checkpoints[i]
            if func_type == "extract":
                expected_time = self.extract_expected_times[func_step]
            else:
                expected_time = self.resample_expected_times[func_step]
            remaining_expected_time += expected_time * avg_ratio
        
        # Smooth the ETA adjustment to avoid sudden jumps
        if self.current_eta > 0:
            # Blend the new estimate with the current ETA (70% new, 30% current)
            self.current_eta = 0.7 * remaining_expected_time + 0.3 * self.current_eta
        else:
            self.current_eta = remaining_expected_time
        
        self.last_eta_update = time.time()
    
    def parse_checkpoint_output(self, output_line):
        """Parse output line to detect checkpoint progress"""
        line = output_line.strip()
        
        # Debug logging
        if '[' in line and ']' in line:
            self.log_message(f"[DEBUG] Parsing line: {line}")
        
        # Check for checkpoint start patterns
        start_pattern = r'\[(\d+)/(\d+)\]\s*(.+?)\.\.\.$'
        
        # Check for completion patterns - match various formats
        completion_patterns = [
            r'\[OK\]\s*(.+?):\s*([\d\.]+)s',
            r'\[\*\]\s*(.+?)\.\.\.$',  # Sometimes there's just [*] pattern
            r'\[OK\]\s*(.+?)\s*\([^)]*\):\s*([\d\.]+)s'  # With parentheses info
        ]
        
        # Check for checkpoint start
        start_match = re.search(start_pattern, line)
        if start_match:
            step_num = int(start_match.group(1))
            total_steps = int(start_match.group(2))
            checkpoint_desc = start_match.group(3).strip()
            
            self.log_message(f"[DEBUG] Found checkpoint start: {checkpoint_desc}")
            
            # Find which checkpoint this corresponds to using fuzzy matching
            checkpoint_index = self.find_checkpoint_match(checkpoint_desc)
            
            if checkpoint_index is not None:
                self.log_message(f"[DEBUG] Matched to index {checkpoint_index}: {self.current_checkpoints[checkpoint_index][2]}")
                self.checkpoint_start_times.append(time.time())
                self.update_checkpoint_progress(checkpoint_index, checkpoint_desc, started=True)
            else:
                self.log_message(f"[DEBUG] No match found for: {checkpoint_desc}")
        
        # Check for completion patterns
        for pattern in completion_patterns:
            completion_match = re.search(pattern, line)
            if completion_match:
                if len(completion_match.groups()) >= 2:
                    # Has timing info
                    task_desc = completion_match.group(1).strip()
                    actual_time = float(completion_match.group(2))
                    
                    self.log_message(f"[DEBUG] Found completion: {task_desc} in {actual_time}s")
                    
                    if self.checkpoint_start_times:
                        self.checkpoint_actual_times.append(actual_time)
                        
                        # Find the most recent started checkpoint
                        if len(self.checkpoint_actual_times) <= len(self.current_checkpoints):
                            checkpoint_index = len(self.checkpoint_actual_times) - 1
                            self.log_message(f"[DEBUG] Marking checkpoint {checkpoint_index} as completed")
                            self.update_checkpoint_progress(checkpoint_index, None, completed=True, actual_time=actual_time)
                break
    
    def find_checkpoint_match(self, checkpoint_desc):
        """Find best matching checkpoint using fuzzy string matching"""
        checkpoint_desc_lower = checkpoint_desc.lower()
        
        # Try exact substring matching first
        for i, (func_type, func_step, desc) in enumerate(self.current_checkpoints):
            desc_lower = desc.lower()
            
            # Check if key words match
            checkpoint_words = set(checkpoint_desc_lower.split())
            desc_words = set(desc_lower.split())
            
            # Remove common words that might confuse matching
            common_words = {'processing', 'data', 'and', 'the', 'with', 'to', 'from'}
            checkpoint_words -= common_words
            desc_words -= common_words
            
            # Calculate word overlap
            if checkpoint_words and desc_words:
                overlap = len(checkpoint_words & desc_words) / len(checkpoint_words | desc_words)
                if overlap > 0.3:  # At least 30% word overlap
                    return i
            
            # Fallback: check if any significant words are contained
            for word in checkpoint_words:
                if len(word) > 3 and word in desc_lower:
                    return i
        
        return None
        """Parse output line to detect checkpoint progress"""
        line = output_line.strip()
        
        # Check for checkpoint start patterns
        extract_pattern = r'\[(\d+)/(\d+)\]\s*(.+?)\.\.\.$'
        resample_pattern = r'\[(\d+)/(\d+)\]\s*(.+?)\.\.\.$'
        
        # Check for completion patterns
        completion_pattern = r'\[OK\]\s*(.+?):\s*([\d\.]+)s'
        
        match = re.search(extract_pattern, line) or re.search(resample_pattern, line)
        if match:
            step_num = int(match.group(1)) - 1  # Convert to 0-indexed
            checkpoint_desc = match.group(3).strip()
            
            # Find which function and checkpoint this corresponds to
            checkpoint_index = None
            for i, (func_type, func_step, desc) in enumerate(self.current_checkpoints):
                if checkpoint_desc.lower() in desc.lower():
                    checkpoint_index = i
                    break
            
            if checkpoint_index is not None:
                self.checkpoint_start_times.append(time.time())
                self.update_checkpoint_progress(checkpoint_index, checkpoint_desc, started=True)
        
        # Check for completion
        completion_match = re.search(completion_pattern, line)
        if completion_match and self.checkpoint_start_times:
            actual_time = float(completion_match.group(2))
            self.checkpoint_actual_times.append(actual_time)
            
            # Find the most recent checkpoint
            if len(self.checkpoint_actual_times) <= len(self.current_checkpoints):
                checkpoint_index = len(self.checkpoint_actual_times) - 1
                self.update_checkpoint_progress(checkpoint_index, None, completed=True, actual_time=actual_time)
    
    def update_checkpoint_progress(self, checkpoint_index, checkpoint_desc=None, started=False, completed=False, actual_time=None):
        """Update progress based on checkpoint completion"""
        if completed and actual_time is not None:
            # Calculate performance ratio for this checkpoint
            func_type, func_step, _ = self.current_checkpoints[checkpoint_index]
            
            if func_type == "extract":
                expected_time = self.extract_expected_times[func_step]
            else:
                expected_time = self.resample_expected_times[func_step]
            
            ratio = actual_time / expected_time if expected_time > 0 else 1.0
            self.performance_ratios.append(ratio)
            
            # Recalibrate ETA based on new performance data
            self.recalibrate_eta(checkpoint_index)
        
        # The continuous ETA timer will handle the status updates
        self.root.update_idletasks()
    
    def update_progress(self, step_name, current_step=None):
        """Fallback update progress method for non-checkpoint updates"""
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
    
    def capture_function_output(self, func, *args, **kwargs):
        """Capture function output and parse checkpoints"""
        # Create a custom stdout that captures output
        original_stdout = sys.stdout
        captured_output = io.StringIO()
        
        # Reference to self for the inner class
        parent_self = self
        
        class TeeOutput:
            def write(self, text):
                original_stdout.write(text)
                captured_output.write(text)
                # Parse each line for checkpoints with recursion protection
                try:
                    for line in text.split('\n'):
                        if line.strip() and not getattr(parent_self, '_parsing_checkpoint', False):
                            parent_self._parsing_checkpoint = True
                            try:
                                parent_self.parse_checkpoint_output(line)
                            finally:
                                parent_self._parsing_checkpoint = False
                except Exception:
                    pass  # Silently ignore parsing errors
            
            def flush(self):
                original_stdout.flush()
                captured_output.flush()
        
        tee = TeeOutput()
        sys.stdout = tee
        
        try:
            result = func(*args, **kwargs)
            return result
        finally:
            sys.stdout = original_stdout
    
    def run_processing(self):
        try:
            # Initialize progress
            self.start_time = time.time()
            self.current_step = 0
            
            # Setup checkpoint tracking
            self.setup_checkpoint_tracking()
            
            self.progress['value'] = 0
            
            input_file = self.input_file_var.get()
            output_dir = self.output_dir_var.get()
            
            extracted_file = None
            
            # Run extract function if enabled
            if self.enable_extract.get():
                self.current_function = "extract"
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
                self.current_function = "resample"
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