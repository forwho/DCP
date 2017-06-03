function varargout = toolbox(varargin)
% TOOLBOX MATLAB code for toolbox.fig
%      TOOLBOX, by itself, creates a new TOOLBOX or raises the existing
%      singleton*.
%
%      H = TOOLBOX returns the handle to a new TOOLBOX or the handle to
%      the existing singleton*.
%
%      TOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOOLBOX.M with the given input arguments.
%
%      TOOLBOX('Property','Value',...) creates a new TOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before toolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to toolbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help toolbox

% Last Modified by GUIDE v2.5 01-Dec-2014 16:10:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @toolbox_OpeningFcn, ...
                   'gui_OutputFcn',  @toolbox_OutputFcn, ...
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


% --- Executes just before toolbox is made visible.
function toolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to toolbox (see VARARGIN)

% Choose default command line output for toolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes toolbox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = toolbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function start1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start1_edit as text
%        str2double(get(hObject,'String')) returns contents of start1_edit as a double


% --- Executes during object creation, after setting all properties.
function start1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_START_FLODER;
globel_fname= uigetdir;
if(globel_fname==0)
    set(handles.start1_edit,'String','请选择目录');    
else
set(handles.start1_edit,'String',globel_fname);
INIT_START_FLODER=globel_fname   %设定为其实文件夹名
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_NUM;
INIT_NUM=0;
INIT_NUM= str2double(get(hObject,'String'))

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start2_edit as text
%        str2double(get(hObject,'String')) returns contents of start2_edit as a double


% --- Executes during object creation, after setting all properties.
function start2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start2_edit (see GCBO)
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
global INIT_START_FLODER;
globel_fname= uigetdir;
if(globel_fname==0)
    set(handles.start2_edit,'String','请选择目录')    
else
set(handles.start2_edit,'String',globel_fname)
INIT_START_FLODER=globel_fname;
end


function last_edit_Callback(hObject, eventdata, handles)
% hObject    handle to last_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of last_edit as text
%        str2double(get(hObject,'String')) returns contents of last_edit as a double


% --- Executes during object creation, after setting all properties.
function last_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to last_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_END_FLODER;
globel_fname= uigetdir;
if(globel_fname==0)
    set(handles.last_edit,'String','请选择目录')    
else
set(handles.last_edit,'String',globel_fname)
INIT_END_FLODER=globel_fname;
end


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
