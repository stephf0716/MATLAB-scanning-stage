function varargout = automated_scanning(varargin)
% AUTOMATED_SCANNING MATLAB code for automated_scanning.fig
%   This is the GUI for controlling:
%   - Newmark Stage (Manual)
%   - Oscilloscope (Manual Acquisition)
%   - Automated scanning for beamforming measurements
% Edit the above text to modify the response to help automated_scanning

% Last Modified by GUIDE v2.5 13-Jan-2016 17:57:02
%TEST

% =========================================================
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
% =========================================================


%% =========================================================
% UI initialization
% =========================================================
% --- Executes just before automated_scanning is made visible.
function automated_scanning_OpeningFcn(hObject, eventdata, handles, varargin)
%% POPULATE the pop up menu with available COM ports
COM_ports = instrhwinfo('serial');
set(handles.serial_popup, 'String', ...
    [{'Select a port'} ; COM_ports.SerialPorts ]);
set(handles.serial_popup, 'Value', 2);
set(handles.scope_ch_popup, 'String', ...
    [{'Select scope ch'} ; '1'; '2'; '3'; '4' ]);
set(handles.scope_ch_popup, 'Value', 2);

set(handles.serial_popup2, 'String', ...
    [{'Select a port'} ; COM_ports.SerialPorts ]);
set(handles.serial_popup2, 'Value', 2);

% Choose default command line output for automated_scanning
handles.output = hObject;

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

function figure1_DeleteFcn(hObject, eventdata, handles)
%% EXIT ROUTINE
% --- Executes during object deletion, before destroying properties.
% Disconnects the stage controller and oscilloscope upon exit
global newmark_controller tek_scope;
if ~strcmp(get(newmark_controller,{'Status'}),'closed')
    fclose(newmark_controller); % close connection to stage
    display('Newmark Controller Disconnected');
end
if ~strcmp(get(tek_scope,{'Status'}),'closed')
    fclose(tek_scope);  % close connection to oscilloscope
    disp('Oscilloscope Disconnected')
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% close(handles.figure1)
delete(hObject)
% Hint: delete(hObject) closes the figure

%%=========================================================
% END UI initialization
% =========================================================


%% =========================================================
%  ---- STAGE CONNECTION PANEL ----
%  =========================================================
function connect_button_Callback(hObject, eventdata, handles)
%%  CONNECT BUTTON
% --- Executes on button press in connect_button.
% creates connection to the Newmark controller for the stage
% and also creates connection to Tek scope
global newmark_controller prior_controller tek_scope;
% serial connection to Newmark stage
com_port_num = get(handles.serial_popup, 'Value'); % selected port
com_list = get(handles.serial_popup,'String');
com_port = com_list{com_port_num};
newmark_controller = serial(com_port,'BaudRate',19200);
if isvalid(newmark_controller)
    fopen(newmark_controller); % open connection
    display('Newmark Controller Connected')
    set(handles.disconn_button,'Enable','on') % toggle the connect buttons
    set(handles.connect_button,'Enable','off')
else
    warndlg('Serial port is not valid')
end
% serial connection to Prior stage
com_port_num = get(handles.serial_popup2, 'Value'); % selected port
com_list = get(handles.serial_popup2,'String');
com_port = com_list{com_port_num};
prior_controller = serial(com_port,'BaudRate',19200);
if isvalid(prior_controller)
    fopen(prior_controller); % open connection
    display('Prior Controller Connected')
    set(handles.disconn_button,'Enable','on') % toggle the connect buttons
    set(handles.connect_button,'Enable','off')
else
    warndlg('Serial port is not valid')
end
% VISA connection to the Tektronix oscilloscope
tek_addr = get(handles.scope_addr, 'String'); 
tek_scope = instrfind('Type', 'visa-usb', 'RsrcName',...
 tek_addr, 'Tag', '');
% Create the VISA-GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(tek_scope)
    tek_scope = visa('TEK', tek_addr);
else
    fclose(tek_scope);
    tek_scope = tek_scope(1);
end
% Adjust input buffer for scope
tek_scope.InputBufferSize = 100000;
fopen(tek_scope);   % open connections
set(handles.zero_button,'Enable','on')
set(handles.home_button,'Enable','on')
% Query instrument with *IDN?
instrumentID = query(tek_scope,'*IDN?');
if isempty(instrumentID)
    throw(MException('tek_scopeCapture:ConnectionError',...
                     'Unable to connect to instrument'));
