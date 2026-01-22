function varargout = data_process(varargin)
% DATA_PROCESS MATLAB code for data_process.fig
%      DATA_PROCESS, by itself, creates a new DATA_PROCESS or raises the existing
%      singleton*.
%
%      H = DATA_PROCESS returns the handle to a new DATA_PROCESS or the handle to
%      the existing singleton*.
%
%      DATA_PROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PROCESS.M with the given input arguments.
%
%      DATA_PROCESS('Property','Value',...) creates a new DATA_PROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_process_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_process_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_process

% Last Modified by GUIDE v2.5 04-May-2021 13:01:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_process_OpeningFcn, ...
                   'gui_OutputFcn',  @data_process_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before data_process is made visible.
function data_process_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_process (see VARARGIN)

% Choose default command line output for data_process
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_process wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_process_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, directory] = uigetfile('*');
if filename
    set(handles.filename, 'String', strcat(directory, filename));
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function variable_name_Callback(hObject, eventdata, handles)
% hObject    handle to variable_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of variable_name as text
%        str2double(get(hObject,'String')) returns contents of variable_name as a double


% --- Executes during object creation, after setting all properties.
function variable_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variable_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_file.
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_file
visible = get(hObject, 'Value');
if visible
    visible = 'on';
else
    visible = 'off';
end
set(handles.filename_text, 'Visible', visible);
set(handles.save_filename, 'Visible', visible);






% --- Executes during object creation, after setting all properties.
function save_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in whatload1.
% function whatload1_Callback(hObject, eventdata, handles)
% % hObject    handle to whatload1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of whatload1


% --- Executes on button press in whatload2.
function whatload2_Callback(hObject, eventdata, handles)
% hObject    handle to whatload2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of whatload2


% --- Executes on button press in whatload4.
function whatload4_Callback(hObject, eventdata, handles)
% hObject    handle to whatload4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of whatload4
visible = get(hObject, 'Value');
if visible
    visible = 'on';
else
    visible = 'off';
end

set(handles.pressures, 'Visible', visible);


% --- Executes on button press in whatload8.
function whatload8_Callback(hObject, eventdata, handles)
% hObject    handle to whatload8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of whatload8
visible = get(hObject, 'Value');
if visible
    visible = 'on';
else
    visible = 'off';
end

set(handles.euler_angles, 'Visible', visible);



% --- Executes on button press in calculate_euler_angles.
function calculate_euler_angles_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_euler_angles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calculate_euler_angles
visible = get(hObject, 'Value');
if visible
    visible = 'on';
else
    visible = 'off';
end

set(handles.beta_text, 'Visible', visible);
set(handles.euler_beta, 'Visible', visible);




function euler_beta_Callback(hObject, eventdata, handles)
% hObject    handle to euler_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of euler_beta as text
%        str2double(get(hObject,'String')) returns contents of euler_beta as a double


% --- Executes during object creation, after setting all properties.
function euler_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to euler_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pressure1_Callback(hObject, eventdata, handles)
% hObject    handle to pressure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure1 as text
%        str2double(get(hObject,'String')) returns contents of pressure1 as a double


% --- Executes during object creation, after setting all properties.
function pressure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pressure2_Callback(hObject, eventdata, handles)
% hObject    handle to pressure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure2 as text
%        str2double(get(hObject,'String')) returns contents of pressure2 as a double


% --- Executes during object creation, after setting all properties.
function pressure2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pressure3_Callback(hObject, eventdata, handles)
% hObject    handle to pressure3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure3 as text
%        str2double(get(hObject,'String')) returns contents of pressure3 as a double


% --- Executes during object creation, after setting all properties.
function pressure3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pressure4_Callback(hObject, eventdata, handles)
% hObject    handle to pressure4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure4 as text
%        str2double(get(hObject,'String')) returns contents of pressure4 as a double


% --- Executes during object creation, after setting all properties.
function pressure4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pressure5_Callback(hObject, eventdata, handles)
% hObject    handle to pressure5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure5 as text
%        str2double(get(hObject,'String')) returns contents of pressure5 as a double


% --- Executes during object creation, after setting all properties.
function pressure5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pressure6_Callback(hObject, eventdata, handles)
% hObject    handle to pressure6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pressure6 as text
%        str2double(get(hObject,'String')) returns contents of pressure6 as a double


% --- Executes during object creation, after setting all properties.
function pressure6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pressure6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pressure1, 'String', '13653');
set(handles.pressure2, 'String', '13653');
set(handles.pressure3, 'String', '13653');
set(handles.pressure4, 'String', '13653');
set(handles.pressure5, 'String', '13653');
set(handles.pressure6, 'String', '13653');



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiwait(msgbox('The calibration data must be inside a MATLAB file, in the 1x3 double variable zero_offset', 'File format', 'modal'));

[filename, directory] = uigetfile('*');
if filename
    data = load(strcat(directory, filename));
    zero_offset = data.zero_offset;
    p1 = num2str(zero_offset(1,1));
    p2 = num2str(zero_offset(1,2));
    p3 = num2str(zero_offset(1,3));
    p4 = num2str(zero_offset(1,4));
    p5 = num2str(zero_offset(1,5));
    p6 = num2str(zero_offset(1,6));   
    
    
    set(handles.pressure1, 'String', p1);
    set(handles.pressure2, 'String', p2);
    set(handles.pressure3, 'String', p3);
    set(handles.pressure1, 'String', p4);
    set(handles.pressure2, 'String', p5);
    set(handles.pressure3, 'String', p6);   
       
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.filename, 'String');
p1 = get(handles.pressure1, 'String');
p2 = get(handles.pressure2, 'String');
p3 = get(handles.pressure3, 'String');
p4 = get(handles.pressure4, 'String');
p5 = get(handles.pressure5, 'String');
p6 = get(handles.pressure6, 'String');

p1 = str2num(p1);
p2 = str2num(p2);
p3 = str2num(p3);
p4 = str2num(p4);
p5 = str2num(p5);
p6 = str2num(p6);



zero_calibration_data = [p1 p2 p3 p4 p5 p6];

whatload = 0;
% if get(handles.whatload1, 'Value')
%     whatload = whatload + 1;
% end
% if get(handles.whatload2, 'Value')
%     whatload = whatload + 2;
% end
% if get(handles.whatload4, 'Value')
%     whatload = whatload + 4;
% end
% if get(handles.whatload8, 'Value')
%     whatload = whatload + 8;
% end

set(handles.status_text, 'String', 'Loading file...');
% data = loaddata(filename, zero_calibration_data, whatload); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = loaddata(filename);
set(handles.status_text, 'String', 'File loaded');

varname = get(handles.variable_name, 'String');


if get(handles.calculate_euler_angles, 'Value') & get(handles.whatload8, 'Value')
    beta = get(handles.euler_beta, 'String');
    beta = str2num(beta);
    if isequal(beta, [])
        beta = 0.1;
        set(handles.euler_beta, 'String', '0.1');
    end
    data.angles_label = {'Time', 'Roll', 'Pitch', 'Yaw'};
    set(handles.status_text, 'String', 'Calculating euler angles');
    data.angles = angle_calculation(data.IMU, beta);
    set(handles.status_text, 'String', 'Euler angles calculated');
end

assignin('base', varname, data);
    

if get(handles.save_file, 'Value')
    eval(strcat(varname, ' = data;'));
    save_file = get(handles.save_filename, 'String');
    set(handles.status_text, 'String', 'Saving MATLAB file');
    save(save_file, varname);
    set(handles.status_text, 'String', 'MATLAB file saved');
end
