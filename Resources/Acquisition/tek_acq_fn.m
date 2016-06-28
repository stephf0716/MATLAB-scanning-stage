function acquire = tek_acq_fn(filename)

% Find a VISA-USB object.
tek_scope = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x03A6::C013973::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(tek_scope)
    tek_scope = visa('TEK', 'USB0::0x0699::0x03A6::C013973::0::INSTR');
else
    fclose(tek_scope);
    tek_scope = tek_scope(1)
end

% Connect to instrument object, tek_scope.
fopen(tek_scope);

%% Query instrument with *IDN?
instrumentID = query(tek_scope,'*IDN?');
if isempty(instrumentID)
    throw(MException('tek_scopeCapture:ConnectionError','Unable to connect to instrument'));
end
disp(['Connected to: ' instrumentID]);

%% Display current working directory.
fprintf(tek_scope, ':FILESYSTEM:CWD "A:\"');
qresult = query(tek_scope, ':FILESYSTEM:CWD?');
disp(['Current Working Directory: ' qresult]);

% % Save the current oscilloscope setup to current working directory
% fprintf(tek_scope, 'SAVE:SETUP "A:\SETUP-SAV\TEK.SET"');

% Save the current waveform as a csv file to current working directory
% Only one ch for the TDS20xx Series
fprintf(tek_scope, ['SAVE:WAVEFORM CH1,"' filename '.csv"']);
disp(['SAVE:WAVEFORM CH1,"' filename '.csv"'])
disp('File saved')

fclose(tek_scope);

end