end
disp(['Connected to: ' instrumentID]);
set(handles.disconn_scope,'Enable','on') % toggle the connect buttons
set(handles.connect_scope,'Enable','off')
set(handles.acq_button,'Enable','on')

function disconn_button_Callback(hObject, eventdata, handles)
%%  DISCONNECT BUTTON
% --- Executes on button press in disconn_button.
% disconnects both the Newmark stage and the oscilloscope
global newmark_controller tek_scope;
fclose(newmark_controller); % close connection to stage
display('Newmark Controller Disconnected');
set(handles.disconn_button,'Enable','off') % toggle the buttons
set(handles.connect_button,'Enable','on')
set(handles.zero_button,'Enable','off')
set(handles.home_button,'Enable','off')
fclose(tek_scope); % close connection to oscilloscope
set(handles.disconn_scope,'Enable','off') % toggle the connect buttons
set(handles.connect_scope,'Enable','on')
set(handles.acq_button,'Enable','off')
disp('Oscilloscope Disconnected')

function disconn_button_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
set(hObject,'Enable','off')

%% --- serial_popup GUIDE generated code
function serial_popup_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function serial_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in serial_popup2.
function serial_popup2_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function serial_popup2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 31496 steps = 1 mm
% 314.96 steps ~ 0.01 mm = 10 um
% 31.496 steps ~ 0.001 mm = 1 um   
function x_y_res_Callback(hObject, eventdata, handles)
%
function x_y_res_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function z_res_Callback(hObject, eventdata, handles)
%
function z_res_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%=========================================================
% ---- END NEWMARK STAGE CONNECTION PANEL ----
% =========================================================


%% =========================================================
%   ---- STAGE MANUAL CONTROLS PANEL ----
%  =========================================================
%% Move Button Function Definition
function x_neg_Callback(hObject, eventdata, handles)
%% --- Executes on button press in x_neg.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.x_y_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR -' user_input ',0,0;BG;']);
disp(['PR -' user_input ',0,0;BG;'])
update_pos(hObject, eventdata, handles)
function x_pos_Callback(hObject, eventdata, handles)
%% --- Executes on button press in x_pos.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.x_y_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR ' user_input ',0,0;BG;']);
disp(['PR ' user_input ',0,0;BG;'])
update_pos(hObject, eventdata, handles)
function y_neg_Callback(hObject, eventdata, handles)
%% --- Executes on button press in y_pos.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.x_y_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR 0,' user_input ',0;BG;']);
disp(['PR 0,' user_input ',0;BG;'])
update_pos(hObject, eventdata, handles)
function y_pos_Callback(hObject, eventdata, handles)
%% --- Executes on button press in y_neg.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.x_y_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR 0,-' user_input ',0;BG;']);
disp(['PR 0,-' user_input ',0;BG;'])
update_pos(hObject, eventdata, handles)
function z_neg_Callback(hObject, eventdata, handles)
%% --- Executes on button press in z_neg.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.z_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR 0,0,-' user_input ';BG;']);
disp(['PR 0,0,-' user_input ';BG;'])
update_pos(hObject, eventdata, handles)
function z_pos_Callback(hObject, eventdata, handles)
%% --- Executes on button press in z_pos.
global newmark_controller;
user_input = get(handles.step,'String');
resolution = str2num(get(handles.z_res,'String'))/1000;
user_input = int2str(round(str2num(user_input)*resolution));
fprintf(newmark_controller,'%s', ['PR 0,0,' user_input ';BG;']);
disp(['PR 0,0,' user_input ';BG;'])
update_pos(hObject, eventdata, handles)

%% Button Initializations
% make sure all movement buttons are disabled initially
function x_neg_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function x_pos_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function y_neg_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function y_pos_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function z_neg_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function z_pos_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function zero_button_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')
function home_button_CreateFcn(hObject, eventdata, handles)
set(hObject,'Enable','off')

%% --- STEP text edit field ---
function step_Callback(hObject, eventdata, handles)
%% MANUAL STEP DEFINITION
% This defines the step length for manual stage control
% make sure that step input is a pos integer value
step = str2double(get(hObject,'String'));
if mod(step,1) || ~isreal(step) || step<1
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
    % Enable the move buttons if there is proper step input
    set(handles.x_neg,'Enable','on')
    set(handles.x_pos,'Enable','on')
    set(handles.y_neg,'Enable','on')
    set(handles.y_pos,'Enable','on')
    set(handles.z_neg,'Enable','on')
    set(handles.z_pos,'Enable','on')
