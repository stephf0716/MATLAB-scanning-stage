function varargout = Prior_mov_GUI_Austin(varargin)
% PRIOR_MOV_GUI_AUSTIN MATLAB code for Prior_mov_GUI_Austin.fig
%      PRIOR_MOV_GUI_AUSTIN, by itself, creates a new PRIOR_MOV_GUI_AUSTIN or raises the existing
%      singleton*.
%
%      H = PRIOR_MOV_GUI_AUSTIN returns the handle to a new PRIOR_MOV_GUI_AUSTIN or the handle to
%      the existing singleton*.
%
%      PRIOR_MOV_GUI_AUSTIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRIOR_MOV_GUI_AUSTIN.M with the given input arguments.
%
%      PRIOR_MOV_GUI_AUSTIN('Property','Value',...) creates a new PRIOR_MOV_GUI_AUSTIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Prior_mov_GUI_Austin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Prior_mov_GUI_Austin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Prior_mov_GUI_Austin

% Last Modified by GUIDE v2.5 05-Jul-2016 15:42:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prior_mov_GUI_Austin_OpeningFcn, ...
                   'gui_OutputFcn',  @Prior_mov_GUI_Austin_OutputFcn, ...
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


% --- Executes just before Prior_mov_GUI_Austin is made visible.
function Prior_mov_GUI_Austin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Prior_mov_GUI_Austin (see VARARGIN)

% Choose default command line output for Prior_mov_GUI_Austin
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Prior_mov_GUI_Austin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Prior_mov_GUI_Austin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in z_pos_prior.
function z_pos_prior_Callback(hObject, eventdata, handles)
%%  Z+ BUTTON
% hObject    handle to z_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,0,%d\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in z_neg_prior.
function z_neg_prior_Callback(hObject, eventdata, handles)
%%  Z- BUTTON
% hObject    handle to z_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,0,-%d\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in y_pos_prior.
function y_pos_prior_Callback(hObject, eventdata, handles)
%% Y+ BUTTON
% hObject    handle to y_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,-%d,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in y_neg_prior.
function y_neg_prior_Callback(hObject, eventdata, handles)
%%  Y- BUTTON
% hObject    handle to y_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,%d,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in x_pos_prior.
function x_pos_prior_Callback(hObject, eventdata, handles)
%%  X+ BUTTON
% hObject    handle to x_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,%d,0,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in x_neg_prior.
function x_neg_prior_Callback(hObject, eventdata, handles)
%%  X- BUTTON
% hObject    handle to x_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,-%d,0,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 


% --- Executes on button press in connect_to_controller.
function connect_to_controller_Callback(hObject, eventdata, handles)
%% CONNECT SCOPE
% Connects when conn_scop button pushed
% hObject    handle to connect_to_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller
com_port = 'COM1';
prior_controller = serial(com_port, 'BaudRate',9600);
if isvalid(prior_controller)
    fclose(prior_controller)
    fopen(prior_controller);
    display('Prior Controller Connected')
    set(handles.disconnect_from_controller, 'Enable','on')
    set(handles.connect_to_controller,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% --- Executes on button press in disconnect_from_controller.
function disconnect_from_controller_Callback(hObject, eventdata, handles)
%% DISCONNECT SCOPE
% Disconnects when disconn_scope button pushed
% hObject    handle to disconnect_from_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller; 
fclose(prior_controller);
display('Prior Controller Disconnected');
set (handles.disconnect_from_controller,'Enable','off')
set(handles.connect_to_controller,'Enable','on')


function input_distance_Callback(hObject, eventdata, handles)
% hObject    handle to input_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_distance = str2double(get(hObject,'String'));
if isnan(input_distance) || ~isreal(input_distance) %If input is a real number - enable Z+,Z-,X+,X-,Y+,Y- buttons
    set(handles.z_pos_prior,'Enable','off')
    set(handles.z_neg_prior,'Enable','off')
    set(handles.y_neg_prior,'Enable','off')
    set(handles.y_pos_prior,'Enable','off')
    set(handles.x_pos_prior,'Enable','off')
    set(handles.x_neg_prior,'Enable','off')
    uicontrol(hObject)
else
    set(handles.z_pos_prior,'Enable','on')  %If input is not a real number - disable Z+,Z-,X+,X-,Y+,Y- buttons
    set(handles.z_neg_prior,'Enable','on')
    set(handles.y_neg_prior,'Enable','on')
    set(handles.y_pos_prior,'Enable','on')    
    set(handles.x_pos_prior,'Enable','on')
    set(handles.x_neg_prior,'Enable','on')
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
