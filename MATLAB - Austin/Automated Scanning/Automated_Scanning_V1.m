function varargout = Automated_Scanning_V1(varargin)
% AUTOMATED_SCANNING_V1 MATLAB code for Automated_Scanning_V1.fig
%      AUTOMATED_SCANNING_V1, by itself, creates a new AUTOMATED_SCANNING_V1 or raises the existing
%      singleton*.
%
%      H = AUTOMATED_SCANNING_V1 returns the handle to a new AUTOMATED_SCANNING_V1 or the handle to
%      the existing singleton*.
%
%      AUTOMATED_SCANNING_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMATED_SCANNING_V1.M with the given input arguments.
%
%      AUTOMATED_SCANNING_V1('Property','Value',...) creates a new AUTOMATED_SCANNING_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Automated_Scanning_V1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Automated_Scanning_V1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Automated_Scanning_V1

% Last Modified by GUIDE v2.5 16-Aug-2016 15:37:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Automated_Scanning_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @Automated_Scanning_V1_OutputFcn, ...
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


% --- Executes just before Automated_Scanning_V1 is made visible.
function Automated_Scanning_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Automated_Scanning_V1 (see VARARGIN)

% Choose default command line output for Automated_Scanning_V1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Automated_Scanning_V1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Automated_Scanning_V1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Oscilloscope Control Panel

function input_file_name_Callback(hObject, eventdata, handles)
% hObject    handle to input_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_file_name as text
%        str2double(get(hObject,'String')) returns contents of input_file_name as a double
% Obtain handles for filename inputed in edit text
handles.input_filename = (get(hObject,'String'));
% Update handles function
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function input_file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_waveform.
function save_waveform_Callback(hObject, eventdata, handles)
% hObject    handle to save_waveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Interface configuration and instrument connection

% Instrument control and data retreival
% Now control the instrument using SCPI commands. refer to the instrument
% programming manual for your instrument for the correct SCPI commands for
% your instrument.
visaObj = visa('agilent','USB0::0x2A8D::0x1768::MY55280409::0::INSTR');
% Set the buffer size
visaObj.InputBufferSize = 100000;
% Set the timeout value
visaObj.Timeout = 10;
% Set the Byte order
visaObj.ByteOrder = 'littleEndian';
% Close Connection if already open
fclose(visaObj);
% Open the connection
fopen(visaObj);
% Reset the instrument and stop 
fprintf(visaObj,':STOP');
% Specify data from Channel 1
fprintf(visaObj,':WAVEFORM:SOURCE CHAN1'); 
% Set timebase to main
fprintf(visaObj,':TIMEBASE:MODE MAIN');
% Set up acquisition type and count. 
fprintf(visaObj,':ACQUIRE:TYPE NORMAL');
fprintf(visaObj,':ACQUIRE:COUNT 1');
% Specify 5000 points at a time by :WAV:DATA? <-- What's this? 
fprintf(visaObj,':WAV:POINTS:MODE RAW');
fprintf(visaObj,':WAV:POINTS 1000');
% Now tell the instrument to digitize channel1
fprintf(visaObj,':DIGITIZE CHAN1');
% Wait till complete
operationComplete = str2double(query(visaObj,'*OPC?'));
while ~operationComplete
    operationComplete = str2double(query(visaObj,'*OPC?'));
end
% Get the data back as a WORD (i.e., INT16), other options are ASCII and BYTE
fprintf(visaObj,':WAVEFORM:FORMAT WORD');
% Set the byte order on the instrument as well
fprintf(visaObj,':WAVEFORM:BYTEORDER LSBFirst');
% Get the preamble block
preambleBlock = query(visaObj,':WAVEFORM:PREAMBLE?');
% The preamble block contains all of the current WAVEFORM settings.  
% It is returned in the form <preamble_block><NL> where <preamble_block> is:
%    FORMAT        : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
%    TYPE          : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE
%    POINTS        : int32 - number of data points transferred.
%    COUNT         : int32 - 1 and is always 1.
%    XINCREMENT    : float64 - time difference between data points.
%    XORIGIN       : float64 - always the first data point in memory.
%    XREFERENCE    : int32 - specifies the data point associated with
%                            x-origin.
%    YINCREMENT    : float32 - voltage diff between data points.
%    YORIGIN       : float32 - value is the voltage at center screen.
%    YREFERENCE    : int32 - specifies the data point where y-origin
%                            occurs.
% Now send commmand to read data
fprintf(visaObj,':WAV:DATA?');
% read back the BINBLOCK with the data in specified format and store it in
% the waveform structure. FREAD removes the extra terminator in the buffer
waveform.RawData = binblockread(visaObj,'uint16'); fread(visaObj,1);
% Read back the error queue on the instrument
instrumentError = query(visaObj,':SYSTEM:ERR?');
while ~isequal(instrumentError,['+0,"No error"' char(10)])
    disp(['Instrument Error: ' instrumentError]);
    instrumentError = query(visaObj,':SYSTEM:ERR?');