end

function step_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function home_button_Callback(hObject, eventdata, handles)
%% HOME STAGE BUTTON
% --- Executes on button press in home_button.
home_stage(hObject, eventdata, handles)

function zero_button_Callback(hObject, eventdata, handles)
%% SET HOME BUTTON
% --- Executes on button press in zero_button.
set_home(hObject, eventdata, handles)
function current_pos_text_CreateFcn(hObject, eventdata, handles)
%%=========================================================
% ---- END STAGE MANUAL CONTROLS PANEL ----
% =========================================================


%% =========================================================
%  ---- OSCILLOSCOPE MANUAL CONTROLS PANEL ----
%  =========================================================
function connect_scope_Callback(hObject, eventdata, handles)
%% CONNECT SCOPE
% --- Executes on button press in connect_scope.
global tek_scope;
% VISA connection to the Tektronix oscilloscope
tek_addr = get(handles.scope_addr, 'String'); 
tek_scope = instrfind('Type', 'visa-usb', 'RsrcName',...
 tek_addr, 'Tag', '');
% Create the VISA-GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(tek_scope)
    tek_scope = visa('TEK', tek_addr);
else
    fclose(tek_scope);
    tek_scope = tek_scope(1);
end
% Adjust input buffer for scope
tek_scope.InputBufferSize = 1000000;
%tek_scope.Timeout = 120;
fopen(tek_scope);   % open connections
% Query instrument with *IDN?
instrumentID = query(tek_scope,'*IDN?');
if isempty(instrumentID)
    throw(MException('tek_scopeCapture:ConnectionError',...
                     'Unable to connect to instrument'));
end
disp(['Connected to: ' instrumentID]);
set(handles.disconn_scope,'Enable','on') % toggle the connect buttons
set(handles.connect_scope,'Enable','off')
set(handles.acq_button,'Enable','on')

function disconn_scope_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
set(hObject,'Enable','off')
function disconn_scope_Callback(hObject, eventdata, handles)
%% DISCONNECT SCOPE
% --- Executes on button press in disconn_scope.
global tek_scope;
fclose(tek_scope); % close connection to oscilloscope
disp('Oscilloscope Disconnected')
set(handles.disconn_scope,'Enable','off') % toggle the connect buttons
set(handles.connect_scope,'Enable','on')
set(handles.acq_button,'Enable','off')

function acq_button_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
set(hObject,'Enable','off')
function acq_button_Callback(hObject, eventdata, handles)
%% SCOPE ACQ BUTTON
% --- Executes on button press in acq_button.
% saves file with given name in the filename textbox
dname = uigetdir(matlabroot)
file_name = get(handles.filename,'String');
tek_acq_2(dname, file_name, handles)

function filename_Callback(hObject, eventdata, handles)
function filename_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% =========================================================
%  ---- END OSCILLOSCOPE MANUAL CONTROLS PANEL ----
%  =========================================================


%% =========================================================
%  ---- USER FUNCTIONS ----
% =========================================================
function update_pos(hObject,eventdata,handles)
%% UPDATE FUNCTION
% Gets current pos, and writes it back to text field object.
global newmark_controller;
% report pos when motion complete
fprintf(newmark_controller,'%s', 'MC;RP;');
out = fscanf(newmark_controller, '%*s %d,%d,%d'); % parse out non-numbers
resxy = str2num(get(handles.x_y_res,'String'))/1000;
resz = str2num(get(handles.z_res,'String'))/1000;
xpos = round(out(1)/resxy);
ypos = round(out(2)/resxy);
zpos = round(out(3)/resz); 
new_out = num2str([xpos ypos zpos]);
set(handles.current_pos_text, 'String', mat2str(new_out));
drawnow()

function tek_acq_2(dname, filename, handles)
%% OSCILLOSCOPE ACQ FUNCTION
% initiates acquisition on the oscilloscope
% input: filename as a string
% ex: tek_acq_2(zebra) will save file zebra.csv to computer
global tek_scope;
% Start single sequence acquisition
fprintf(tek_scope, 'ACQ:STOPAfter SEQ');
fprintf(tek_scope, 'ACQ:STATE ON');
% wait until acquisition is completed, acq state is 0
acqComplete = query(tek_scope,'ACQ:STATE?');
while ~isequal(str2double(acqComplete),0)
    acqComplete = query(tek_scope,'ACQ:STATE?');
