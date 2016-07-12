function varargout = Newmark_mov_GUI_Austin(varargin)
% NEWMARK_MOV_GUI_AUSTIN MATLAB code for Newmark_mov_GUI_Austin.fig
%      NEWMARK_MOV_GUI_AUSTIN, by itself, creates a new NEWMARK_MOV_GUI_AUSTIN or raises the existing
%      singleton*.
%
%      H = NEWMARK_MOV_GUI_AUSTIN returns the handle to a new NEWMARK_MOV_GUI_AUSTIN or the handle to
%      the existing singleton*.
%
%      NEWMARK_MOV_GUI_AUSTIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWMARK_MOV_GUI_AUSTIN.M with the given input arguments.
%
%      NEWMARK_MOV_GUI_AUSTIN('Property','Value',...) creates a new NEWMARK_MOV_GUI_AUSTIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Newmark_mov_GUI_Austin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Newmark_mov_GUI_Austin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Newmark_mov_GUI_Austin

% Last Modified by GUIDE v2.5 05-Jul-2016 13:54:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Newmark_mov_GUI_Austin_OpeningFcn, ...
                   'gui_OutputFcn',  @Newmark_mov_GUI_Austin_OutputFcn, ...
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


% --- Executes just before Newmark_mov_GUI_Austin is made visible.
function Newmark_mov_GUI_Austin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Newmark_mov_GUI_Austin (see VARARGIN)

% Choose default command line output for Newmark_mov_GUI_Austin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Newmark_mov_GUI_Austin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Newmark_mov_GUI_Austin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in z_pos_new.
function z_pos_new_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input))); 
fprintf(newmark_controller, ['AY;MR-' user_input ';GO;']); 
disp(['AX;MR' user_input])

% --- Executes on button press in z_neg_new.
function z_neg_new_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AY;MR' user_input ';GO;']);
disp(['AX;MR-' user_input])

% --- Executes on button press in x_pos_new.
function x_pos_new_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AX;MR' user_input ';GO;']);
disp(['AX;MR' user_input])


% --- Executes on button press in x_neg_new.
function x_neg_new_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AX;MR-' user_input ';GO;']);
disp(['AX;MR-' user_input])

% --- Executes on button press in connect_to_controller.
function connect_to_controller_Callback(hObject, eventdata, handles)
% hObject    handle to connect_to_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller
com_port = 'COM6';
newmark_controller = serial(com_port, 'BaudRate',9600);
if isvalid(newmark_controller)
    fclose(newmark_controller)
    fopen(newmark_controller);
    display('Newmark Controller Connected')
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
global newmark_controller; 
fclose(newmark_controller);
display('Newmark Controller Disconnected');
set (handles.disconnect_from_controller,'Enable','off')
set(handles.connect_to_controller,'Enable','on')



function input_distance_Callback(hObject, eventdata, handles)
% hObject    handle to input_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_distance = str2double(get(hObject,'String'));
if isnan(input_distance) || ~isreal(input_distance)
    set(handles.z_pos_new,'Enable','off')
    set(handles.z_neg_new,'Enable','off')
    set(handles.x_pos_new,'Enable','off')
    set(handles.x_neg_new,'Enable','off')
    uicontrol(hObject)
else
    set(handles.z_pos_new,'Enable','on')
    set(handles.z_neg_new,'Enable','on')
    set(handles.x_pos_new,'Enable','on')
    set(handles.x_neg_new,'Enable','on')
end



% Hints: get(hObject,'String') returns contents of input_distance as text
%        str2double(get(hObject,'String')) returns contents of input_distance as a double


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