end
% Close the VISA connection.
fclose(visaObj);


% Data processing: Post process the data retreived from the scope
% Extract the X, Y data and plot it 

% Maximum value storable in a INT16
maxVal = 2^16; 

%  split the preambleBlock into individual pieces of info
preambleBlock = regexp(preambleBlock,',','split');

% store all this information into a waveform structure for later use
% <-- what's this below block of code for? 
waveform.Format = str2double(preambleBlock{1});     % This should be 1, since we're specifying INT16 output
waveform.Type = str2double(preambleBlock{2});
waveform.Points = str2double(preambleBlock{3});
waveform.Count = str2double(preambleBlock{4});      % This is always 1
waveform.XIncrement = str2double(preambleBlock{5}); % in seconds
waveform.XOrigin = str2double(preambleBlock{6});    % in seconds
waveform.XReference = str2double(preambleBlock{7});
waveform.YIncrement = str2double(preambleBlock{8}); % V
waveform.YOrigin = str2double(preambleBlock{9});
waveform.YReference = str2double(preambleBlock{10});
waveform.VoltsPerDiv = (maxVal * waveform.YIncrement / 8);      % V
waveform.Offset = ((maxVal/2 - waveform.YReference) * waveform.YIncrement + waveform.YOrigin);         % V
waveform.SecPerDiv = waveform.Points * waveform.XIncrement/10 ; % seconds
waveform.Delay = ((waveform.Points/2 - waveform.XReference) * waveform.XIncrement + waveform.XOrigin); % seconds

% Generate X & Y Data
waveform.XData = (waveform.XIncrement.*(1:length(waveform.RawData))) - waveform.XIncrement;
waveform.YData = (waveform.YIncrement.*(waveform.RawData - waveform.YReference)) + waveform.YOrigin; 

% Export data to new Excel File
waveform.XData = waveform.XData.'; % Fix waveform.XData to match waveform.YData
filename = handles.input_filename;
xlswrite(filename, waveform.XData, 'B3:B1003'); % Export time data to excel file
xlswrite(filename, waveform.YData, 'C3:C1003'); % Export voltage data to excel file

% Close Connection
fclose(visaObj);

% Delete objects and clear them.
delete(visaObj); clear visaObj;

%% Prior Control Panel

% --- Executes on button press in z_pos_prior.
function z_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,0,%d\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in z_neg_prior.
function z_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,0,-%d\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in y_pos_prior.
function y_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to y_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,-%d,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in y_neg_prior.
function y_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to y_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,0,%d,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in x_pos_prior.
function x_pos_prior_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,%d,0,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2) 

% --- Executes on button press in x_neg_prior.
function x_neg_prior_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller;
str1 = sprintf('RES,s,1.0\r\n'); %Sets units of movement to microns
fwrite(prior_controller, str1); %Write to prior
user_input = get(handles.input_distance_prior,'String'); %Obtain input_distance
user_input = round(str2double(user_input));
str2 = sprintf('GR,-%d,0,0\r\n',user_input); %GR - Go Relative - move function for prior
fwrite(prior_controller, str2);  
disp(str2)