end

% Turn headers off, this makes parsing easier
fprintf(tek_scope, 'HEADER OFF');
% Get record length value
recordLength = query(tek_scope, 'HOR:RECO?');
% Ensure that the start and stop values for CURVE query match the full
% record length
% NOTE: DATA:SOURCE channel NEEDS TO BE ON
scope_ch_num = get(handles.scope_ch_popup, 'Value'); % selected port
scope_ch_list = get(handles.scope_ch_popup,'String');
ch_port = scope_ch_list{scope_ch_num};
fprintf(tek_scope, ['DATA:SOURCE CH' ch_port]);
fprintf(tek_scope, 'DATA:START 1');
fprintf(tek_scope, ['DATA:STOP 100000' recordLength]);
% fprintf(tek_scope, ['DATA:SOURCE CH' ch_port...
%     ';DATA:START 1;DATA:STOP ' recordLength ';']);
% Read YOFFSET to calculate the vertical values
% data_stop = query(tek_scope, 'WFMOutpre:NR_Pt?')
% yOffset = query(tek_scope, 'WFMO:YOFF?')
% Read YMULT to calculate the vertical values
verticalScale = query(tek_scope,'WFMOUTPRE:YMULT?');
% Request 8 bit binary data on the CURVE query
fprintf(tek_scope, 'DATA:ENCDG RIBINARY;WIDTH 1');

% save all waveforms, then wait for the waveforms to be written
fprintf(tek_scope, 'CURVE?');
pause(0.25);
%readSize = tek_scope.ValuesReceived

% Read the captured data as 8-bit integer data type
% data = (str2double(verticalScale) * (binblockread(tek_scope,'int8')))'...
%         + str2double(yOffset);
data = (binblockread(tek_scope,'int8') * str2double(verticalScale));
csvwrite(fullfile(dname,[filename '.csv']), data);
flushinput(tek_scope); % flush buffer after saving
disp('File saved')

function tek_acq(filename)
%% OSCILLOSCOPE ACQ FUNCTION
% initiates acquisition on the oscilloscope
% input: filename as a string
% ex: tek_acq(zebra) will save file zebra.csv to flash drive
global tek_scope;
% Start single sequence acquisition
fprintf(tek_scope, ['ACQ:STOPAfter SEQ']);
fprintf(tek_scope, ['ACQ:STATE ON']);
% wait until acquisition is completed, acq state is 0
acqComplete = query(tek_scope,'ACQ:STATE?');
while ~isequal(str2double(acqComplete),0)
    acqComplete = query(tek_scope,'ACQ:STATE?');
end
% save all waveforms, then wait for the waveforms to be written
fprintf(tek_scope, ['SAVE:WAVEFORM ALL,"E:/' filename '.csv"']);
operationComplete = query(tek_scope,'*OPC?');
% OPC returns 1 when operations are all completed
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(tek_scope,'*OPC?');
end
disp('File saved')

% function tek_acq(filename)
% %% OSCILLOSCOPE ACQ FUNCTION
% % initiates acquisition on the oscilloscope
% % input: filename as a string
% % ex: tek_acq(zebra) will save file zebra.csv to flash drive
% global tek_scope;
% % Save the current waveform as a csv file to current working directory
% fprintf(tek_scope, ['SAVE:WAVEFORM ALL,"E:/' filename '.csv"']);
% operationComplete = query(tek_scope,'*OPC?');
% while ~isequal(str2double(operationComplete),1)
%     operationComplete = query(tek_scope,'*OPC?');
% end
% disp('File saved')

function mov_abs(x_in, y_in, z_in)
%% MOVE ABSOLUTE FUNCTION
% this function moves the stage to the designated absolute position
% note that the inputs should be whole numbers formatted as strings
global newmark_controller;
fprintf(newmark_controller, '%s', ['PA ' x_in ',' y_in ',' z_in ';BG;']);
disp(['PA ' x_in ',' y_in ',' z_in ';BG;'])

