function varargout = Dump(varargin)
% DUMP MATLAB code for Dump.fig
%      DUMP, by itself, creates a new DUMP or raises the existing
%      singleton*.
%
%      H = DUMP returns the handle to a new DUMP or the handle to
%      the existing singleton*.
%
%      DUMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DUMP.M with the given input arguments.
%
%      DUMP('Property','Value',...) creates a new DUMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dump_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dump_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dump

% Last Modified by GUIDE v2.5 28-Mar-2014 15:15:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dump_OpeningFcn, ...
                   'gui_OutputFcn',  @Dump_OutputFcn, ...
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


% --- Executes just before Dump is made visible.
function Dump_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dump (see VARARGIN)

% Choose default command line output for Dump
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Dump wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dump_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('C:\Users\medp_admin\Documents\DURAND\EG2R\MATLAB\Dump');
[a, b] = dos('dd --list');
set(handles.output_text1, 'String', b);


function partition_Callback(hObject, eventdata, handles)
% hObject    handle to partition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of partition as text
%        str2double(get(hObject,'String')) returns contents of partition as a double


% --- Executes during object creation, after setting all properties.
function partition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_file_Callback(hObject, eventdata, handles)
% hObject    handle to output_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_file as text
%        str2double(get(hObject,'String')) returns contents of output_file as a double


% --- Executes during object creation, after setting all properties.
function output_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_file (see GCBO)
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
inputfile = get(handles.partition, 'String');
outputfile = get(handles.output_file, 'String');
set(handles.outputscreen, 'String', '');
bs = get(handles.bs, 'String');
count = get(handles.count, 'String');
addpath('C:\Users\medp_admin\Documents\DURAND\EG2R\MATLAB\Dump');
command = strcat('dd if=', inputfile, ' of=', outputfile, ' bs=', bs, ' count=', count);

[a, outputresult] = dos(command);
set(handles.outputscreen, 'String', outputresult);



function outputscreen_Callback(hObject, eventdata, handles)
% hObject    handle to outputscreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputscreen as text
%        str2double(get(hObject,'String')) returns contents of outputscreen as a double


% --- Executes during object creation, after setting all properties.
function outputscreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputscreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_text1_Callback(hObject, eventdata, handles)
% hObject    handle to output_text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_text1 as text
%        str2double(get(hObject,'String')) returns contents of output_text1 as a double


% --- Executes during object creation, after setting all properties.
function output_text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bs_Callback(hObject, eventdata, handles)
% hObject    handle to bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bs as text
%        str2double(get(hObject,'String')) returns contents of bs as a double


% --- Executes during object creation, after setting all properties.
function bs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of count as text
%        str2double(get(hObject,'String')) returns contents of count as a double


% --- Executes during object creation, after setting all properties.
function count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
