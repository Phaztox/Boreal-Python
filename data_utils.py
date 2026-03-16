import h5py
import pandas as pd


def load_h5_data(filename, dataset_name=None):
    """
    Load data from HDF5 file.
    
    Args:
        filename (str): Path to the HDF5 file
        dataset_name (str, optional): Specific dataset to load. If None, loads all datasets.
        
    Returns:
        dict or pd.DataFrame: If dataset_name specified, returns DataFrame with that dataset.
                              If None, returns dict of all datasets.
                              
    Example:
        # Load specific dataset as DataFrame with column names
        df = load_h5_data('resultats_test/flight_data.h5', 'AD_NAVIGATION')
        
        # Load all datasets
        all_data = load_h5_data('resultats_test/flight_data.h5')
    """
    with h5py.File(filename, 'r') as hf:
        if dataset_name:
            data = hf[dataset_name][:]
            label_key = f'{dataset_name}_label' if f'{dataset_name}_label' in hf.attrs else f'{dataset_name}_LABEL'
            
            # Try to get column labels
            if label_key in hf.attrs:
                columns = hf.attrs[label_key]
                # Handle bytes encoding if needed
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                return pd.DataFrame(data, columns=columns)
            else:
                return pd.DataFrame(data)
        else:
            # Load all datasets
            data_dict = {}
            for key in hf.keys():
                data_dict[key] = hf[key][:]
            return data_dict


def get_dataframe(filename, dataset_name):
    """
    Convenience function to load a single dataset as a pandas DataFrame.
    
    Args:
        filename (str): Path to the HDF5 file
        dataset_name (str): Name of the dataset to load
        
    Returns:
        pd.DataFrame: Data with proper column names
    """
    return load_h5_data(filename, dataset_name)


def list_datasets(filename):
    """
    List all available datasets in an HDF5 file.
    
    Args:
        filename (str): Path to the HDF5 file
        
    Returns:
        list: Names of all datasets in the file
    """
    with h5py.File(filename, 'r') as hf:
        return list(hf.keys())


def get_dataset_info(filename):
    """
    Get information about all datasets in an HDF5 file (shape, dtype, size).
    
    Args:
        filename (str): Path to the HDF5 file
        
    Returns:
        dict: Information about each dataset
    """
    info = {}
    with h5py.File(filename, 'r') as hf:
        for key in hf.keys():
            dataset = hf[key]
            info[key] = {
                'shape': dataset.shape,
                'dtype': dataset.dtype,
                'size_mb': dataset.nbytes / (1024 ** 2)
            }
    return info


def browse_h5_file(filename):
    """
    Interactive browser for HDF5 files - displays all datasets with summaries.
    Similar to browsing a MATLAB .mat file or CSV in Excel.
    
    Args:
        filename (str): Path to the HDF5 file
    """
    print(f"\n{'='*70}")
    print(f"HDF5 FILE BROWSER: {filename}")
    print(f"{'='*70}\n")
    
    with h5py.File(filename, 'r') as hf:
        print(f"Total datasets: {len(hf.keys())}\n")
        
        for i, dataset_name in enumerate(hf.keys(), 1):
            dataset = hf[dataset_name]
            print(f"{i}. {dataset_name}")
            print(f"   Shape: {dataset.shape}")
            print(f"   Data type: {dataset.dtype}")
            print(f"   Size: {dataset.nbytes / (1024**2):.2f} MB")
            
            # Get column labels if available
            label_key = f'{dataset_name}_label' if f'{dataset_name}_label' in hf.attrs else f'{dataset_name}_LABEL'
            if label_key in hf.attrs:
                columns = hf.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                print(f"   Columns ({len(columns)}): {', '.join(columns)}")
            print()


def preview_dataset(filename, dataset_name, rows=5):
    """
    Preview first N rows of a dataset, like Excel's preview pane.
    
    Args:
        filename (str): Path to the HDF5 file
        dataset_name (str): Name of the dataset to preview
        rows (int): Number of rows to display (default: 5)
        
    Example:
        preview_dataset('resultats_test/MomentaVol5_clean_extracted.h5', 'AD_NAVIGATION', rows=10)
    """
    df = get_dataframe(filename, dataset_name)
    print(f"\n{'='*100}")
    print(f"PREVIEW: {dataset_name} (showing {min(rows, len(df))} of {len(df)} rows)")
    print(f"{'='*100}\n")
    
    # Display with better formatting
    pd.set_option('display.max_columns', None)
    pd.set_option('display.width', None)
    pd.set_option('display.max_colwidth', 15)
    
    print(df.head(rows).to_string())
    print(f"\n✓ {dataset_name}: {df.shape[0]} rows × {df.shape[1]} columns\n")