function mov_rel(x_in, y_in, z_in)
%% MOVE ABSOLUTE FUNCTION
% this function moves the stage to the designated absolute position
% note that the inputs should be whole numbers formatted as strings
global newmark_controller;
fprintf(newmark_controller, '%s', ['PR ' x_in ',' y_in ',' z_in ';BG;']);
disp(['PR ' x_in ',' y_in ',' z_in ';BG;'])

function set_home(hObject, eventdata, handles)
%% SET HOME FUNCTION
% this sets the current position as the new home (0,0,0)
global newmark_controller;
fprintf(newmark_controller,'%s', 'DP 0,0,0;');
update_pos(hObject, eventdata, handles)
disp('home set'); %debug

function home_stage(hObject, eventdata, handles)
%% HOME STAGE FUNCTION
% this moves the stage to the home position as set by set_home
global newmark_controller;
fprintf(newmark_controller,'%s', 'PA 0,0,0;BG;');
update_pos(hObject, eventdata, handles)

function check_scan_inputs(hObject, eventdata, handles)
%% CHECK SCAN INPUTS FUNCTION
% checks the inputs are numbers and updates the fields below
step = [];
step(end+1) = str2double(get(handles.x_step_len,'String'));
step(end+1) = str2double(get(handles.y_step_len,'String'));
step(end+1) = str2double(get(handles.z_step_len,'String'));
step(end+1) = str2double(get(handles.x_step_num,'String'))+1; % input 0 OK
step(end+1) = str2double(get(handles.y_step_num,'String'))+1; % input 0 OK
step(end+1) = str2double(get(handles.z_step_num,'String'))+1; % input 0 OK
% make sure that inputs are integer, real, and positive
if any(mod(step,1)) || any(~isreal(step)) || any(step<1)
    set(handles.scan_button,'Enable','off');
else
    % Enable the move buttons if there is proper value
    set(handles.scan_button, 'Enable', 'on');
    tot_meas_num = (step(4)) * (step(5)) * step(6);
    % display total number of measurements
    set(handles.tot_meas, 'String', num2str(tot_meas_num));
    x_dim = num2str(step(1) * (step(4)-1));
    y_dim = num2str(step(2) * (step(5)-1));
    z_dim = num2str(step(3) * (step(6)-1));
    % display scanning dimensions
    set(handles.scan_dim, 'String', [x_dim ',' y_dim ',' z_dim]);
end
%%=========================================================
%  ---- END USER FUNCTIONS ---
% =========================================================


%% =========================================================
%  ---- SCANNING RELATED ----
%  =========================================================
function scan_button_Callback(hObject, eventdata, handles)
% disable the start button
set(hObject,'Enable','off');
% flag that scan is running
handles.doLoop = true;
guidata(hObject,handles);
%% SCAN
% --- Executes on button press in scan_button.
% CHOOSE the directory to save in
dname = uigetdir(matlabroot)
reso_xy = str2num(get(handles.x_y_res,'String'))/1000;
reso_z = str2num(get(handles.z_res,'String'))/1000;
% PARAMETERS (Convert the lengths to units of [10um])
x_step_len = str2double(get(handles.x_step_len,'String'))*reso_xy;
y_step_len = str2double(get(handles.y_step_len,'String'))*reso_xy;
z_step_len = str2double(get(handles.z_step_len,'String'))*reso_z;
x_step_num = str2double(get(handles.x_step_num,'String'));
y_step_num = str2double(get(handles.y_step_num,'String'));
z_step_num = str2double(get(handles.z_step_num,'String'));
% INITIAL MOVE (centers the scan at start position)
set_home(hObject, eventdata, handles)
mov_abs(num2str(-1*x_step_num*x_step_len/2),num2str(-1*y_step_num*y_step_len/2),'0')
% pause(0.001);
pause(5); % need the delay for home to set
% SET START CORNER POSITION AS HOME
set_home(hObject, eventdata, handles)
set(handles.stop_button,'Enable','on');
% NESTED LOOPS for the scanning sequence
while handles.doLoop
    for i_z = 0:z_step_num
        disp(['Beginning acquisition for z=' num2str(i_z)])
        for i_y = 0:y_step_num
            disp(['Acquisition for y=' num2str(i_y)])
            for i_x = 0:x_step_num
                % should we continue?
                handles = guidata(hObject);
                if ~handles.doLoop
                    break;
                end
                disp(['Acquisition for x=' num2str(i_x) ' ,y='...
                    num2str(i_y) ' ,z=' num2str(i_z)])
                % acquire and then move to i_x*step value
                mov_abs(num2str(i_x*x_step_len),num2str(i_y*y_step_len)...
                    ,num2str(i_z*z_step_len*-1)) %to move hydrophone up
                update_pos(hObject, eventdata, handles)
                tek_acq_2(dname, ...
                    ['x' num2str(i_x) 'y' num2str(i_y) 'z' num2str(i_z)], handles)
                pause(0.001);
            end
            if ~handles.doLoop
                    break;
            end
        end
        if ~handles.doLoop
                    break;
        end
    end
