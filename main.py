"""
Main script to process multiple flight data files.
Simply call extract_flight_data() with different file paths to process multiple files.
Each output will be automatically named based on the input filename with "_extracted" suffix.
"""

from extract_data import extract_flight_data

# Process a single file
if __name__ == '__main__':
    # Example 1: Process the main flight data file
    print("Starting flight data extraction...\n")
    
    output_file = extract_flight_data(
        "C:\\Users\\Antonin\\Desktop\\Antonin\\folder bin\\MomentaVol5_clean.bin",
        offset1=7,
        offset2=0,
        output_dir="Project Results"
    )
    print(f"Successfully created: {output_file}")
    
    
    # Example 2: Process additional files (uncomment and modify paths as needed)
    # output_file2 = extract_flight_data(
    #     "C:\\Users\\Antonin\\Desktop\\path\\to\\another_flight.bin",
    #     offset1=1,
    #     offset2=0,
    #     output_dir="C:\\Users\\Antonin\\Desktop\\Project Results"
    # )
    # print(f"Successfully created: {output_file2}")
    
    
    # Example 3: Process multiple files in a loop
    # files_to_process = [
    #     "C:\\Users\\Antonin\\Desktop\\Antonin\\folder bin\\MomentaVol1.bin",
    #     "C:\\Users\\Antonin\\Desktop\\Antonin\\folder bin\\MomentaVol2.bin",
    #     "C:\\Users\\Antonin\\Desktop\\Antonin\\folder bin\\MomentaVol3.bin",
    # ]
    # for file_path in files_to_process:
    #     output_file = extract_flight_data(file_path, offset1=1, offset2=0, output_dir="C:\\Users\\Antonin\\Desktop\\Project Results")
    #     print(f"Successfully created: {output_file}")

