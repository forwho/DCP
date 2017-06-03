function varargout = DCP(varargin)
% DCP MATLAB code for DCP.fig
%      DCP, by itself, creates a new DCP or raises the existing
%      singleton*.
%
%      H = DCP returns the handle to a new DCP or the handle to
%      the existing singleton*.
%
%      DCP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCP.M with the given input arguments.
%
%      DCP('Property','Value',...) creates a new DCP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DCP

% Last Modified by GUIDE v2.5 26-Nov-2016 23:21:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DCP_OpeningFcn, ...
                   'gui_OutputFcn',  @DCP_OutputFcn, ...
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


% --- Executes just before DCP is made visible.
function DCP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCP (see VARARGIN)

% Choose default command line output for DCP
handles.output = hObject;
location=mfilename('fullpath');%obtain the file's absolute path while running it
[pathstr,name,ext] = fileparts(location);%路径分割 
backgroundImage =importdata([pathstr '\image\preprocess.jpg']);
% 选择坐标系
axes(handles.axes1);
% 将图片添加到坐标系中，于是就成了背景了
image(backgroundImage.cdata);
% 将坐标系的坐标轴标签去掉
axis off
backgroundImage =importdata([pathstr '\image\tractography.jpg']);
% 选择坐标系
axes(handles.axes2);
% 将图片添加到坐标系中，于是就成了背景了
image(backgroundImage.cdata);
% 将坐标系的坐标轴标签去掉
axis off
backgroundImage =importdata([pathstr '\image\parcellation.jpg']);
% 选择坐标系
axes(handles.axes3);
% 将图片添加到坐标系中，于是就成了背景了
image(backgroundImage.cdata);
% 将坐标系的坐标轴标签去掉
axis off
backgroundImage =importdata([pathstr '\image\network.jpg']);
% 选择坐标系
axes(handles.axes4);
% 将图片添加到坐标系中，于是就成了背景了
image(backgroundImage.cdata);
% 将坐标系的坐标轴标签去掉
axis off
% Update handles structure
[pathstr,name,ext] = fileparts(mfilename('fullpath'));
set(handles.edit8,'String',[pathstr '\templates\MNI152_T1_1mm_brain.nii']);
guidata(hObject, handles);

% UIWAIT makes DCP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DCP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.

function pushbutton2_Callback(hObject, eventdata, handles)
globel_fname= uigetdir;
if(globel_fname==0)
    set(handles.txt_root,'String','Please select input file');    
else
set(handles.txt_root,'String',globel_fname);
% set(handles.button_run,'Visible','on')
% set(handles.button_default,'Visible','on')
timevec=datevec(datestr(now));
year=num2str(timevec(1));
year=year(3:end);
outputPath=[globel_fname '_result_' year '_' num2str(timevec(2)) '_' num2str(timevec(3)) '_'...
    num2str(timevec(4)) '_' num2str(timevec(5))];
set(handles.edit15,'String',outputPath);
end



% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_root_Callback(hObject, eventdata, handles)
% hObject    handle to txt_root (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_root as text
%        str2double(get(hObject,'String')) returns contents of txt_root as a double


% --- Executes during object creation, after setting all properties.
function txt_root_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_root (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_bet.
function list_bet_Callback(hObject, eventdata, handles)
% hObject    handle to list_bet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_bet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_bet


% --- Executes during object creation, after setting all properties.
function list_bet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_bet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global INIT_SWAP;
% contents = cellstr(get(hObject,'String'));
% if strcmp(contents{get(hObject,'Value')},''),
%     INIT_SWAP='';
% end
% 
% if strcmp(contents{get(hObject,'Value')},'x-y'),
%     INIT_SWAP='sxy';
% end
% 
% if strcmp(contents{get(hObject,'Value')},'x-z'),
%     INIT_SWAP='szx';
% end
% 
% if strcmp(contents{get(hObject,'Value')},'y-z'),
%     INIT_SWAP='syz';
% end
% Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox6


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_falow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_falow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_H_FA;
global INIT_L_FA;

low_fa=str2num(get(handles.edit_falow,'string'))
high_fa=str2num(get(handles.edit_fahigh,'string'))
if(low_fa<0 || low_fa >1 || low_fa>high_fa)
    msgbox('输入数据不合法！');
else
    INIT_H_FA=high_fa;
    INIT_L_FA=low_fa;
end
% Hints: get(hObject,'String') returns contents of edit_falow as text
%        str2double(get(hObject,'String')) returns contents of edit_falow as a double


% --- Executes during object creation, after setting all properties.
function edit_falow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_falow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fahigh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fahigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_H_FA;
global INIT_L_FA;

low_fa=str2num(get(handles.edit_falow,'string'))
high_fa=str2num(get(handles.edit_fahigh,'string'))
if(high_fa<0 || high_fa >1 || low_fa>high_fa)
    msgbox('输入数据不合法！');
else
    INIT_H_FA=high_fa;
    INIT_L_FA=low_fa;
end
% Hints: get(hObject,'String') returns contents of edit_fahigh as text
%        str2double(get(hObject,'String')) returns contents of edit_fahigh as a double


% --- Executes during object creation, after setting all properties.
function edit_fahigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fahigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_seed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_seed as text
%        str2double(get(hObject,'String')) returns contents of edit_seed as a double
% global INIT_ANGLE;
% angle=str2double(get(handles.edit_angle,'string'));
% INIT_ANGLE=angle;
global INIT_SEED;
INIT_SEED= str2double(get(hObject,'String'));




% --- Executes during object creation, after setting all properties.
function edit_seed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_seed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_angle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_ANGLE;
INIT_ANGLE=str2double(get(hObject,'String'));

% Hints: get(hObject,'String') returns contents of edit_angle as text
%         returns contents of edit_angle as a double


% --- Executes during object creation, after setting all properties.
function edit_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_filter.
function listbox_filter_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INIT_FILTER;
contents = cellstr(get(hObject,'String'));
INIT_FILTER=contents{get(hObject,'Value')};

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_filter


% --- Executes during object creation, after setting all properties.
function listbox_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_invert.
function listbox_invert_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_invert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_invert contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_invert
global INIT_INVERT;
contents = cellstr(get(hObject,'String'));
INIT_INVERT=contents{get(hObject,'Value')};

% --- Executes during object creation, after setting all properties.
function listbox_invert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_invert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
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
[template, path]= uigetfile;
if(template==0)
    set(handles.edit8,'String','Please select template')    
else
set(handles.edit8,'String',[path template])
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenamem pname]=uigetfile({'*.nii';'*.img';'*.*'},'Select the Template：')


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_run.
function button_run_Callback(hObject, eventdata, handles)
% hObject    handle to button_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(handles.txt_root,'String');
path= get(handles.txt_root,'String');
Init_GUI_global(handles);
global RESULT_FILE
global MATRIX;
RESULT_FILE = get(handles.edit15,'String');
if strcmp(num2str(path),'') || strcmp(num2str(path),'Please select input file') || isempty(path),
    h = warndlg('Not select input file','error');
    return;
else
    Path=dir(path);
    for i=3:numel(Path);
        if Path(i).isdir==1,
            files=dir([path '\' Path(i).name]),
            dir_num=0;
            for j=3:numel(files),
                if files(j).isdir==1,
                    dir_num=dir_num+1;
                end
            end
            if dir_num<1,
                h=warndlg([Path(i).name '''s data is illegal.'], 'error');
                return;
            end
        end
    end
end
if MATRIX==1,
    if strcmp(num2str(RESULT_FILE),'') || strcmp(num2str(RESULT_FILE),'Please select output file') || isempty(RESULT_FILE),
        h = warndlg('Not select ouput file','error');
        return;
    else ~exist(RESULT_FILE)
        mkdir(RESULT_FILE);
    end
end
DCP_root_level(path,handles);
% global INIT_START_FLODER;
% global INIT_END_FLODER;
% global INIT_NUM;
% 
% if INIT_START_FLODER == ' '  %全部执行文件件内的个体
%     DCP_root_level(path)
% else
%     if INIT_END_FLODER == ' '
%         DCP_root_level(path,INIT_START_FLODER,INIT_NUM); %起始文件夹+个数
%     else
%         DCP_root_level(path,INIT_START_FLODER,INIT_END_FLODER); % 起始文件夹+终止文件夹
%     end
% end




function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox2
toggle=get(handles.checkbox2,'Value'); %FSL_EDDY_FLAG

%aal1024_flag=get(handles.checkbox2,'Value');%AAL_1024_FLAG

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox3
toggle=get(handles.checkbox3,'Value'); %FSL_EDDY_FLAG


%aal90_flag=get(handles.checkbox3,'Value'); %AAL_90_FLAG

% --- Executes on button press in checkbox_filter.
function checkbox_filter_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filter_flag=get(handles.checkbox_filter,'Value');
% Hint: get(hObject,'Value') returns toggle state of checkbox_filter


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

  %初始化函数
%  dtk_init()



% --- Executes on button press in button_default.
function button_default_Callback(hObject, eventdata, handles)
% hObject    handle to button_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.checkbox7,'Value',1);
set(handles.radiobutton4, 'Value', 0.0);
set(handles.radiobutton17, 'Value', 1.0);
set(handles.radiobutton4,'Visible','on');
set(handles.radiobutton17,'Visible','on');
set(handles.checkbox10, 'Value',0);
set(handles.checkbox5, 'Value',1);
set(handles.edit_falow,'String','0.1');
set(handles.edit_fahigh,'String','1.0');
set(handles.edit_angle,'String','45');
set(handles.listbox_invert,'Value',1);
set(handles.edit_seed,'String','1');
set(handles.listbox6,'Value',1);
set(handles.checkbox6, 'Value',1);
[pathstr,name,ext] = fileparts(mfilename('fullpath'));
set(handles.edit8,'String',[pathstr '\templates\MNI152_T1_1mm_brain.nii']);
set(handles.checkbox2,'Value',1);
set(handles.checkbox3,'Value',1);
set(handles.edit17,'String','');
set(handles.list_bet,'Visible','on');
set(handles.checkbox11, 'Value',1);
set(handles.text4,'Visible','on');
set(handles.checkbox24,'Value',1);
set(handles.checkbox25,'Value',1);
set(handles.checkbox29,'Value',1);
set(handles.checkbox27,'Value',1);
set(handles.checkbox28,'Value',1);
set(handles.checkbox26,'Value',1);
set(handles.list_bet,'Value',1);





% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
run toolbox
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
%toggle=get(handles.checkbox8,'Value'); %NETWORK_FLAG

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
%toggle=get(handles.checkbox7,'Value'); %DICOM_FLAG
toggle=get(handles.checkbox7,'Value');
if toggle==1,
    set(handles.radiobutton17,'Visible','on');
    set(handles.radiobutton4,'Visible','on');
else
    set(handles.radiobutton17,'Visible','off');
    set(handles.radiobutton4,'Visible','off');
end

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
%toggle=get(handles.checkbox6,'Value'); %MATRIX_FLAG

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
% toggle=get(hObject,'Value');
% set(handles.checkbox5,'Value',0)
%toggle=get(handles.checkbox5,'Value'); %DTK_FLAG



% --- Executes during object creation, after setting all properties.
function button_run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to button_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox_invert.
function listbox_invert_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox_invert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'))
invert=contents{get(hObject,'Value')}


% --- Executes on key press with focus on listbox_invert and none of its controls.
function listbox_invert_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox_invert (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'))
invert=contents{get(hObject,'Value')}


% --- Executes during object creation, after setting all properties.
function checkbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
toggle=get(handles.radiobutton13,'Value'); %ACID_EDDY_FLAG
if toggle ==1 
    set(handles.radiobutton14,'Value',0);
else
    set(handles.radiobutton14,'Value',1);
  
    set(handles.checkbox5,'Value',0); %DTK_FLAG 
    set(handles.checkbox6,'Value',0); %MATRIX_FLAG
    set(handles.checkbox8,'Value',0); %NETWORK_FLAG

end


% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
toggle=get(handles.radiobutton14,'Value'); %FSL_EDDY_FLAG
if toggle ==1 
    set(handles.radiobutton13,'Value',0);
else
    set(handles.radiobutton13,'Value',1);
end

if toggle == 1
    set(handles.checkbox5,'Value',0); %DTK_FLAG 
    set(handles.checkbox6,'Value',0); %MATRIX_FLAG
    set(handles.checkbox8,'Value',0); %NETWORK_FLAG
end

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
toggle=get(handles.checkbox9,'Value'); %EEDY_FLAG
if toggle == 0
    
end



% 获取GUI全局变量值
function Init_GUI_global(handles)
global FILE_ORDER
FILE_ORDER=get(handles.edit20,'String');

global DICOM2NII_FLAG;
DICOM2NII_FLAG=get(handles.checkbox7,'Value'); %DICOM2NII_FLAG

global DICOM_DCM;
DICOM_DCM=get(handles.radiobutton17,'Value');


global DTK_FLAG;
DTK_FLAG=get(handles.checkbox5,'Value'); %DTK_FLAG
%MATRIX_FLAG 表示的是Parcellation
global MATRIX_FLAG;
MATRIX_FLAG=get(handles.checkbox6,'Value'); %MATRIX_FLAG

%matrix 1024 or 90
global AAL_1024_FLAG;
AAL_1024_FLAG=get(handles.checkbox2,'Value');%AAL_1024_FLAG
global AAL_90_FLAG;
AAL_90_FLAG=get(handles.checkbox3,'Value'); %AAL_90_FLAG


%DICOM to NII global:
global DTI_SPM_FLAG;
DTI_SPM_FLAG=get(handles.radiobutton4,'Value'); %DTI_SPM_FLAG

global T1_SKULL_FLAG
T1_SKULL_FLAG=get(handles.checkbox10,'Value'); %T1_SKULL_FLAG

global BET_P
contents = cellstr(get(handles.list_bet,'String'));
BET_P=contents{get(handles.list_bet,'Value')};

%dtk
global INIT_INVERT;
contents = cellstr(get(handles.listbox_invert,'String'));
INIT_INVERT=contents{get(handles.listbox_invert,'Value')};

global INIT_SWAP;
contents = cellstr(get(handles.listbox6,'String'));
INIT_SWAP=contents{get(handles.listbox6,'Value')};

global INIT_H_FA;
global INIT_L_FA;
INIT_L_FA=str2num(get(handles.edit_falow,'string'));
INIT_H_FA=str2num(get(handles.edit_fahigh,'string'));

global INIT_ANGLE;
INIT_ANGLE=str2double(get(handles.edit_angle,'String'));

global INIT_SEED;
INIT_SEED= str2double(get(handles.edit_seed,'String'));

global THRESHOLD_90;

global THRESHOLD_1024;

global THRESHOLD_CUSTOME;

global STANDARD_TEMPLATE;
STANDARD_TEMPLATE = get(handles.edit8, 'String');
global PARTITION_TEMPLATE;
PARTITION_TEMPLATE = get(handles.edit17,'String');
global EDDY_FLAG;
EDDY_FLAG = get(handles.checkbox24,'Value');
global TENSOR_FLAG;
TENSOR_FLAG = get(handles.checkbox25,'Value');
global MATRIX;
MATRIX = get(handles.checkbox29,'Value');
global FN_FLAG;
FN_FLAG = get(handles.checkbox26, 'Value');
global FA_FLAG;
FA_FLAG = get(handles.checkbox27,'Value');
global LENGTH_FLAG;
LENGTH_FLAG = get(handles.checkbox28,'Value');


function pre_DCP_root_level(path)
global INIT_START_FLODER;
INIT_START_FLODER = 0;
global INIT_END_FLODER;
global INIT_NUM;
if INIT_START_FLODER == 0  %全部执行文件件内的个体
    DCP_root_level(path)
else
    [pathstr,start_name,ext] = fileparts(INIT_START_FLODER);% 子文件夹作为name
    if INIT_END_FLODER == ' '
        if path ~= pathstr
             disp('ERROR! You should choose a right start_folder! ');
             return;
        else
            DCP_root_level(path,start_name,INIT_NUM); %起始文件夹+个数
        end
    else
        [pathstr,end_name,ext] = fileparts(INIT_END_FLODER);% 子文件夹作为name
        if path ~= pathstr
             disp('ERROR! You should choose a right end_folder! ');
             return;
        else
            DCP_root_level(path,start_name,end_name); % 起始文件夹+终止文件夹
        end
    end
end

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
toggle=get(handles.checkbox10,'Value'); %FSL_EDDY_FLAG
if toggle ==1 
    set(handles.checkbox11,'Value',0);
    set(handles.text4,'Visible','off');
    set(handles.list_bet,'Visible','off');
else
    set(handles.checkbox11,'Value',1);
    set(handles.text4,'Visible','on');
    set(handles.list_bet,'Visible','on');
end

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
toggle=get(handles.checkbox10,'Value'); %FSL_EDDY_FLAG
if toggle ==1 
    set(handles.checkbox10,'Value',0);
    set(handles.text4,'Visible','on');
    set(handles.list_bet,'Visible','on');
    %default bet 0.5
    
%    set(handles.list_bet,'Value',0.5);
    
    
else
    set(handles.checkbox10,'Value',1);
    set(handles.text4,'Visible','off');
    set(handles.list_bet,'Visible','off');
end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton17,'Value',0.0)
% Hint: get(hObject,'Value') returns toggle state of radiobutton4



 
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globel_fname= uigetdir;
if(globel_fname==0)
    set(handles.edit15,'String','Please select output file')    
else
set(handles.edit15,'String',globel_fname)
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[template, path]= uigetfile;
if(template==0)
    set(handles.edit17,'String','Please select template')    
else
set(handles.edit17,'String',[path template])
end


% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton4,'Value',0.0)
% Hint: get(hObject,'Value') returns toggle state of radiobutton17


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton11.
function pushbutton11_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes on button press in checkbox25.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20


% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21


% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


% --- Executes on button press in checkbox27.
function checkbox27_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


% --- Executes on button press in checkbox28.
function checkbox28_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox28


% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sub_id=get(handles.edit20,'String');
if isempty(sub_id) || strcmp(sub_id,'') ||strcmp(sub_id,'ALL SUBJECTS'),
    set(handles.edit20,'String','ALL SUBJECTS');
else
    try 
        sub_id_num=eval(sub_id);
    catch
        h=warndlg('subjects'' id is illegal','error');
        return;
    end
    set(handles.edit20,'String',num2str(eval(sub_id))); 
end

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