break;
end
% MOVE BACK HOME
home_stage(hObject, eventdata, handles)
pause(3); % need the delay for home to set
% MOVE BACK TO BEGINNING POST
mov_abs(num2str(x_step_num*x_step_len/2),num2str(y_step_num*y_step_len/2),'0')
disp('Scanning routinue ended, moving back to start position')
set(hObject,'Enable','on');

%% --- scope_ch_popup GUIDE generated code
function scope_ch_popup_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function scope_ch_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
                    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function scan_button_CreateFcn(hObject, eventdata, handles)
%% Scan button is initially disabled
set(hObject,'Enable','off')

function stop_button_CreateFcn(hObject, eventdata, handles)
%% Stop button is initially disabled
set(hObject,'Enable','off')

function stop_button_Callback(hObject, eventdata, handles)
% --- Executes on button press in stop_button.
% flag that the scanning loop should be stopped
handles.doLoop = false;
guidata(hObject,handles);
disp('Scanning Routine Stop Issued')
set(hObject,'Enable','off')
set(handles.scan_button,'Enable','on');


function x_step_len_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function x_step_len_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_step_len_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function y_step_len_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function z_step_len_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function z_step_len_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x_step_num_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function x_step_num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_step_num_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function y_step_num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function z_step_num_Callback(hObject, eventdata, handles)
check_scan_inputs(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function z_step_num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% =========================================================
%  ---- END SCANNING RELATED ----
%  =========================================================

%% =========================================================
%  ---- PLOTTING ----
%  =========================================================

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% turn button off
% set(hObject,'Enable','off');
x_step_len = str2double(get(handles.x_step_len,'String'));
y_step_len = str2double(get(handles.y_step_len,'String'));
z_step_len = str2double(get(handles.z_step_len,'String'));
x_step_num = str2double(get(handles.x_step_num,'String'))+1;
y_step_num = str2double(get(handles.y_step_num,'String'))+1;
z_step_num = str2double(get(handles.z_step_num,'String'))+1;
% choose directory with UI
dirName = uigetdir
cd(dirName)
files = dir('x*.csv'); % wildcard only grabs scan csv files
% initial variables
numFiles = length(files);
allNames = { files.name };
str_allNames = cellstr(allNames);
allNames = sort_nat(str_allNames);
allData = [];
allPeak = [];
% loop through all the files
for i = 1:numFiles'
    file = allNames{i};
    disp(file)
    data = dlmread(file,',',1000,0);
    maxData = max(data);
    minData = min(data);
    peak = maxData - minData;
    allPeak = [allPeak peak];
    allData = [allData data];
end
% % data containers
% str_allData = num2cell(allData);
% cell_allPeak = num2cell(allPeak);
% set up data for contour plot
if x_step_num-1 == 0
    X = linspace(1,y_step_num,y_step_num);
    Y = linspace(1,z_step_num,z_step_num);
    [X,Y] = meshgrid(X,Y);
    Z = reshape(allPeak,z_step_num,y_step_num);
    % plot the results
    figure (1)
    contourf(X*y_step_len*10e-6,Y*z_step_len*10e-6,Z)
    colorbar
    title ('Contour Plot of scan ')
    ylabel('Z distance - [m]')
    xlabel('Y distance - [m]')
elseif z_step_num-1 == 0
    X = linspace(1,x_step_num,x_step_num);
    Y = linspace(1,y_step_num,y_step_num);
    [X,Y] = meshgrid(X,Y);
    Z = reshape(allPeak,y_step_num,x_step_num);
    % plot the results
    figure (1)
    contourf(X*x_step_len*10e-6,Y*y_step_len*10e-6,Z)
    colorbar
    title ('Contour Plot of scan ')
    ylabel('Y distance - [m]')
    xlabel('X distance - [m]')
else
    X = linspace(1,x_step_num,x_step_num);
    Y = linspace(1,z_step_num,z_step_num);
    [X,Y] = meshgrid(X,Y);
    Z = reshape(allPeak,z_step_num,x_step_num);
    % plot the results
    figure (1)
    contourf(X*x_step_len*10e-6,Y*z_step_len*10e-6,Z)
    colorbar
    title ('Contour Plot of scan ')
    ylabel('Z distance - [m]')
    xlabel('X distance - [m]')
end
% turn button back on
% set(hObject,'Enable','on');

function [cs,index] = sort_nat(c,mode)
%sort_nat: Natural order sort of cell array of strings.
% usage:  [S,INDEX] = sort_nat(C)
%
% where,
%    C is a cell array (vector) of strings to be sorted.
%    S is C, sorted in natural order.
%    INDEX is the sort order such that S = C(INDEX);
%
% Natural order sorting sorts strings containing digits in a way such that
% the numerical value of the digits is taken into account.  It is
% especially useful for sorting file names containing index numbers with
% different numbers of digits.  Often, people will use leading zeros to get
% the right sort order, but with this function you don't have to do that.
% For example, if C = {'file1.txt','file2.txt','file10.txt'}, a normal sort
% will give you
%
%       {'file1.txt'  'file10.txt'  'file2.txt'}
%
% whereas, sort_nat will give you
%
%       {'file1.txt'  'file2.txt'  'file10.txt'}
%
% See also: sort

% Version: 1.4, 22 January 2011
% Author:  Douglas M. Schwarz
% Email:   dmschwarz=ieee*org, dmschwarz=urgrad*rochester*edu
% Real_email = regexprep(Email,{'=','*'},{'@','.'})


% Set default value for mode if necessary.
if nargin < 2
	mode = 'ascend';
end

% Make sure mode is either 'ascend' or 'descend'.
modes = strcmpi(mode,{'ascend','descend'});
is_descend = modes(2);
if ~any(modes)
	error('sort_nat:sortDirection',...
		'sorting direction must be ''ascend'' or ''descend''.')
end

% Replace runs of digits with '0'.
c2 = regexprep(c,'\d+','0');

% Compute char version of c2 and locations of zeros.
s1 = char(c2);
z = s1 == '0';

% Extract the runs of digits and their start and end indices.
[digruns,first,last] = regexp(c,'\d+','match','start','end');

% Create matrix of numerical values of runs of digits and a matrix of the
% number of digits in each run.
num_str = length(c);
max_len = size(s1,2);
num_val = NaN(num_str,max_len);
num_dig = NaN(num_str,max_len);
for i = 1:num_str
	num_val(i,z(i,:)) = sscanf(sprintf('%s ',digruns{i}{:}),'%f');
	num_dig(i,z(i,:)) = last{i} - first{i} + 1;
end

% Find columns that have at least one non-NaN.  Make sure activecols is a
% 1-by-n vector even if n = 0.
activecols = reshape(find(~all(isnan(num_val))),1,[]);
n = length(activecols);

% Compute which columns in the composite matrix get the numbers.
numcols = activecols + (1:2:2*n);

% Compute which columns in the composite matrix get the number of digits.
ndigcols = numcols + 1;

% Compute which columns in the composite matrix get chars.
charcols = true(1,max_len + 2*n);
charcols(numcols) = false;
charcols(ndigcols) = false;

% Create and fill composite matrix, comp.
comp = zeros(num_str,max_len + 2*n);
comp(:,charcols) = double(s1);
comp(:,numcols) = num_val(:,activecols);
comp(:,ndigcols) = num_dig(:,activecols);

% Sort rows of composite matrix and use index to sort c in ascending or
% descending order, depending on mode.
[unused,index] = sortrows(comp);
if is_descend
	index = index(end:-1:1);
end
index = reshape(index,size(c));
cs = c(index);



function scope_addr_Callback(hObject, eventdata, handles)
% hObject    handle to scope_addr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scope_addr as text
%        str2double(get(hObject,'String')) returns contents of scope_addr as a double


% --- Executes during object creation, after setting all properties.
function scope_addr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scope_addr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in serial_popup2.
function serial_popup2_Callback(hObject, eventdata, handles)
% hObject    handle to serial_popup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serial_popup2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_popup2


% --- Executes during object creation, after setting all properties.
function serial_popup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_popup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
