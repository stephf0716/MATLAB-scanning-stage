function varargout = mov_acq_GUI(varargin)
% MOV_GUI MATLAB code for mov_GUI.fig
% GUI backend code:
%   handles moves of all three axes
%   The COM port must be correct in order to connect
%   First connect to the controller
%   The number entered for movement must be real and non-negative otherwise
%       the movement buttons will not be available.
%   Disconnect from the controller when done

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mov_acq_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mov_acq_GUI_OutputFcn, ...
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


% --- Executes just before mov_GUI is made visible.
function mov_acq_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% populates the pop up menu with available COM ports
serialPorts = instrhwinfo('serial');
nPorts = length(serialPorts.SerialPorts);
set(handles.serial_ports, 'String', ...
    [{'Select a port'} ; serialPorts.SerialPorts ]);
set(handles.serial_ports, 'Value', 2);   

% Choose default command line output for mov_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mov_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mov_acq_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in x_neg.
function x_neg_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR -' user_input ',0,0;BG;']);
disp(['PR -' user_input ',0,0;BG;'])

% --- Executes on button press in x_pos.
function x_pos_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR ' user_input ',0,0;BG;']);
disp(['PR ' user_input ',0,0;BG;'])

% --- Executes on button press in y_pos.
function y_neg_Callback(hObject, eventdata, handles)
% hObject    handle to y_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR 0,' user_input ',0;BG;']);
disp(['PR 0,' user_input ',0;BG;'])

% --- Executes on button press in y_neg.
function y_pos_Callback(hObject, eventdata, handles)
% hObject    handle to y_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR 0,-' user_input ',0;BG;']);
disp(['PR 0,-' user_input ',0;BG;'])

% --- Executes on button press in z_neg.
function z_neg_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR 0,0,-' user_input ';BG;']);
disp(['PR 0,0,-' user_input ';BG;'])

% --- Executes on button press in z_pos.
function z_pos_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
user_input = get(handles.movement,'String');
user_input = int2str(round(str2num(user_input)*2519.685));
fprintf(newmark_controller,'%s', ['PR 0,0,' user_input ';BG;']);
disp(['PR 0,0,' user_input ';BG;'])


function movement_Callback(hObject, eventdata, handles)
%%  movement
% hObject    handle to movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Validate that the text in the movement field converts to a real number
movement = str2double(get(hObject,'String'));
if isnan(movement) || ~isreal(movement)  
    % return NaN for complex or non-numbers
    % Disable the move buttons 
    set(handles.x_neg,'Enable','off')
    set(handles.x_pos,'Enable','off')
    set(handles.y_neg,'Enable','off')
    set(handles.y_pos,'Enable','off')
    set(handles.z_neg,'Enable','off')
    set(handles.z_pos,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the move buttons
    set(handles.x_neg,'Enable','on')
    set(handles.x_pos,'Enable','on')
    set(handles.y_neg,'Enable','on')
    set(handles.y_pos,'Enable','on')
    set(handles.z_neg,'Enable','on')
    set(handles.z_pos,'Enable','on')
end
% Hints: get(hObject,'String') returns contents of movement as text
%        str2double(get(hObject,'String')) returns contents of movement as a double


% --- Executes during object creation, after setting all properties.
function movement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_to_controller.
function connect_to_controller_Callback(hObject, eventdata, handles)
%%  connect_to_controller
% hObject    handle to connect_to_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
com_port_num = get(handles.serial_ports, 'Value'); % selected port
com_list = get(handles.serial_ports,'String');
com_port = com_list{com_port_num};
newmark_controller = serial(com_port,'BaudRate',19200); % create serial conn
if isvalid(newmark_controller)
    fopen(newmark_controller); % open connection
    display('Newmark Controller Connected')
    set(handles.disconnect_controller,'Enable','on')
    set(handles.connect_to_controller,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% --- Executes on button press in disconnect_controller.
function disconnect_controller_Callback(hObject, eventdata, handles)
%%  disconnect_controller
% hObject    handle to disconnect_controller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose(newmark_controller); % open connection
display('Newmark Controller Disconnected');
set(handles.disconnect_controller,'Enable','off')
set(handles.connect_to_controller,'Enable','on')

% --- Executes on selection change in serial_ports.
function serial_ports_Callback(hObject, eventdata, handles)
% hObject    handle to serial_ports (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in osc_acquire.
function osc_acquire_Callback(hObject, eventdata, handles)
% hObject    handle to osc_acquire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_name = get(handles.filename,'String');
tek_acq_fn(file_name)



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
