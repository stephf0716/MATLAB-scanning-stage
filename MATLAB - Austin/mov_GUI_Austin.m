function varargout = mov_GUI_Austin(varargin)
% MOV_GUI_AUSTIN MATLAB code for mov_GUI_Austin.fig
%      MOV_GUI_AUSTIN, by itself, creates a new MOV_GUI_AUSTIN or raises the existing
%      singleton*.
%
%      H = MOV_GUI_AUSTIN returns the handle to a new MOV_GUI_AUSTIN or the handle to
%      the existing singleton*.
%
%      MOV_GUI_AUSTIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOV_GUI_AUSTIN.M with the given input arguments.
%
%      MOV_GUI_AUSTIN('Property','Value',...) creates a new MOV_GUI_AUSTIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mov_GUI_Austin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mov_GUI_Austin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mov_GUI_Austin

% Last Modified by GUIDE v2.5 12-Jul-2016 14:29:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mov_GUI_Austin_OpeningFcn, ...
                   'gui_OutputFcn',  @mov_GUI_Austin_OutputFcn, ...
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


% --- Executes just before mov_GUI_Austin is made visible.
function mov_GUI_Austin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mov_GUI_Austin (see VARARGIN)

% Choose default command line output for mov_GUI_Austin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mov_GUI_Austin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mov_GUI_Austin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in connect_to_controller.
function connect_to_controller_Callback(hObject, eventdata, handles)
%% CONNECT SCOPE
% Connect when connect_scope button pushed
% hObject    handle to connect_to_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller;
com_port = 'COM6';
global_controller = serial(com_port, 'BaudRate',9600);
if isvalid(global_controller)
    fclose(global_controller)
    fopen(global_controller);
    if com_port == 'COM6'
        display('Newmark Controller Connected')
    elseif com_port == 'COM1'
        display('Prior Controller Connected')
    end       
    set(handles.disconnect_from_controller, 'Enable','on')
    set(handles.connect_to_controller,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% --- Executes on button press in disconnect_from_controller.
function disconnect_from_controller_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect_from_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller; 
fclose(global_controller);
if com_port == 'COM6'
    display('Newmark Controller Disconnected');
elseif com_port == 'COM1'
    display('Prior Controller Disconnected');
end
set (handles.disconnect_from_controller,'Enable','off')
set(handles.connect_to_controller,'Enable','on')


function input_distance_Callback(hObject, eventdata, handles)
% hObject    handle to input_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_distance as text
%        str2double(get(hObject,'String')) returns contents of input_distance as a double
input_distance = str2double(get(hObject,'String'));
if isnan(input_distance) || ~isreal(input_distance) %If input is a real number - enable Z+,Z-,X+,X- buttons
    set(handles.z_pos,'Enable','off')
    set(handles.z_neg,'Enable','off')
    set(handles.y_neg,'Enable','off')
    set(handles.y_pos,'Enable','off')
    set(handles.x_pos,'Enable','off')
    set(handles.x_neg,'Enable','off')
    uicontrol(hObject)
else
    set(handles.z_pos,'Enable','on')    %If input is not a real number - disable Z+,Z-,X+,X- buttons
    set(handles.z_neg,'Enable','on')
    set(handles.y_neg,'Enable','on')
    set(handles.y_pos,'Enable','on')    
    set(handles.x_pos,'Enable','on')
    set(handles.x_neg,'Enable','on')
end

% --- Executes during object creation, after setting all properties.
function input_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in z_pos.
function z_pos_Callback(hObject, eventdata, handles)
%%  Z+ BUTTON
% hObject    handle to z_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM1'
    %need working Prior Code
    
elseif com_port == 'COM6'
    %Newmark has no Z-Axis
    
end

% --- Executes on button press in y_neg.
function y_neg_Callback(hObject, eventdata, handles)
%% Y- BUTTON
% hObject    handle to y_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM6'
    fprintf(global_controller, 'AY;UF;');
fprintf(global_controller, 'AY;UU25;');
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(global_controller, ['AY;MR' user_input ';GO;']);
disp(['AX;MR-' user_input])

elseif com_port == 'COM1'
    %Need working Prior Code
    
end

% --- Executes on button press in y_pos.
function y_pos_Callback(hObject, eventdata, handles)
%% Y+ BUTTON
% hObject    handle to y_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM6'
    fprintf(global_controller, 'AY;UF;');
fprintf(global_controller, 'AY;UU25;');
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input))); 
fprintf(global_controller, ['AY;MR-' user_input ';GO;']); 
disp(['AX;MR' user_input])

elseif com_port == 'COM1'
    %Need Working Prior Code
    
end 
    

% --- Executes on button press in x_pos.
function x_pos_Callback(hObject, eventdata, handles)
%% X+ BUTTON
% hObject    handle to x_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM6'
    fprintf(global_controller, 'AX;UF;');
fprintf(global_controller, 'AX;UU25;');
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(global_controller, ['AX;MR' user_input ';GO;']);
disp(['AX;MR' user_input])
  
elseif com_port == 'COM1'
    %Need Working Prior Code
end

% --- Executes on button press in x_neg.
function x_neg_Callback(hObject, eventdata, handles)
%% X- BUTTON
% hObject    handle to x_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM6' %#ok<*STCMP>
    fprintf(global_controller, 'AX;UF;');
fprintf(global_controller, 'AX;UU25;');
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(global_controller, ['AX;MR-' user_input ';GO;']);
disp(['AX;MR-' user_input])

elseif com_port == 'COM1'
    %Need Working Prior Code

end

% --- Executes on button press in z_neg.
function z_neg_Callback(hObject, eventdata, handles)
%% Z- BUTTON
% hObject    handle to z_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_controller

if com_port == 'COM6'
    %Newmark has no Z-Axis
    
elseif com_port == 'COM1'
    %Need working Prior Code
    
end
% --- Executes on selection change in controller_select.
function controller_select_Callback(hObject, eventdata, handles)
%% SELECT SCOPE
% hObject    handle to controller_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch {com_port}
    case 'Newmark Controller'
            com_port = 'COM6';
    case 'Prior Controller'
            com_port = 'COM1';
end
       

% Hints: contents = cellstr(get(hObject,'String')) returns controller_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from controller_select


% --- Executes during object creation, after setting all properties.
function controller_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controller_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
