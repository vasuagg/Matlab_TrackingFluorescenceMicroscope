function varargout = movid_viewer_v1(varargin)
% MOVID_VIEWER_V1 M-file for movid_viewer_v1.fig
%      MOVID_VIEWER_V1, by itself, creates a new MOVID_VIEWER_V1 or raises the existing
%      singleton*.
%
%      H = MOVID_VIEWER_V1 returns the handle to a new MOVID_VIEWER_V1 or the handle to
%      the existing singleton*.
%
%      MOVID_VIEWER_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVID_VIEWER_V1.M with the given input arguments.
%
%      MOVID_VIEWER_V1('Property','Value',...) creates a new MOVID_VIEWER_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before movid_viewer_v1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to movid_viewer_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help movid_viewer_v1

% Last Modified by GUIDE v2.5 25-Sep-2008 16:17:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @movid_viewer_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @movid_viewer_v1_OutputFcn, ...
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


% --- Executes just before movid_viewer_v1 is made visible.
function movid_viewer_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to movid_viewer_v1 (see VARARGIN)

% Choose default command line output for movid_viewer_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes movid_viewer_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = movid_viewer_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



[datafile,datapath]=uigetfile('*.pma','Choose a PMA file');

if datafile==0, 
    return; 
end

cd(datapath);
handles.pmafile=fopen(datafile,'r');
handles.filename=datafile;


imagesizex=fread(handles.pmafile,1,'uint16');
imagesizey=fread(handles.pmafile,1,'uint16');

s=dir(handles.filename);
NumFrames=(s.bytes-4)/(imagesizex*imagesizey*2+2);

donor_start = str2num(get(handles.edit2,'string'));
acceptor_start = str2num(get(handles.edit3,'string'));


%averagesize = 30

%fseek(handles.pmafile,4 + (donor_start-1)*(imagesizex*imagesizey*2+2),-1);
image = zeros(imagesizex, imagesizey);
for k=1:donor_start(1),
    temp  = fread(handles.pmafile,1,'uint16');
    temp1 = fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
end

for k=1:size(donor_start,2),
    temp=fread(handles.pmafile,1,'uint16');
    image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
end

low=min(min(image));
high=max(max(image));
imshow(image, [low high]);
colormap(original)

% image = image'/size(donor_start,2);
% image_t(:,imagesizex/2:imagesizey) = image(:,imagesizex/2:imagesizey);
% 
% 
% imshow(image_t);






if imagesizex==imagesizey
image_t = image'/averagesize;
elseif imagesizey==111
image_t = image'/averagesize;
else
    image_t = image/averagesize;
    image_t = image_t';
end
% note the end prime for matrix transpose; This is to show the image in
% the same orientation as what is seen in collecting data.

% fseek(handles.pmafile,4 + (acceptor_start-1)*(imagesizex*imagesizey*2+2),-1);
% image = zeros(imagesizey, imagesizex);
% for k=1:averagesize,
%     temp=fread(handles.pmafile,1,'uint16');
%     % Backwards??? it wouldnt matter if this was a square...
% %     image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
%     image = image + fread(handles.pmafile,[imagesizex,imagesizey],'uint16');
% end
% image = image'/averagesize;
% size(image)
% 










%guidata(h,handles);

%movieon=0;

%pre_calc(handles);







function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


