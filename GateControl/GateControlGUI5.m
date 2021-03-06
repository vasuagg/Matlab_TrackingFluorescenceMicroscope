function varargout = GateControlGUI5(varargin)

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



% Last Modified by GUIDE V2.5 06-Oct-2008 17:20:47



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

global AQ_MODE;

% This function has no output args, see OutputFcn.

% hObject    handle to figure

% eventdata  reserved - to be defined in a future version of MATLAB

% handles    structure with handles and user data (see GUIDATA)

% varargin   command line arguments to GateControlGUI (see VARARGIN)



% Choose default command line output for GateControlGUI

if not(AQ_MODE)

    error('Setup is not ready, you must initialize it first with command initSetup');

end

handles.output = hObject;



% Update handles structure

guidata(hObject, handles);



set(hObject, 'WindowStyle', 'docked');





% UIWAIT makes GateControlGUI wait for user response (see UIRESUME)

% uiwait(handles.gui3);







% --- Outputs from this function are returned to the command line.

function varargout = GateControlGUI_OutputFcn(hObject, eventdata, handles)

% varargout  cell array for returning output args (see VARARGOUT);

% hObject    handle to figure

% eventdata  reserved - to be defined in a future version of MATLAB

% handles    structure with handles and user data (see GUIDATA)



% Get default command line output from handles structure

varargout{1} = handles.output;



set(0,'ShowHiddenHandles','on');

%initParameters();



updateGateControlGUI3;

set(0, 'ShowHiddenHandles', 'off');





% --- Executes on button press in gate4.

function gate1_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(1) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(1))

    display('Gate 1 open');

else display('Gate 1 closed')

end





% --- Executes on button press in gate4.

function gate2_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(2) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(2))

    display('Gate 2 open');

else display('Gate 2 closed')

end





% --- Executes on button press in gate4.

function gate3_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(3) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(3))

    display('Gate 3 open');

else display('Gate 3 closed')

end



function gate4_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(4) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(4))

    display('Gate 4 open');

else display('Gate 4 closed')

end





% --- Executes on button press in gate5.

function gate5_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(5) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(5))

    display('Gate 5 open');

else display('Gate 5 closed')

end





% --- Executes on button press in gate6.

function gate6_Callback(hObject, eventdata, handles)

global LineState;

global DAQ_PARAMS;

LineState(6) = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if(LineState(6))

    display('Gate 6 open');

else display('Gate 6 closed')

end





% --- Executes on button press in Integrate.

function Integrate_Callback(hObject, eventdata, handles)

global DAQ_PARAMS;

global LineState;





DAQ_PARAMS.Integrate = get(hObject, 'Value');

APDGate5(LineState,DAQ_PARAMS.Integrate);

if DAQ_PARAMS.Integrate

    disp('Gates are now connected to integrators. Have fun tracking!!')

    set(hObject,'String','Enabled')

else

    set(hObject,'String','Disabled');

    disp('Gates and Integrators are now disconnected.')

end





% --- Executes on button press in DaqXYZ.

function DaqXYZ_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(1:3)=toggleState;









% --- Executes on button press in Daq3.

function Daq3_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(4)=toggleState;





% --- Executes on button press in Daq4.

function Daq4_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(5)=toggleState;







% --- Executes on button press in Daq5.

function Daq5_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(6)=toggleState;







% --- Executes on button press in Daq6.

function Daq6_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(7)=toggleState;







% --- Executes on button press in Daq7.

function Daq7_Callback(hObject, eventdata, handles)

    global DAQ_PARAMS;

toggleState = get(hObject, 'Value');

DAQ_PARAMS.DaqChannels(8)=toggleState;





% --- Executes during object creation, after setting all properties.

function DaqXYZ_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(1));





% --- Executes during object creation, after setting all properties.

function Daq3_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(4));



% --- Executes during object creation, after setting all properties.

function Daq4_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(5));



% --- Executes during object creation, after setting all properties.

function Daq5_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(6));



% --- Executes during object creation, after setting all properties.

function Daq6_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(7));



% --- Executes during object creation, after setting all properties.

function Daq7_CreateFcn(hObject, eventdata, handles)

% global DAQ_PARAMS;

% set(hObject,'Value',DAQ_PARAMS.DaqChannels(8));





% --- Executes on button press in apd1.

function apd1_Callback(hObject, eventdata, handles)

global APDS;

toggleState = get(hObject, 'Value');

APDS(1)=toggleState;





% --- Executes on button press in apd2.

function apd2_Callback(hObject, eventdata, handles)

global APDS;

toggleState = get(hObject, 'Value');

APDS(2)=toggleState;



% --- Executes on button press in apd3.

function apd3_Callback(hObject, eventdata, handles)

global APDS;

toggleState = get(hObject, 'Value');

APDS(3)=toggleState;





% --- Executes on button press in apd4.

function apd4_Callback(hObject, eventdata, handles)

global APDS;

toggleState = get(hObject, 'Value');

APDS(4)=toggleState;