def export_dataset_to_csv(filename, dataset_name, output_csv):
    """
    Export a single dataset to CSV (useful for analysis in Excel).
    
    Args:
        filename (str): Path to the HDF5 file
        dataset_name (str): Name of the dataset to export
        output_csv (str): Output CSV filename
        
    Example:
        export_dataset_to_csv('resultats_test/MomentaVol5_clean_extracted.h5', 
                             'AD_NAVIGATION', 
                             'AD_NAVIGATION_data.csv')
    """
    df = get_dataframe(filename, dataset_name)
    df.to_csv(output_csv, index=False)
    print(f"✓ Exported {dataset_name} to {output_csv} ({len(df)} rows × {df.shape[1]} columns)")


def search_columns(filename, search_term):
    """
    Search for columns containing a specific term across all datasets.
    
    Args:
        filename (str): Path to the HDF5 file
        search_term (str): Term to search for (case-insensitive)
        
    Example:
        search_columns('resultats_test/MomentaVol5_clean_extracted.h5', 'pressure')
    """
    print(f"\nSearching for '{search_term}' across all columns...\n")
    found = False
    
    with h5py.File(filename, 'r') as hf:
        for dataset_name in hf.keys():
            label_key = f'{dataset_name}_label' if f'{dataset_name}_label' in hf.attrs else f'{dataset_name}_LABEL'
            if label_key in hf.attrs:
                columns = hf.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                
                matching_cols = [col for col in columns if search_term.lower() in col.lower()]
                if matching_cols:
                    print(f"  {dataset_name}:")
                    for col in matching_cols:
                        col_idx = columns.index(col)
                        print(f"    - Column {col_idx}: {col}")
                    found = True
    
    if not found:
        print(f"  No columns found containing '{search_term}'")
    print()


def get_column_statistics(filename, dataset_name, column_name=None):
    """
    Get statistics (min, max, mean, std) for numerical columns.
    
    Args:
        filename (str): Path to the HDF5 file
        dataset_name (str): Name of the dataset
        column_name (str, optional): Specific column to analyze. If None, analyzes all numerical columns.
        
    Example:
        get_column_statistics('resultats_test/MomentaVol5_clean_extracted.h5', 'AD_NAVIGATION', 'Height')
    """
    df = get_dataframe(filename, dataset_name)
    
    print(f"\n{'='*70}")
    print(f"STATISTICS: {dataset_name}")
    print(f"{'='*70}\n")
    
    if column_name:
        if column_name in df.columns:
            col_data = df[column_name]
            print(f"{column_name}:")
            print(f"  Count:  {col_data.count()}")
            print(f"  Min:    {col_data.min():.6f}")
            print(f"  Max:    {col_data.max():.6f}")
            print(f"  Mean:   {col_data.mean():.6f}")
            print(f"  Std:    {col_data.std():.6f}")
            print(f"  NaN:    {col_data.isna().sum()}")
        else:
            print(f"Column '{column_name}' not found. Available columns:")
            print(f"  {', '.join(df.columns.tolist())}")
    else:
        # Show statistics for all numerical columns
        print(df.describe().to_string())
    
    print()


# Interactive browsing example
def interactive_browser(filename):
    """
    Simple interactive browser for exploring HDF5 files.
    Lists all datasets and allows viewing them one by one.
    
    Usage:
        interactive_browser('resultats_test/MomentaVol5_clean_extracted.h5')
    """
    datasets = list_datasets(filename)
    
    while True:
        print(f"\n{'='*70}")
        print(f"HDF5 INTERACTIVE BROWSER")
        print(f"{'='*70}")
        print("\nAvailable datasets:")
        for i, ds in enumerate(datasets, 1):
            print(f"  {i}. {ds}")
        print(f"  0. Exit\n")
        
        try:
            choice = input("Select dataset to preview (enter number): ").strip()
            if choice == '0':
                print("Exiting browser...\n")
                break
            
            idx = int(choice) - 1
            if 0 <= idx < len(datasets):
                dataset_name = datasets[idx]
                preview_dataset(filename, dataset_name, rows=10)
            else:
                print("Invalid choice. Please try again.")
        except ValueError:
            print("Please enter a valid number.")
        except KeyboardInterrupt:
            print("\nExiting browser...\n")
            break


# Example usage in main script:
if __name__ == '__main__':
    # Example H5 file path
    h5_file = 'resultats_test/MomentaVol5_clean_extracted.h5'
    
    # Browse the file (shows all datasets)
    # browse_h5_file(h5_file)
    
    # Preview a specific dataset
    # preview_dataset(h5_file, 'AD_NAVIGATION', rows=10)
    
    # Search for columns
    # search_columns(h5_file, 'pressure')
    
    # Get statistics
    # get_column_statistics(h5_file, 'AD_NAVIGATION', 'Height')
    
    # Interactive browser
    # interactive_browser(h5_file)
    
    # Export to CSV
    # export_dataset_to_csv(h5_file, 'AD_NAVIGATION', 'AD_NAVIGATION_export.csv')
    
    pass
