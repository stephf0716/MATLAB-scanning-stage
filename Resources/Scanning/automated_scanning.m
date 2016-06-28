function varargout = automated_scanning(varargin)
% AUTOMATED_SCANNING MATLAB code for automated_scanning.fig
%      AUTOMATED_SCANNING, by itself, creates a new AUTOMATED_SCANNING or raises the existing
%      singleton*.
%
%      H = AUTOMATED_SCANNING returns the handle to a new AUTOMATED_SCANNING or the handle to
%      the existing singleton*.
%
%      AUTOMATED_SCANNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMATED_SCANNING.M with the given input arguments.
%
%      AUTOMATED_SCANNING('Property','Value',...) creates a new AUTOMATED_SCANNING or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before automated_scanning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to automated_scanning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help automated_scanning

% Last Modified by GUIDE v2.5 24-Jun-2015 18:55:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @automated_scanning_OpeningFcn, ...
                   'gui_OutputFcn',  @automated_scanning_OutputFcn, ...
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

% --- Executes just before automated_scanning is made visible.
function automated_scanning_OpeningFcn(hObject, eventdata, handles, varargin)
% populates the pop up menu with available COM ports
COM_ports = instrhwinfo('serial');
nPorts = length(COM_ports.SerialPorts);
set(handles.serial_popup, 'String', ...
    [{'Select a port'} ; COM_ports.SerialPorts ]);
set(handles.serial_popup, 'Value', 2);

% Choose default command line output for automated_scanning
handles.output = hObject;

% %% TIMER
% % Create a timer object to fire at 1/10 sec intervals
% % Specify function handles for its start and run callbacks
% handles.timer = timer(...
%     'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly
%     'Period', 1, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_pos,hObject}); % Specify callback function
% 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes automated_scanning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = automated_scanning_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------

% --- Executes on button press in x_neg.
function x_neg_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR -' user_input ',0,0;BG;']);
disp(['PR -' user_input ',0,0;BG;'])
update_pos(hObject, eventdata, handles)

% --- Executes on button press in x_pos.
function x_pos_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR ' user_input ',0,0;BG;']);
disp(['PR ' user_input ',0,0;BG;'])
update_pos(hObject, eventdata, handles)

% --- Executes on button press in y_pos.
function y_neg_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR 0,' user_input ',0;BG;']);
disp(['PR 0,' user_input ',0;BG;'])
update_pos(hObject, eventdata, handles)

% --- Executes on button press in y_neg.
function y_pos_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR 0,-' user_input ',0;BG;']);
disp(['PR 0,-' user_input ',0;BG;'])
update_pos(hObject, eventdata, handles)

% --- Executes on button press in z_neg.
function z_neg_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR 0,0,-' user_input ';BG;']);
disp(['PR 0,0,-' user_input ';BG;'])
update_pos(hObject, eventdata, handles)

% --- Executes on button press in z_pos.
function z_pos_Callback(hObject, eventdata, handles)
global newmark_controller;
user_input = get(handles.step,'String');
user_input = int2str(round(str2num(user_input)*31496));
fprintf(newmark_controller,'%s', ['PR 0,0,' user_input ';BG;']);
disp(['PR 0,0,' user_input ';BG;'])
update_pos(hObject, eventdata, handles)

function step_Callback(hObject, eventdata, handles)
%% step definition
% make sure that step input is a real number and not NaN
step = str2double(get(hObject,'String'));
if isnan(step) || ~isreal(step)  
    % return NaN for complex or non-numbers
    % disable the move buttons 
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

% --- Executes during object creation, after setting all properties.
function step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_button.
function connect_button_Callback(hObject, eventdata, handles)
%%  connect_to_controller
global newmark_controller;
com_port_num = get(handles.serial_popup, 'Value'); % selected port
com_list = get(handles.serial_popup,'String');
com_port = com_list{com_port_num};
newmark_controller = serial(com_port,'BaudRate',19200); % serial connection
if isvalid(newmark_controller)
    fopen(newmark_controller); % open connection
    display('Newmark Controller Connected')
    set(handles.disconn_button,'Enable','on')
    set(handles.connect_button,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% % Only start timer if it is not running
% if strcmp(get(handles.timer, 'Running'), 'off')
%     start(handles.timer);
% end

% --- Executes on button press in disconn_button.
function disconn_button_Callback(hObject, eventdata, handles)
%%  disconnect_controller
global newmark_controller;
fclose(newmark_controller); % close connection
display('Newmark Controller Disconnected');
set(handles.disconn_button,'Enable','off')
set(handles.connect_button,'Enable','on')

% % Only stop timer if it is running
% if strcmp(get(handles.timer, 'Running'), 'on')
%     stop(handles.timer);

% --- Executes on selection change in serial_popup.
function serial_popup_Callback(hObject, eventdata, handles)
% hObject    handle to serial_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serial_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_popup


% --- Executes during object creation, after setting all properties.
function serial_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function update_pos(hObject,eventdata,handles)
%% UPDATE FUNCTION
% Gets current pos, and writes it back to text field object.
global newmark_controller;
% report pos when motion complete
fprintf(newmark_controller,'%s', 'MC;RP;'); 
out = fscanf(newmark_controller, '%*s %d,%d,%d');
% disp(out); %DEBUG
new_out = num2str(round(out/31496));
set(handles.current_pos_text, 'String', mat2str(new_out));

% % --- Executes on button press in acq_button.
% function acq_button_Callback(hObject, eventdata, handles)
% %% Oscilloscope acquisition
% % creates a file with given name
% file_name = get(handles.filename,'String');
% tek_acq_fn(file_name)

% --- Executes on button press in home_button.
function home_button_Callback(hObject, eventdata, handles)
%% HOME
global newmark_controller;
fprintf(newmark_controller,'%s', 'PA 0,0,0;BG;');
update_pos(hObject, eventdata, handles)

% --- Executes on button press in zero_button.
function zero_button_Callback(hObject, eventdata, handles)
%% ZERO
global newmark_controller;
fprintf(newmark_controller,'%s', 'DP 0,0,0;');
update_pos(hObject, eventdata, handles)

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes during object creation, after setting all properties.
function current_pos_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_pos_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in update_button.
function update_button_Callback(hObject, eventdata, handles)
% hObject    handle to update_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_pos(hObject, eventdata, handles)
