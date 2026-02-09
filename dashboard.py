"""
Interactive Dashboard for browsing HDF5 flight data files.
A modern web-based UI for exploring your data - similar to Excel or MATLAB viewer.

To run:
    streamlit run dashboard.py -- [data_directory]
"""

import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from pathlib import Path
import os
import sys
from data_utils import (
    list_datasets, 
    get_dataset_info, 
    get_dataframe,
    load_h5_data
)
import h5py

# Page configuration
st.set_page_config(
    page_title="HDF5 Flight Data Browser",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS
st.markdown("""
    <style>
    .main > div {
        padding-top: 2rem;
    }
    .stTabs [data-baseweb="tab-list"] {
        gap: 2rem;
    }
    .stTabs [data-baseweb="tab"] {
        height: 3rem;
        padding-left: 2rem;
        padding-right: 2rem;
    }
    </style>
    """, unsafe_allow_html=True)

# Title
st.title("Flight Data Browser")
st.markdown("Interactive dashboard for exploring HDF5 flight data files")

# Sidebar - File selection
st.sidebar.header("File Selection")

# Get data directory from command line arguments or use default
if len(sys.argv) > 1:
    results_dir = sys.argv[1]
else:
    results_dir = "Processed Data"  # Default directory for processed data files

# Display current data directory
st.sidebar.info(f"📁 Data Directory: {results_dir}")

# Find HDF5 files
if os.path.exists(results_dir):
    h5_files = [f for f in os.listdir(results_dir) if f.endswith('.h5')]
else:
    h5_files = []
    st.sidebar.error(f"Directory '{results_dir}' not found!")

if h5_files:
    selected_file = st.sidebar.selectbox(
        "Select HDF5 file:",
        h5_files,
        index=0
    )
    file_path = os.path.join(results_dir, selected_file)
    
    # File info
    file_size = os.path.getsize(file_path) / (1024**2)  # MB
    st.sidebar.metric("File Size", f"{file_size:.1f} MB")
    
    # Load datasets
    try:
        datasets = list_datasets(file_path)
        dataset_info = get_dataset_info(file_path)
        
        st.sidebar.success(f"{len(datasets)} datasets found")
        
        # Main content tabs
        tab1, tab2, tab3, tab4 = st.tabs(["Overview", "Data Explorer", "Visualization", "Statistics"])
        
        # ==================== TAB 1: OVERVIEW ====================
        with tab1:
            st.header("Dataset Overview")
            
            # Create overview dataframe
            overview_data = []
            for name, info in dataset_info.items():
                # Handle both 1D and 2D datasets
                num_cols = info['shape'][1] if len(info['shape']) > 1 else 1
                overview_data.append({
                    'Dataset': name,
                    'Rows': f"{info['shape'][0]:,}",
                    'Columns': num_cols,
                    'Size (MB)': f"{info['size_mb']:.2f}",
                    'Type': str(info['dtype'])
                })
            
            overview_df = pd.DataFrame(overview_data)
            st.dataframe(overview_df, width='stretch', hide_index=True)
            
            # Total statistics
            col1, col2, col3 = st.columns(3)
            with col1:
                total_rows = sum([info['shape'][0] for info in dataset_info.values()])
                st.metric("Total Rows", f"{total_rows:,}")
            with col2:
                total_size = sum([info['size_mb'] for info in dataset_info.values()])
                st.metric("Total Size", f"{total_size:.1f} MB")
            with col3:
                st.metric("Datasets", len(datasets))
            
            # Dataset details
            st.subheader("Dataset Details")
            for dataset_name in datasets:
                with st.expander(f"{dataset_name}"):
                    info = dataset_info[dataset_name]
                    col1, col2, col3 = st.columns(3)
                    col1.metric("Rows", f"{info['shape'][0]:,}")
                    num_cols = info['shape'][1] if len(info['shape']) > 1 else 1
                    col2.metric("Columns", num_cols)
                    col3.metric("Size", f"{info['size_mb']:.2f} MB")
                    
                    # Get column names
                    with h5py.File(file_path, 'r') as hf:
                        label_key = f'{dataset_name}_label' if f'{dataset_name}_label' in hf.attrs else f'{dataset_name}_LABEL'
                        if label_key in hf.attrs:
                            columns = hf.attrs[label_key]
                            if isinstance(columns[0], bytes):
                                columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                            st.write("**Columns:**")
                            # Display columns in a nice grid
                            cols_text = ", ".join(columns)
                            st.text(cols_text)
        
        # ==================== TAB 2: DATA EXPLORER ====================
        with tab2:
            st.header("Data Explorer")
            
            # Dataset selection
            selected_dataset = st.selectbox("Select dataset to explore:", datasets)
            
            # Load data
            with st.spinner(f"Loading {selected_dataset}..."):
                df = get_dataframe(file_path, selected_dataset)
            
            st.success(f"Loaded {len(df):,} rows × {len(df.columns)} columns")
            
            # Check if dataset has data
            if len(df) == 0:
                st.error("Dataset is empty. No data to display.")
            else:
                # Controls
                max_rows_available = min(len(df), 10_000_000)  # Cap at 10M to prevent dashboard slowdown
                col1, col2, col3 = st.columns(3)
                with col1:
                    max_value = max(5, max_rows_available)
                    num_rows = st.number_input("Rows to display", min_value=5, max_value=max_value, value=min(100, max_value), step=max(1, max_value//100))
                with col2:
                    max_start = max(0, len(df) - 1)
                    start_row = st.number_input("Start from row", min_value=0, max_value=max_start, value=0)
                with col3:
                    search_term = st.text_input("Search columns", placeholder="e.g., Temperature")
                
                # Filter columns if search term provided
                if search_term:
                    filtered_cols = [col for col in df.columns if search_term.lower() in col.lower()]
                    if filtered_cols:
                        df_display = df[filtered_cols].iloc[start_row:start_row+num_rows]
                        st.info(f"Found {len(filtered_cols)} columns matching '{search_term}'")
                    else:
                        df_display = df.iloc[start_row:start_row+num_rows]
                        st.warning(f"No columns found matching '{search_term}'")
                else:
                    df_display = df.iloc[start_row:start_row+num_rows]
                
                # Round numeric columns for display (visual only)
                df_display_rounded = df_display.copy()
                numeric_cols = df_display_rounded.select_dtypes(include=['float64', 'float32']).columns
                for col in numeric_cols:
                    df_display_rounded[col] = df_display_rounded[col].round(5)
                
                # Display data
                st.dataframe(df_display_rounded, width='content')
                
                # Download option
                csv = df_display.to_csv(index=False).encode('utf-8')
                st.download_button(
                    label="Download displayed data as CSV",
                    data=csv,
                    file_name=f"{selected_dataset}_{start_row}_{start_row+num_rows}.csv",
                    mime="text/csv",
                )
        
        # ==================== TAB 3: VISUALIZATION ====================
        with tab3:
            st.header("Data Visualization")
            
            # Dataset selection
            viz_dataset = st.selectbox("Select dataset:", datasets, key="viz_dataset")
            
            # Load data
            with st.spinner(f"Loading {viz_dataset}..."):
                df_viz = get_dataframe(file_path, viz_dataset)
            
            # Check if dataset has data
            if len(df_viz) == 0:
                st.error("Dataset is empty. Cannot create visualization.")
            else:
                # Get numeric columns
                numeric_cols = df_viz.select_dtypes(include=['float64', 'int64']).columns.tolist()
                
                if numeric_cols:
                    # Plot type selection
                    plot_type = st.selectbox("Plot type:", ["Line Plot", "Scatter Plot", "Histogram", "Box Plot"], index=1)
                    
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        if plot_type in ["Line Plot", "Scatter Plot"]:
                            x_col = st.selectbox("X-axis:", numeric_cols, index=0)
                        else:
                            x_col = st.selectbox("Column:", numeric_cols, index=0)
                    
                    with col2:
                        if plot_type in ["Line Plot", "Scatter Plot"]:
                            y_col = st.selectbox("Y-axis:", [col for col in numeric_cols if col != x_col])
                        else:
                            y_col = None
                    
                    # Sample data for performance
                    max_sample = min(len(df_viz), 10_000_000)  # Cap at 10M to prevent dashboard slowdown
                    
                    # Handle slider safely - ensure min < max
                    if max_sample < 100:
                        sample_size = max_sample
                        st.warning(f"Dataset has only {len(df_viz)} rows. Displaying all available data.")
                    else:
                        default_sample = min(10000, max_sample)
                        sample_size = st.slider("Sample size (rows):", 100, max_sample, default_sample)
                    
                    df_sample = df_viz.sample(n=min(sample_size, len(df_viz)), random_state=42)  # random_state for reproducibility
                    
                    # Create plot
                    try:
                        if plot_type == "Line Plot":
                            # Sort by index to maintain sequential order (don't sort by x values)
                            df_sample_sorted = df_sample.sort_index()
                            fig = px.line(df_sample_sorted, x=x_col, y=y_col, title=f"{y_col} vs {x_col}")
                            # Make line thinner for large datasets
                            fig.update_traces(line=dict(width=1))
                        elif plot_type == "Scatter Plot":
                            fig = px.scatter(df_sample, x=x_col, y=y_col, title=f"{y_col} vs {x_col}")
                            # Make markers smaller for large datasets
                            fig.update_traces(marker=dict(size=3))
                        elif plot_type == "Histogram":
                            fig = px.histogram(df_sample, x=x_col, title=f"Distribution of {x_col}")
                        elif plot_type == "Box Plot":
                            fig = px.box(df_sample, y=x_col, title=f"Box Plot of {x_col}")
                        
                        fig.update_layout(height=600, width=1200)
                        st.plotly_chart(fig, width='stretch')
                        
                        # Generate filename based on plot type and axes
                        if plot_type in ["Line Plot", "Scatter Plot"]:
                            plot_filename = f"{plot_type.lower().replace(' ', '_')}_{x_col}-vs-{y_col}_{sample_size}rows.png"
                        elif plot_type == "Histogram":
                            plot_filename = f"histogram_{x_col}_{sample_size}rows.png"
                        else:  # Box Plot
                            plot_filename = f"boxplot_{x_col}_{sample_size}rows.png"
                        
                        # Download button - use scale=2 for high resolution (2x DPI)
                        st.download_button(
                            label="Download plot as PNG",
                            data=fig.to_image(format="png", width=1200, height=600, scale=2),
                            file_name=plot_filename,
                            mime="image/png",
                        )
                    except Exception as e:
                        st.error(f"Error creating plot: {str(e)}")
                else:
                    st.warning("No numeric columns found for visualization")
        
        # ==================== TAB 4: STATISTICS ====================
        with tab4:
            st.header("Statistical Summary")
            
            # Dataset selection
            stats_dataset = st.selectbox("Select dataset:", datasets, key="stats_dataset")
            
            # Load data
            with st.spinner(f"Loading {stats_dataset}..."):
                df_stats = get_dataframe(file_path, stats_dataset)
            
            # Check if dataset has data
            if len(df_stats) == 0:
                st.error("Dataset is empty. No statistics to display.")
            else:
                # Display statistics
                st.subheader("Descriptive Statistics")
                
                # Get numeric columns
                numeric_df = df_stats.select_dtypes(include=['float64', 'int64'])
                
                if not numeric_df.empty:
                    # Statistics summary
                    stats_summary = numeric_df.describe().T
                    stats_summary['missing'] = df_stats.isnull().sum()
                    stats_summary['unique'] = numeric_df.nunique()
                    
                    # Round all numeric values to 5 decimal places to avoid display issues
                    stats_summary = stats_summary.round(5)
                    
                    st.dataframe(stats_summary, width='stretch')
                    
                    # Column-specific stats
                    st.subheader("Column Details")
                    selected_col = st.selectbox("Select column for detailed view:", numeric_df.columns.tolist())
                    
                    col1, col2, col3, col4 = st.columns(4)
                    with col1:
                        st.metric("Mean", f"{numeric_df[selected_col].mean():.4f}")
                    with col2:
                        st.metric("Median", f"{numeric_df[selected_col].median():.4f}")
                    with col3:
                        st.metric("Std Dev", f"{numeric_df[selected_col].std():.4f}")
                    with col4:
                        st.metric("Range", f"{numeric_df[selected_col].max() - numeric_df[selected_col].min():.4f}")
                    
                    # Distribution plot
                    fig = px.histogram(numeric_df, x=selected_col, marginal="box", 
                                     title=f"Distribution of {selected_col}")
                    fig.update_layout(height=400)
                    st.plotly_chart(fig, width='stretch')
                else:
                    st.warning("No numeric columns found for statistics")
    
    except Exception as e:
        st.error(f"Error loading file: {str(e)}")
        st.exception(e)

else:
    st.warning(f"No HDF5 files found in '{results_dir}' directory")
    st.info("Run your data extraction script first to generate HDF5 files")

# Footer
st.sidebar.markdown("---")
st.sidebar.markdown("### About")
st.sidebar.info("""
This dashboard allows you to:
- Browse HDF5 flight data files
- Explore datasets interactively
- Visualize data with charts
- View statistical summaries
- Export data to CSV
""")