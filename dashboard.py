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
import os
import sys
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
import io
from data_utils import list_datasets, get_dataset_info, get_dataframe
import h5py
import streamlit.components.v1 as components

st.set_page_config(
    page_title="UAV Data Browser",
    page_icon="https://images.icon-icons.com/1738/PNG/512/iconfinder-technologymachineelectronicdevice06-4026454_113332.png",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom styling for tabs
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

st.title("UAV Data Browser")
st.markdown("Interactive dashboard for exploring HDF5 flight data files")

st.sidebar.header("File Selection")

# Get data directory
if len(sys.argv) > 1:
    results_dir = sys.argv[1]
else:
    results_dir = "Processed Data"

st.sidebar.info(f"Data Directory: {results_dir}")
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
    
    file_size = os.path.getsize(file_path) / (1024**2)
    st.sidebar.metric("File Size", f"{file_size:.1f} MB")
    try:
        datasets = list_datasets(file_path)
        dataset_info = get_dataset_info(file_path)
        
        st.sidebar.success(f"{len(datasets)} datasets found")
        
        tab1, tab2, tab3, tab4 = st.tabs(["Overview", "Data Explorer", "Visualization", "Statistics"])
        
        # Overview tab
        with tab1:
            st.header("Dataset Overview")
            
            overview_data = []
            for name, info in dataset_info.items():
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
            
            col1, col2, col3 = st.columns(3)
            with col1:
                total_rows = sum([info['shape'][0] for info in dataset_info.values()])
                st.metric("Total Rows", f"{total_rows:,}")
            with col2:
                total_size = sum([info['size_mb'] for info in dataset_info.values()])
                st.metric("Total Size", f"{total_size:.1f} MB")
            with col3:
                st.metric("Datasets", len(datasets))
            
            st.subheader("Dataset Details")
            for dataset_name in datasets:
                with st.expander(f"{dataset_name}"):
                    info = dataset_info[dataset_name]
                    col1, col2, col3 = st.columns(3)
                    col1.metric("Rows", f"{info['shape'][0]:,}")
                    num_cols = info['shape'][1] if len(info['shape']) > 1 else 1
                    col2.metric("Columns", num_cols)
                    col3.metric("Size", f"{info['size_mb']:.2f} MB")
                    
                    with h5py.File(file_path, 'r') as hf:
                        label_key = f'{dataset_name}_label' if f'{dataset_name}_label' in hf.attrs else f'{dataset_name}_LABEL'
                        if label_key in hf.attrs:
                            columns = hf.attrs[label_key]
                            if isinstance(columns[0], bytes):
                                columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                            st.write("**Columns:**")
                            st.text(", ".join(columns))
        
        # Data explorer tab
        with tab2:
            st.header("Data Explorer")
            
            selected_dataset = st.selectbox("Select dataset to explore:", datasets)
            with st.spinner(f"Loading {selected_dataset}..."):
                df = get_dataframe(file_path, selected_dataset)
            
            st.success(f"Loaded {len(df):,} rows × {len(df.columns)} columns")
            
            if len(df) == 0:
                st.error("Dataset is empty. No data to display.")
            else:
                max_rows_available = min(len(df), 10_000_000)
                col1, col2, col3 = st.columns(3)
                with col1:
                    max_value = max(5, max_rows_available)
                    num_rows = st.number_input("Rows to display", min_value=5, max_value=max_value, value=min(100, max_value), step=max(1, max_value//100))
                with col2:
                    max_start = max(0, len(df) - 1)
                    start_row = st.number_input("Start from row", min_value=0, max_value=max_start, value=0)
                with col3:
                    search_term = st.text_input("Search columns", placeholder="e.g., Temperature")
                
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
                
                df_display_rounded = df_display.copy()
                numeric_cols = df_display_rounded.select_dtypes(include=['float64', 'float32']).columns
                for col in numeric_cols:
                    df_display_rounded[col] = df_display_rounded[col].round(5)
                
                st.dataframe(df_display_rounded, width='content')
                csv = df_display.to_csv(index=False).encode('utf-8')
                st.download_button(
                    label="Download displayed data as CSV",
                    data=csv,
                    file_name=f"{selected_dataset}_{start_row}_{start_row+num_rows}.csv",
                    mime="text/csv"
                )
        
        # Visualization tab
        with tab3:
            st.header("Data Visualization")
            
            viz_tab1, viz_tab2 = st.tabs(["2D Plots", "3D Interactive Plot"])
            
            # 2D plots
            with viz_tab1:
                viz_dataset = st.selectbox("Select dataset:", datasets, key="viz_dataset")
                
                # Clear plot cache when dataset changes
                if 'last_viz_dataset' not in st.session_state:
                    st.session_state['last_viz_dataset'] = viz_dataset
                elif st.session_state['last_viz_dataset'] != viz_dataset:
                    # Dataset changed - clear all plot caches
                    keys_to_remove = [key for key in st.session_state.keys() if key.startswith('png_') or key.startswith('svg_')]
                    for key in keys_to_remove:
                        del st.session_state[key]
                    st.session_state['last_viz_dataset'] = viz_dataset
                
                with st.spinner(f"Loading {viz_dataset}..."):
                    df_viz = get_dataframe(file_path, viz_dataset)
                
                if len(df_viz) == 0:
                    st.error("Dataset is empty. Cannot create visualization.")
                else:
                    numeric_cols = df_viz.select_dtypes(include=['float64', 'int64']).columns.tolist()
                    
                    if numeric_cols:
                        plot_type = st.selectbox("Plot type:", ["Line Plot", "Scatter Plot", "Histogram", "Box Plot"], index=0)
                        
                        col1, col2 = st.columns(2)
                        
                        with col1:
                            if plot_type in ["Line Plot", "Scatter Plot"]:
                                x_col = st.selectbox("X-axis:", numeric_cols, index=0)
                            else:
                                x_col = st.selectbox("Column:", numeric_cols, index=0)
                        
                        with col2:
                            if plot_type in ["Line Plot", "Scatter Plot"]:
                                y_col = st.selectbox("Y-axis:", [col for col in numeric_cols if col != x_col], index=0)
                            else:
                                y_col = None
                        
                        max_sample = min(len(df_viz), 10_000_000)
                        if max_sample < 100:
                            sample_size = max_sample
                            st.warning(f"Dataset has only {len(df_viz)} rows. Displaying all available data.")
                        else:
                            default_sample = min(10000, max_sample)
                            sample_size = st.slider("Sample size (rows):", 100, max_sample, default_sample)
                        
                        plot_color = st.color_picker("Plot color:", "#636EFA", key="plot_color_picker")
                        
                        df_sample = df_viz.sample(n=min(sample_size, len(df_viz)), random_state=42)
                        
                        try:
                            
                            if plot_type == "Line Plot":
                                df_sorted = df_sample.sort_index()
                                fig = px.line(df_sorted, x=x_col, y=y_col, title=f"{y_col} vs {x_col}")
                                fig.update_traces(line=dict(width=1, color=plot_color))
                            elif plot_type == "Scatter Plot":
                                fig = px.scatter(df_sample, x=x_col, y=y_col, title=f"{y_col} vs {x_col}")
                                fig.update_traces(marker=dict(size=3, color=plot_color))
                            elif plot_type == "Histogram":
                                fig = px.histogram(df_sample, x=x_col, title=f"Distribution of {x_col}")
                                fig.update_traces(marker=dict(color=plot_color))
                            elif plot_type == "Box Plot":
                                fig = px.box(df_sample, y=x_col, title=f"Box Plot of {x_col}")
                                fig.update_traces(marker=dict(color=plot_color))
                            
                            fig.update_layout(height=600, width=1200, template="plotly")
                            st.plotly_chart(fig, width='stretch')
                            if plot_type in ["Line Plot", "Scatter Plot"]:
                                plot_filename = f"{plot_type.lower().replace(' ', '_')}_{x_col}-vs-{y_col}_{sample_size}rows.png"
                            elif plot_type == "Histogram":
                                plot_filename = f"histogram_{x_col}_{sample_size}rows.png"
                            else:
                                plot_filename = f"boxplot_{x_col}_{sample_size}rows.png"
                            use_full = st.checkbox(f"Use full dataset for download (not just {sample_size} rows)", key="full_download_checkbox")
                            if use_full:
                                plot_filename = plot_filename.replace(f"{sample_size}rows", "full_dataset")
                            def create_matplotlib_figure(data, plot_type, x_col, y_col=None, color='#636EFA', dpi=150):
                                fig_mpl, ax = plt.subplots(figsize=(12, 6), dpi=dpi)
                                
                                if plot_type == "Line Plot":
                                    data_sorted = data.sort_index()
                                    ax.plot(data_sorted[x_col], data_sorted[y_col], color=color, linewidth=0.5)
                                    ax.set_xlabel(x_col, fontsize=12)
                                    ax.set_ylabel(y_col, fontsize=12)
                                    ax.set_title(f"{y_col} vs {x_col}", fontsize=14, fontweight='bold')
                                elif plot_type == "Scatter Plot":
                                    ax.scatter(data[x_col], data[y_col], color=color, s=10, alpha=0.6)
                                    ax.set_xlabel(x_col, fontsize=12)
                                    ax.set_ylabel(y_col, fontsize=12)
                                    ax.set_title(f"{y_col} vs {x_col}", fontsize=14, fontweight='bold')
                                elif plot_type == "Histogram":
                                    ax.hist(data[x_col].dropna(), bins=30, color=color, alpha=0.7, edgecolor='white')
                                    ax.set_xlabel(x_col, fontsize=12)
                                    ax.set_ylabel('Count', fontsize=12)
                                    ax.set_title(f"Distribution of {x_col}", fontsize=14, fontweight='bold')
                                elif plot_type == "Box Plot":
                                    bp = ax.boxplot(data[x_col].dropna(), patch_artist=True)
                                    for patch in bp['boxes']:
                                        patch.set_facecolor(color)
                                        patch.set_alpha(0.7)
                                    ax.set_ylabel(x_col, fontsize=12)
                                    ax.set_title(f"Box Plot of {x_col}", fontsize=14, fontweight='bold')
                                
                                ax.grid(True, alpha=0.3, linestyle='--', linewidth=0.5)
                                ax.spines['top'].set_visible(False)
                                ax.spines['right'].set_visible(False)
                                plt.tight_layout()
                                return fig_mpl
                            
                            cache_key = f"{viz_dataset}_{plot_type}_{x_col}_{y_col}_{sample_size}_{use_full}_{plot_color}"
                            if f"png_{cache_key}" not in st.session_state:
                                data_for_export = df_viz if use_full else df_sample
                                fig_mpl = create_matplotlib_figure(data_for_export, plot_type, x_col, y_col, color=plot_color, dpi=150)
                                
                                # Save as PNG
                                buf_png = io.BytesIO()
                                fig_mpl.savefig(buf_png, format='png', dpi=150, bbox_inches='tight', facecolor='white')
                                buf_png.seek(0)
                                st.session_state[f"png_{cache_key}"] = buf_png.getvalue()
                                
                                # Save as SVG
                                buf_svg = io.BytesIO()
                                fig_mpl.savefig(buf_svg, format='svg', bbox_inches='tight', facecolor='white')
                                buf_svg.seek(0)
                                st.session_state[f"svg_{cache_key}"] = buf_svg.getvalue()
                                plt.close(fig_mpl)
                            col_dl1, col_dl2, col_dl3 = st.columns([2, 2, 1])
                            with col_dl1:
                                st.download_button(
                                    label="Download plot as PNG",
                                    data=st.session_state[f"png_{cache_key}"],
                                    file_name=plot_filename,
                                    mime="image/png",
                                    key="download_png"
                                )
                            with col_dl2:
                                st.download_button(
                                    label="Download plot as SVG",
                                    data=st.session_state[f"svg_{cache_key}"],
                                    file_name=plot_filename.replace(".png", ".svg"),
                                    mime="image/svg+xml",
                                    key="download_svg"
                                )
                            with col_dl3:
                                if st.button("Refresh", key="refresh_plot", help="Clear cache and regenerate plot"):
                                    if f"png_{cache_key}" in st.session_state:
                                        del st.session_state[f"png_{cache_key}"]
                                    if f"svg_{cache_key}" in st.session_state:
                                        del st.session_state[f"svg_{cache_key}"]
                                    st.rerun()
                        except Exception as e:
                            st.error(f"Error creating plot: {str(e)}")
                    else:
                        st.warning("No numeric columns found for visualization")
            
            # 3D interactive plot
            with viz_tab2:
                st.subheader("Interactive 3D Trajectory Plot")
                st.markdown("Create an interactive 3D visualization by selecting parameters from any dataset(s).")
                sample_rate_3d = st.slider("Sample rate (1=all data)", 1, 100, 10, 
                                           help="Higher values = faster rendering. 10 means use every 10th point.", 
                                           key="sample_rate_3d")
                
                st.markdown("---")
                st.markdown("**Select parameters from any dataset:**")
                
                # X-axis selection
                col1, col2 = st.columns([1, 2])
                with col1:
                    x_dataset = st.selectbox("X-axis dataset:", datasets, index=0, key="x_dataset")
                with col2:
                    df_x = get_dataframe(file_path, x_dataset)
                    numeric_cols_x = df_x.select_dtypes(include=['float64', 'int64']).columns.tolist()
                    x_axis_3d = st.selectbox("X-axis parameter:", numeric_cols_x, index=0, key="x_param")
                
                # Y-axis selection
                col1, col2 = st.columns([1, 2])
                with col1:
                    y_dataset = st.selectbox("Y-axis dataset:", datasets, index=0, key="y_dataset")
                with col2:
                    df_y = get_dataframe(file_path, y_dataset)
                    numeric_cols_y = df_y.select_dtypes(include=['float64', 'int64']).columns.tolist()
                    y_axis_3d = st.selectbox("Y-axis parameter:", numeric_cols_y, 
                                            index=min(1, len(numeric_cols_y)-1) if y_dataset == x_dataset else 0, 
                                            key="y_param")
                
                # Z-axis selection
                col1, col2 = st.columns([1, 2])
                with col1:
                    z_dataset = st.selectbox("Z-axis dataset:", datasets, index=0, key="z_dataset")
                with col2:
                    df_z = get_dataframe(file_path, z_dataset)
                    numeric_cols_z = df_z.select_dtypes(include=['float64', 'int64']).columns.tolist()
                    z_axis_3d = st.selectbox("Z-axis parameter:", numeric_cols_z, 
                                            index=min(2, len(numeric_cols_z)-1) if z_dataset == x_dataset else 0, 
                                            key="z_param")
                
                st.markdown("---")
                col1, col2 = st.columns(2)
                with col1:
                    use_color_gradient = st.checkbox("Add color gradient", value=True, key="use_color")
                    if use_color_gradient:
                        color_dataset = st.selectbox("Color dataset:", datasets, index=0, key="color_dataset")
                        df_color = get_dataframe(file_path, color_dataset)
                        numeric_cols_color = df_color.select_dtypes(include=['float64', 'int64']).columns.tolist()
                        color_var_3d = st.selectbox("Color by:", numeric_cols_color, 
                                                   index=min(2, len(numeric_cols_color)-1) if color_dataset == x_dataset else 0, 
                                                   key="color_param")
                    else:
                        color_var_3d = None
                        color_dataset = None
                with col2:
                    line_width_3d = st.slider("Line width:", 1, 10, 4, key="line_width_3d")
                
                st.markdown("---")
                st.markdown("**Animation (optional):**")
                col1, col2 = st.columns(2)
                with col1:
                    add_slider = st.checkbox("Enable time slider", value=False, 
                                            help="Add a slider to explore the trajectory over time. Increases file size.")
                with col2:
                    if add_slider:
                        num_frames_slider = st.slider("Number of frames:", 10, 50, 25, 
                                                     help="More frames = smoother but larger file")
                    else:
                        num_frames_slider = 25
                
                st.markdown("---")
                if st.button("Generate 3D Plot", type="primary", key="gen_3d"):
                    with st.spinner("Creating 3D visualization..."):
                        try:
                            df_x_sampled = df_x[::sample_rate_3d].reset_index(drop=True)
                            df_y_sampled = df_y[::sample_rate_3d].reset_index(drop=True)
                            df_z_sampled = df_z[::sample_rate_3d].reset_index(drop=True)
                            min_length = min(len(df_x_sampled), len(df_y_sampled), len(df_z_sampled))
                            if use_color_gradient:
                                df_color_sampled = df_color[::sample_rate_3d].reset_index(drop=True)
                                min_length = min(min_length, len(df_color_sampled))
                            df_x_sampled = df_x_sampled[:min_length]
                            df_y_sampled = df_y_sampled[:min_length]
                            df_z_sampled = df_z_sampled[:min_length]
                            if use_color_gradient:
                                df_color_sampled = df_color_sampled[:min_length]
                            
                            st.info(f"Using {min_length:,} points (sampled from original data)")
                            if add_slider:
                                st.info(f"Generating {num_frames_slider} frames...")
                                frame_step = max(1, min_length // num_frames_slider)
                                frame_indices = list(range(frame_step, min_length, frame_step)) + [min_length]
                                initial_end_idx = min_length
                                
                                frames = []
                                for i, end_idx in enumerate(frame_indices):
                                    frames.append(go.Frame(
                                        data=[go.Scatter3d(
                                            x=df_x_sampled[x_axis_3d][:end_idx],
                                            y=df_y_sampled[y_axis_3d][:end_idx],
                                            z=df_z_sampled[z_axis_3d][:end_idx],
                                            mode='lines',
                                            line=dict(
                                                color=df_color_sampled[color_var_3d][:end_idx] if use_color_gradient else '#636EFA',
                                                colorscale='Viridis' if use_color_gradient else None,
                                                width=line_width_3d,
                                                colorbar=dict(title=color_var_3d, thickness=20) if use_color_gradient else None
                                            ),
                                            hovertemplate=f'<b>{x_axis_3d}:</b> %{{x:.4f}}<br><b>{y_axis_3d}:</b> %{{y:.4f}}<br><b>{z_axis_3d}:</b> %{{z:.4f}}<extra></extra>'
                                        )],
                                        name=str(i),
                                        layout={}
                                    ))
                            else:
                                initial_end_idx = min_length
                            fig_3d = go.Figure(data=[go.Scatter3d(
                                x=df_x_sampled[x_axis_3d][:initial_end_idx],
                                y=df_y_sampled[y_axis_3d][:initial_end_idx],
                                z=df_z_sampled[z_axis_3d][:initial_end_idx],
                                mode='lines',
                                line=dict(
                                    color=df_color_sampled[color_var_3d][:initial_end_idx] if use_color_gradient else '#636EFA',
                                    colorscale='Viridis' if use_color_gradient else None,
                                    width=line_width_3d,
                                    colorbar=dict(title=color_var_3d, thickness=20) if use_color_gradient else None
                                ),
                                hovertemplate=f'<b>{x_axis_3d}:</b> %{{x:.4f}}<br><b>{y_axis_3d}:</b> %{{y:.4f}}<br><b>{z_axis_3d}:</b> %{{z:.4f}}<extra></extra>'
                            )])
                            if add_slider:
                                fig_3d.frames = frames
                                fig_3d.update_layout(
                                    updatemenus=[{
                                        'type': 'buttons',
                                        'showactive': False,
                                        'buttons': [
                                            {'label': '▶ Play', 'method': 'animate', 
                                             'args': [None, {'frame': {'duration': 100, 'redraw': True}, 
                                                            'transition': {'duration': 0}, 
                                                            'fromcurrent': True, 
                                                            'mode': 'immediate'}]},
                                            {'label': '⏸ Pause', 'method': 'animate',
                                             'args': [[None], {'frame': {'duration': 0, 'redraw': False}, 
                                                              'mode': 'immediate', 
                                                              'transition': {'duration': 0}}]}
                                        ],
                                        'x': 0.1, 'y': 0
                                    }],
                                    sliders=[{
                                        'active': len(frames) - 1,
                                        'steps': [
                                            {'args': [[f.name], {'frame': {'duration': 0, 'redraw': True}, 
                                                                'mode': 'immediate', 
                                                                'transition': {'duration': 0}}],
                                             'label': f'{int(100*i/(len(frames)-1))}%',
                                             'method': 'animate'}
                                            for i, f in enumerate(frames)
                                        ],
                                        'x': 0.1, 'len': 0.85, 'y': 0,
                                        'currentvalue': {'prefix': 'Progress: ', 'visible': True, 'xanchor': 'center'}
                                    }]
                                )
                            fig_3d.update_layout(
                                title=f'Interactive 3D Plot: {z_axis_3d} vs {x_axis_3d} vs {y_axis_3d}',
                                scene=dict(
                                    xaxis_title=x_axis_3d,
                                    yaxis_title=y_axis_3d,
                                    zaxis_title=z_axis_3d,
                                    camera=dict(eye=dict(x=1.5, y=1.5, z=1.3))
                                ),
                                width=1200,
                                height=800,
                                showlegend=False
                            )
                            st.session_state['fig_3d'] = fig_3d
                            st.session_state['fig_3d_metadata'] = {
                                'x_dataset': x_dataset,
                                'y_dataset': y_dataset,
                                'z_dataset': z_dataset,
                                'add_slider': add_slider,
                                'num_frames': len(frames) if add_slider else 0
                            }
                            
                        except Exception as e:
                            st.error(f"Error creating 3D plot: {str(e)}")
                            st.exception(e)
                if 'fig_3d' in st.session_state:
                    html_string = st.session_state['fig_3d'].to_html(include_plotlyjs='cdn')
                    components.html(html_string, height=850, scrolling=False)
                    st.markdown("---")
                    st.subheader("Export")
                    
                    if st.button("Download as HTML", key="export_3d", type="secondary"):
                        metadata = st.session_state.get('fig_3d_metadata', {})
                        html_filename = f"3d_plot_{metadata.get('x_dataset', 'x')}_{metadata.get('y_dataset', 'y')}_{metadata.get('z_dataset', 'z')}.html"
                        html_content = st.session_state['fig_3d'].to_html(include_plotlyjs='cdn')
                        file_size_mb = len(html_content.encode('utf-8')) / (1024**2)
                        
                        st.download_button(
                            label=f"Download HTML ({file_size_mb:.1f} MB)",
                            data=html_content,
                            file_name=html_filename,
                            mime="text/html",
                            help="Download as standalone interactive HTML file that opens in any browser",
                            key="download_3d_html"
                        )
                        
                        if metadata.get('add_slider', False):
                            st.info(f"✓ File includes {metadata.get('num_frames', 0)} animation frames")
        
        # Statistics tab
        with tab4:
            st.header("Statistical Summary")
            
            stats_dataset = st.selectbox("Select dataset:", datasets, key="stats_dataset")
            with st.spinner(f"Loading {stats_dataset}..."):
                df_stats = get_dataframe(file_path, stats_dataset)
            
            if len(df_stats) == 0:
                st.error("Dataset is empty. No statistics to display.")
            else:
                st.subheader("Descriptive Statistics")
                numeric_df = df_stats.select_dtypes(include=['float64', 'int64'])
                
                if not numeric_df.empty:
                    stats_summary = numeric_df.describe().T
                    stats_summary['missing'] = df_stats.isnull().sum()
                    stats_summary['unique'] = numeric_df.nunique()
                    stats_summary = stats_summary.round(5)
                    
                    st.dataframe(stats_summary, width='stretch')
                    
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
Browse and visualize HDF5 flight data:
- Interactive 2D and 3D plots
- Statistical analysis
- Data export (CSV, PNG, SVG, HTML)
""")