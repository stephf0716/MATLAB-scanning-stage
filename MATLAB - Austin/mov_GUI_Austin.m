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

% Last Modified by GUIDE v2.5 05-Jul-2016 11:59:55

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


% --- Executes on button press in x_pos_new.
function x_pos_new_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in z_pos_new.
function z_pos_new_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in x_neg_new.
function x_neg_new_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in z_neg_new.
function z_neg_new_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in x_pos_prior.
function x_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in z_pos_prior.
function z_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in y_neg_prior.
function y_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to y_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in y_pos_prior.
function y_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to y_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in x_neg_prior.
function x_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in z_neg_prior.
function z_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in serial_ports.
function serial_ports_Callback(hObject, eventdata, handles)
% hObject    handle to serial_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch(handles.current_port)
        case 'prior'
            handles.current_port = 'COM1';
        case 'newmark'
            handles.current_port = 'COM6';
end
    guidata(hObject,handles)
        
            
% Hints: contents = cellstr(get(hObject,'String')) returns serial_ports contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_ports


% --- Executes during object creation, after setting all properties.
function serial_ports_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_to_controller.
function connect_to_controller_Callback(hObject, eventdata, handles)
% hObject    handle to connect_to_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in disconnect_from_controller.
function disconnect_from_controller_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect_from_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
