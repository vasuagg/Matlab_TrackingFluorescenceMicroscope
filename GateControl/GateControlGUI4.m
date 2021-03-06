function varargout = GateControlGUI3(varargin)
% GATECONTROLGUI M-file for GateControlGUI.fig
%      GATECONTROLGUI, by itself, creates a new GATECONTROLGUI or raises the existing
%      singleton*.
%
%      H = GATECONTROLGUI returns the handle to a new GATECONTROLGUI or the handle to
%      the existing singleton*.
%
%      GATECONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GATECONTROLGUI.M with the given input arguments.
%
%      GATECONTROLGUI('Property','Value',...) creates a new GATECONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GateControlGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GateControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GateControlGUI

% Last Modified by GUIDE v2.5 02-Oct-2008 10:51:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GateControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GateControlGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before GateControlGUI is made visible.
function GateControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GateControlGUI (see VARARGIN)

% Choose default command line output for GateControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(hObject, 'WindowStyle', 'docked');

global LineState;
global IntState;
global LinkIntegrators;

initParameters();

LineState = [0 0 0 0];
IntState = 1;
LinkIntegrators = 0;
APDGate(LineState);
fprintf('Initializing timer boards.\n');
gt65x_init(0);
gt65x_init(1);
fprintf('\tDone\n');
% UIWAIT makes GateControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = GateControlGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
global LineState;
global LinkIntegrators;
global IntState;
toggleState = get(hObject, 'Value');
if toggleState,
    LineState(1) = 1;
    fprintf('Gate 0 opened\n');
else
    LineState(1) = 0;
    fprintf('Gate 0 closed\n');
end;
if sum(LineState) & LinkIntegrators,
    IntState = 0;
end;

if ~sum(LineState) & LinkIntegrators,
    IntState = 1;
end;

APDGate(LineState);


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
global LineState;
global LinkIntegrators;
global IntState;
toggleState = get(hObject, 'Value');
if toggleState,
    LineState(2) = 1;
    fprintf('Gate 1 opened\n');
else
    LineState(2) = 0;
    fprintf('Gate 1 closed\n');
end;
if sum(LineState) & LinkIntegrators,
    IntState = 0;
end;

if ~sum(LineState) & LinkIntegrators,
    IntState = 1;
end;
APDGate(LineState);


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
global LineState;
global LinkIntegrators;
global IntState;
toggleState = get(hObject, 'Value');
if toggleState,
    LineState(3) = 1;
    fprintf('Gate 2 opened\n');
else
    LineState(3) = 0;
    fprintf('Gate 2 closed\n');
end;
if sum(LineState) & LinkIntegrators,
    IntState = 0;
end;

if ~sum(LineState) & LinkIntegrators,
    IntState = 1;
end;
APDGate(LineState);


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
global LineState;
global LinkIntegrators;
global IntState;
toggleState = get(hObject, 'Value');
if toggleState,
    LineState(4) = 1;
    fprintf('Gate 3 opened\n');
else
    LineState(4) = 0;
    fprintf('Gate 3 closed\n');
end;
if sum(LineState) & LinkIntegrators,
    IntState = 0;
end;

if ~sum(LineState) & LinkIntegrators,
    IntState = 1;
end;
APDGate(LineState);


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
global LineState;
global LinkIntegrators;
global IntState;
toggleState = get(hObject, 'Value');
if toggleState
    LinkIntegrators = 1;
    if find(LineState),
        IntState = 0;
    end;
    set(hObject, 'String', 'Enabled ');
    APDGate(LineState);
else 
    LinkIntegrators = 0;
    IntState = 1;
    set(hObject, 'String', 'Disabled');
    APDGate(LineState);
end






% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
    display('xyz \n');
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(1:3)=toggleState;




% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(4)=toggleState;


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(5)=toggleState;



% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(6)=toggleState;



% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(7)=toggleState;



% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
    global ACQ_PARAMS;
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22
toggleState = get(hObject, 'Value');
ACQ_PARAMS.daqChannels(8)=toggleState;




function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
s=get(hObject,'String');
setParameters('v1desc',s);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',SAMPLE_DESC.v1desc);



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
s=get(hObject,'String');
setParameters('v2desc',s);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',SAMPLE_DESC.v2desc);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
s=get(hObject,'String');
setParameters('v3desc',s);

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',SAMPLE_DESC.v3desc);



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double
s=get(hObject,'String');
setParameters('v1',str2double(s));

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SAMPLE_DESC.v1));



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double
s=get(hObject,'String');
setParameters('v2',str2double(s));

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SAMPLE_DESC.v2));


function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
s=get(hObject,'String');
setParameters('v3',str2double(s));

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SAMPLE_DESC.v3));




function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
s=get(hObject,'String');
setParameters('desc',s);


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function checkbox17_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(1));


% --- Executes during object creation, after setting all properties.
function checkbox18_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(4));

% --- Executes during object creation, after setting all properties.
function checkbox19_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(5));

% --- Executes during object creation, after setting all properties.
function checkbox20_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(6));

% --- Executes during object creation, after setting all properties.
function checkbox21_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(7));

% --- Executes during object creation, after setting all properties.
function checkbox22_CreateFcn(hObject, eventdata, handles)
global ACQ_PARAMS;
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',ACQ_PARAMS.daqChannels(8));




function edit17_Callback(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
cval=get(hObject,'String');
SAMPLE_DESC.od=str2num(cval);

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
global SAMPLE_DESC;
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',num2str(SAMPLE_DESC.od));