% --- Executes on button press in connect_to_prior.
function connect_to_prior_Callback(hObject, eventdata, handles)
% hObject    handle to connect_to_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller
com_port = 'COM1';
prior_controller = serial(com_port, 'BaudRate',9600);
if isvalid(prior_controller)
    fclose(prior_controller)
    fopen(prior_controller);
    display('Prior Controller Connected')
    set(handles.disconnect_from_prior, 'Enable','on')
    set(handles.connect_to_prior,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% --- Executes on button press in disconnect_from_prior.
function disconnect_from_prior_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect_from_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prior_controller; 
fclose(prior_controller);
display('Prior Controller Disconnected');
set (handles.disconnect_from_prior,'Enable','off')
set(handles.connect_to_prior,'Enable','on')


function input_distance_prior_Callback(hObject, eventdata, handles)
% hObject    handle to input_distance_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_distance_prior as text
%        str2double(get(hObject,'String')) returns contents of input_distance_prior as a double
input_distance = str2double(get(hObject,'String'));
if isnan(input_distance) || ~isreal(input_distance) %If input is a real number - enable Z+,Z-,X+,X- buttons
    set(handles.z_pos_prior,'Enable','off')
    set(handles.z_neg_prior,'Enable','off')
    set(handles.y_neg_prior,'Enable','off')
    set(handles.y_pos_prior,'Enable','off')
    set(handles.x_pos_prior,'Enable','off')
    set(handles.x_neg_prior,'Enable','off')
    uicontrol(hObject)
else
    set(handles.z_pos_prior,'Enable','on')  %If input is not a real number - disable Z+,Z-,X+,X- buttons
    set(handles.z_neg_prior,'Enable','on')
    set(handles.y_neg_prior,'Enable','on')
    set(handles.y_pos_prior,'Enable','on')    
    set(handles.x_pos_prior,'Enable','on')
    set(handles.x_neg_prior,'Enable','on')
end

% --- Executes during object creation, after setting all properties.
function input_distance_prior_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_distance_prior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Newmark Control Panel

% --- Executes on button press in z_pos_newmark.
function z_pos_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to z_pos_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller
fprintf(newmark_controller, 'AY;UF;');  % Eliminates the current units already assigned to the Newmark
fprintf(newmark_controller, 'AY;UU25;');    % Sets units to mm
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input))); 
fprintf(newmark_controller, ['AY;MR-' user_input ';GO;']); 
disp(['AX;MR' user_input])

% --- Executes on button press in z_neg_newmark.
function z_neg_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to z_neg_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
fprintf(newmark_controller, 'AY;UF;'); % Eliminates the current units already assigned to the Newmark
fprintf(newmark_controller, 'AY;UU25;');    % Sets units to mm
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AY;MR' user_input ';GO;']);
disp(['AX;MR-' user_input])

% --- Executes on button press in x_pos_newmark.
function x_pos_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to x_pos_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
fprintf(newmark_controller, 'AX;UF;');  % Eliminates the current units already assigned to the Newmark
fprintf(newmark_controller, 'AX;UU25;');    %Sets units to mm
user_input = get(handles.input_distance,'String'); 
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AX;MR' user_input ';GO;']);
disp(['AX;MR' user_input])

% --- Executes on button press in x_neg_newmark.
function x_neg_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to x_neg_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller;
fprintf(newmark_controller, 'AX;UF;');  % Eliminates the current units already assigned to the Newmark
fprintf(newmark_controller, 'AX;UU25;');    % Sets units to mm
user_input = get(handles.input_distance,'String');
user_input = int2str(round(str2double(user_input)));
fprintf(newmark_controller, ['AX;MR-' user_input ';GO;']);
disp(['AX;MR-' user_input])

% --- Executes on button press in connect_to_newmark.
function connect_to_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to connect_to_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller
com_port = 'COM6';
newmark_controller = serial(com_port, 'BaudRate',9600);
if isvalid(newmark_controller)
    fclose(newmark_controller)
    fopen(newmark_controller);
    display('Newmark Controller Connected')
    set(handles.disconnect_from_newmark, 'Enable','on')
    set(handles.connect_to_newmark,'Enable','off')
else
    warndlg('Serial port is not valid')
end

% --- Executes on button press in disconnect_from_newmark.
function disconnect_from_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to disconnect_from_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newmark_controller; 
fclose(newmark_controller);
display('Newmark Controller Disconnected');
set (handles.disconnect_from_newmark,'Enable','off')
set(handles.connect_to_newmark,'Enable','on')


function input_distance_newmark_Callback(hObject, eventdata, handles)
% hObject    handle to input_distance_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_distance_newmark as text
%        str2double(get(hObject,'String')) returns contents of input_distance_newmark as a double
input_distance = str2double(get(hObject,'String'));
if isnan(input_distance) || ~isreal(input_distance) %If input is a real number - enable Z+,Z-,X+,X- buttons
    set(handles.z_pos_new,'Enable','off')
    set(handles.z_neg_new,'Enable','off')
    set(handles.x_pos_new,'Enable','off')
    set(handles.x_neg_new,'Enable','off')
    uicontrol(hObject)
else
    set(handles.z_pos_new,'Enable','on')    %If input is not a real number - disable Z+,Z-,X+,X- buttons
    set(handles.z_neg_new,'Enable','on')
    set(handles.x_pos_new,'Enable','on')
    set(handles.x_neg_new,'Enable','on')
end

% --- Executes during object creation, after setting all properties.
function input_distance_newmark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_distance_newmark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
