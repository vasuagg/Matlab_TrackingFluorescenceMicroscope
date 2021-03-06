function varargout = TraceView(varargin)
% TRACEVIEW M-file for TraceView.fig
%      TRACEVIEW, by itself, creates a new TRACEVIEW or raises the existing
%      singleton*.
%
%      H = TRACEVIEW returns the handle to a new TRACEVIEW or the handle to
%      the existing singleton*.
%
%      TRACEVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACEVIEW.M with the given input arguments.
%
%      TRACEVIEW('Property','Value',...) creates a new TRACEVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TraceView_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TraceView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help TraceView

% Last Modified by GUIDE v2.5 15-Oct-2006 14:01:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TraceView_OpeningFcn, ...
                   'gui_OutputFcn',  @TraceView_OutputFcn, ...
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


% --- Executes just before TraceView is made visible.
function TraceView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TraceView (see VARARGIN)

% Choose default command line output for TraceView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TraceView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TraceView_OutputFcn(hObject, eventdata, handles) 
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

[datafile,datapath]=uigetfile('*.traces','Choose a trace file');
if datafile==0, return; end
cd(datapath);

%x is not the x-axis of the plot but the total number of the traces in the
%file; y is the intensities for all frames for a particular
%molecule

handles.switch=1;
handles.molecule=2;

traces=load(datafile(1,:));
handles.traces=traces';
[sizex handles.sizey]=size(handles.traces)
handles.sizey=handles.sizey-3                  % remove 3 lines of header from total size


acceptor_start=0;
matched_start=0;


for i=4:sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end




if get(handles.checkbox1,'Value')==1
    mol_start=2
    mol_end=sizex
end

if get(handles.checkbox2,'Value')==1
    mol_start=2
    mol_end=acceptor_start
end

if get(handles.checkbox3,'Value')==1
    mol_start=acceptor_start
    mol_end=matched_start
end

if get(handles.checkbox4,'Value')==1
    mol_start=matched_start
    mol_end=sizex
end


if matched_start==0
    matched_start=sizex;
end


if get(handles.checkbox5,'Value')==1
    mol_start=2;
    mol_end=sizex+1;
end


set(handles.text1,'String',['#donors:',num2str((acceptor_start-2)/2),' #acceptors:',num2str(matched_start-acceptor_start),' #matched:',num2str(((sizex-1)-matched_start)/2)]);


handles.start=mol_start;
handles.stop=mol_end;
handles.molecule=handles.start;
handles.sizex=sizex;
handles.handles.sizey=handles.sizey;
handles.filename=datafile;

guidata(hObject,handles);


if get(handles.checkbox5,'Value')==1 | get(handles.checkbox3,'Value')==1 | ((handles.molecule < matched_start) & (handles.molecule >= (acceptor_start-1)))
 plotting2(guidata(gcf));
else
 plotting(guidata(gcf));
end





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end



if handles.molecule>handles.start
  if get(handles.checkbox3,'Value')==1 | ((handles.molecule <= matched_start) & (handles.molecule >= acceptor_start))
    handles.molecule=handles.molecule-1;
  else
    handles.molecule=handles.molecule-2;
  end
  
end

guidata(hObject,handles);

if get(handles.checkbox5,'Value')==1 | get(handles.checkbox3,'Value')==1 | ((handles.molecule < matched_start) & (handles.molecule >= (acceptor_start-1)))
 plotting2(guidata(gcf));
else
 plotting(guidata(gcf));
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end

if handles.molecule<=(handles.stop-2)
  if get(handles.checkbox3,'Value')==1 | ((handles.molecule < matched_start) & (handles.molecule >= (acceptor_start-1)))
    handles.molecule=handles.molecule+1;
  else
  handles.molecule=handles.molecule+2;
  end
end

guidata(hObject,handles);

if get(handles.checkbox5,'Value')==1 | get(handles.checkbox3,'Value')==1 | ((handles.molecule < matched_start) & (handles.molecule >= (acceptor_start-1)))
 plotting2(guidata(gcf));
else
 plotting(guidata(gcf));
end
 



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);
printing(guidata(gcf));


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


acceptor_start=0;
matched_start=0;



for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end

%prints all traces
if get(handles.checkbox1,'Value')==1
handles.molecule=2;  

for i=1:2:(acceptor_start-2)
 guidata(hObject,handles);
 plotting(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+2;
end

for i=acceptor_start:(matched_start-1)
 guidata(hObject,handles);
 plotting2(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+1;
end


for i=matched_start:2:(handles.sizex-2)
 guidata(hObject,handles);
 plotting(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+2;
end

end

%prints donors

if get(handles.checkbox2,'Value')==1
handles.molecule=2;
for i=1:2:(acceptor_start-2)
 guidata(hObject,handles);
 plotting(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+2;
end
end

%prints acceptors
if get(handles.checkbox3,'Value')==1
handles.molecule=acceptor_start;
    for i=acceptor_start:(matched_start-1)
 guidata(hObject,handles);
 plotting2(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+1;
  end
end

  %prints matched
if get(handles.checkbox4,'Value')==1
handles.molecule=matched_start;
    for i=matched_start:2:(handles.sizex-2)
 guidata(hObject,handles);
 plotting(guidata(gcf));
 guidata(hObject,handles);
 printing(guidata(gcf));
 handles.molecule=handles.molecule+2;
   end
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.checkbox4,'Value',0);


acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end

if get(handles.checkbox1,'Value')==1
    mol_start=2;
    mol_end=handles.sizex;
end

if get(handles.checkbox2,'Value')==1
    mol_start=2;
    mol_end=acceptor_start;
end

if get(handles.checkbox3,'Value')==1
    mol_start=acceptor_start;
    mol_end=matched_start;
end

if get(handles.checkbox4,'Value')==1
    mol_start=matched_start;
    mol_end=handles.sizex;
end

handles.start=mol_start;
handles.stop=mol_end;
handles.molecule=handles.start;

guidata(hObject,handles);

if get(handles.checkbox3,'Value')==1
plotting2(guidata(gcf));
else
plotting(guidata(gcf));
end



% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

set(handles.checkbox1,'Value',0);
set(handles.checkbox3,'Value',0);
set(handles.checkbox4,'Value',0);


acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end


if get(handles.checkbox1,'Value')==1
    mol_start=2;
    mol_end=handles.sizex;
end

if get(handles.checkbox2,'Value')==1
    mol_start=2;
    mol_end=acceptor_start;
end

if get(handles.checkbox3,'Value')==1
    mol_start=acceptor_start;
    mol_end=matched_start;
end

if get(handles.checkbox4,'Value')==1
    mol_start=matched_start;
    mol_end=handles.sizex;
end

handles.start=mol_start;
handles.stop=mol_end;
handles.molecule=handles.start;

guidata(hObject,handles);
plotting(guidata(gcf));




% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',0);
set(handles.checkbox4,'Value',0);


acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end


if get(handles.checkbox1,'Value')==1
    mol_start=2;
    mol_end=handles.sizex;
end

if get(handles.checkbox2,'Value')==1
    mol_start=2;
    mol_end=acceptor_start;
end

if get(handles.checkbox3,'Value')==1
    mol_start=acceptor_start;
    mol_end=matched_start;
end

if get(handles.checkbox4,'Value')==1
    mol_start=matched_start;
    mol_end=handles.sizex;
end

handles.start=mol_start;
handles.stop=mol_end;

handles.molecule=handles.start;

guidata(hObject,handles);
plotting2(guidata(gcf));



% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


set(handles.checkbox1,'Value',0);
set(handles.checkbox2,'Value',0);
set(handles.checkbox3,'Value',0);


acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    return;
end


if get(handles.checkbox1,'Value')==1
    mol_start=2;
    mol_end=handles.sizex;
end

if get(handles.checkbox2,'Value')==1
    mol_start=2;
    mol_end=acceptor_start;
end

if get(handles.checkbox3,'Value')==1
    mol_start=acceptor_start;
    mol_end=matched_start;
end

if get(handles.checkbox4,'Value')==1
    mol_start=matched_start;
    mol_end=handles.sizex;
end

handles.start=mol_start;
handles.stop=mol_end;

handles.molecule=handles.start;

guidata(hObject,handles);
plotting(guidata(gcf));



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    return;
end

if get(handles.checkbox3,'Value')==0
   handles.switch=handles.switch*-1;
   guidata(hObject,handles);
   
   if get(handles.checkbox3,'Value')==1 | ((handles.molecule < matched_start) & (handles.molecule >= (acceptor_start)))
   plotting2(guidata(gcf));
   else
   plotting(guidata(gcf));
   end
end
    


function plotting(hObject, eventdata, handles);
handles = guidata(gcf);

maximum1=max(handles.traces(handles.molecule,:));
if maximum1 < max(handles.traces((handles.molecule+1),:))
    maximum1 =max(handles.traces((handles.molecule+1),:));
end
minimum1=0;
maximum1=maximum1+(0.05*maximum1);

maximum2=max(handles.traces((handles.molecule+1),:));
minimum2=0;
maximum2=maximum2+(0.05*maximum2);


[AX,H1,H2]=plotyy(handles.traces(1,4:handles.sizey),handles.traces(handles.molecule,4:handles.sizey),handles.traces(1,4:handles.sizey),handles.traces(handles.molecule+1,4:handles.sizey));
set(H1,'color','g')
set(H2,'color','r')
set(AX(1),'Ycolor','g')
set(AX(2),'Ycolor','r')
xlabel('Frame Number')
ylabel(AX(2),'Intensity')
ylabel(AX(1),'Intensity')
set(AX(1),'Ytickmode','manual')
tick=round(maximum1/10);
set(AX(1),'YTick',0:tick:round(maximum1))
set(AX(2),'Ytickmode','manual')
tick=round(maximum2/5);
set(AX(2),'YTick',0:tick:round(maximum2))



if handles.switch==1
    set(AX(1),'YLim',[minimum1 maximum1]);
    set(AX(2),'YLim',[minimum1 maximum1]);
end

if handles.switch==-1
    set(AX(1),'YLim',[minimum1 maximum1]);
    set(AX(2),'YLim',[minimum2 maximum2]);
end

Title(['Molecule: ',num2str(handles.traces(handles.molecule,1)), '  Xd=',num2str(handles.traces(handles.molecule,2)), ' Yd=',num2str(handles.traces(handles.molecule,3)), '  Xa=',num2str(handles.traces((handles.molecule+1),2)), ' Ya=',num2str(handles.traces((handles.molecule+1),3))   ]);
%set(handles.text1,'String','Molecule\n', 'String',handles.traces(handles.molecule,1));





function plotting2(hObject, eventdata, handles);
handles = guidata(gcf);

maximum1=max(handles.traces(handles.molecule,:));
minimum1=min(handles.traces(handles.molecule,4:handles.sizey));
minimum1=minimum1-(0.05*minimum1)
maximum1=maximum1+(0.05*maximum1);

[AX,H1,H2]=plotyy(handles.traces(1,4:handles.sizey),handles.traces(handles.molecule,4:handles.sizey),handles.traces(1,4:handles.sizey),handles.traces(handles.molecule,4:handles.sizey));
set(H1,'color','r')
set(H2,'color','r')
set(AX(1),'Ycolor','r')
set(AX(2),'Ycolor','r')
xlabel('Frame Number')
ylabel(AX(2),'Intensity')
ylabel(AX(1),'Intensity')
set(AX(2),'YLim',[minimum1 maximum1]);
set(AX(1),'YLim',[minimum1 maximum1]);
set(AX(1),'Ytickmode','manual')
tick=round(maximum1/10);
set(AX(1),'YTick',0:tick:round(maximum1))


Title(['Molecule: ',num2str(handles.traces(handles.molecule,1)), '  Xa=',num2str(handles.traces((handles.molecule),2)), ' Ya=',num2str(handles.traces((handles.molecule),3))   ]);
%set(handles.text1,'String','Molecule\n', 'String',handles.traces(handles.molecule,1));





function printing(hObject, eventdata, handles);
handles = guidata(gcf);
acceptor_start=0;
matched_start=0;

for i=4:handles.sizex
    if handles.traces(i,1) ==1
      if acceptor_start==0
          acceptor_start=i
      elseif matched_start==0
          matched_start=i
      end
    end
end

if matched_start==0
    matched_start=handles.sizex;
end
file=strrep(handles.filename,'.traces','')

if handles.molecule<acceptor_start
 file2=[file,'_d',num2str(handles.traces(handles.molecule,1)),'.jpg']
elseif handles.molecule >= acceptor_start & handles.molecule < matched_start 
 file2=[file,'_a',num2str(handles.traces(handles.molecule,1)),'.jpg']
elseif handles.molecule >= matched_start 
 file2=[file,'_m',num2str(handles.traces(handles.molecule,1)),'.jpg']
end

print('-noui', '-djpeg', file2);














% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);
offset=0;
offset=sscanf(get(handles.edit1,'String'),'%d')
data= [(handles.traces(1,(offset+4):handles.sizey-100))' (handles.traces(handles.molecule,(offset+4):handles.sizey-100))'];
X=data(:,1)-offset;
Y=data(:,2);
maxi=max(Y)

% Initialize the coefficients of the function
X0=[200 max(Y) 0.1 ]';
 
% Set an options file for LSQNONLIN to use the
% medium-scale algorithm
options = optimset('Largescale','off');
options = optimset('MaxFunEvals',10000);
options = optimset('MaxIter',1000000);

% Calculate the new coefficients using LSQNONLIN

[x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(@fit_simp,X0,[],[],options,X,Y);
a=(jacobian'*jacobian)^-1;
redchi=resnorm/(max(X));
ErrorYo=sqrt(a(1,1)*redchi)
ErrorA=sqrt(a(2,2)*redchi)
ErrorRo=sqrt(a(3,3)*redchi)
half=log(2)/abs(x(3))
halferr=ErrorRo/abs(x(3))*half
% Plot the original and experimental data
Y_new = x(1) + x(2).*exp(-x(3).*X) ;
plot(X,Y,'+r',X,Y_new,'b')
%plot(X,(residual/(sqrt(redchi))));
%plot(X,(residual));
%B=residual/(sqrt(redchi))
%C=sum(abs(B))/(max(X))
%D=sum(residual)


file=strrep(handles.filename,'.traces','.half1')
fid = fopen(file,'a');
fprintf(fid,'%f  %f\n',half,halferr);
fclose all;





% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(gcf);
offset=0;
offset=sscanf(get(handles.edit1,'String'),'%d')
data= [(handles.traces(1,(offset+4):handles.sizey))' (handles.traces(handles.molecule,(offset+4):handles.sizey))'];

X=data(:,1)-offset;
Y=data(:,2);
maxi=max(Y)


X1=[200 max(Y)/2 0.1 200 max(Y)/2 0.1]'
options = optimset('Largescale','off');
options = optimset('MaxFunEvals',10000);
options = optimset('MaxIter',1000000);
[x,resnorm2,residual2,exitflag2,output2,lambda2,jacobian2]=lsqnonlin(@fit_simp2,X1,[],[],options,X,Y);
Y_new2 = x(1) + x(2).*exp(-x(3).*X) +x(4).*exp(-x(5).*X);
plot(X,Y,'+r',X,Y_new2,'b')

x(1)
x(2)
x(3)
x(4)
x(5)

a=(jacobian2'*jacobian2)^-1;
redchi2=resnorm2/(max(X));
ErrorYo2=sqrt(a(1,1)*redchi2)
ErrorA1=sqrt(a(2,2)*redchi2)
ErrorA2=sqrt(a(4,4)*redchi2)
ErrorR1=sqrt(a(3,3)*redchi2)
ErrorR2=sqrt(a(5,5)*redchi2)
half1=log(2)/abs(x(3))
half2=log(2)/abs(x(5))
halferr1=ErrorR1/abs(x(3))*half1
halferr2=ErrorR2/abs(x(5))*half2

file=strrep(handles.filename,'.traces','.half2')
fid = fopen(file,'a');
fprintf(fid,'%f  %f  %f  %f\n',half1,halferr1,half2,halferr2);
fclose all;


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
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(gcf);


offset=0;
offset=sscanf(get(handles.edit1,'String'),'%d')
data= [(handles.traces(1,(offset+4):handles.sizey-100))' (handles.traces(handles.molecule,(offset+4):handles.sizey-100))'];
X=data(:,1)-offset;
Y=data(:,2);
maxi=max(Y)

% Initialize the coefficients of the function
X0=[200 max(Y) 0.1 ]';
 
% Set an options file for LSQNONLIN to use the
% medium-scale algorithm
options = optimset('Largescale','off');
options = optimset('MaxFunEvals',10000);
options = optimset('MaxIter',1000000);

% Calculate the new coefficients using LSQNONLIN

[x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(@fit_simp,X0,[],[],options,X,Y);
a=(jacobian'*jacobian)^-1;
redchi=resnorm/(max(X));
ErrorYo=sqrt(a(1,1)*redchi)
ErrorA=sqrt(a(2,2)*redchi)
ErrorRo=sqrt(a(3,3)*redchi)
half=log(2)/abs(x(3))
halferr=ErrorRo/abs(x(3))*half
% Plot the original and experimental data
Y_new = x(1) + x(2).*exp(-x(3).*X) ;
%plot(X,Y,'+r',X,Y_new,'b')
%plot(X,(residual/(sqrt(redchi))));
plot(X,(residual));
%B=residual/(sqrt(redchi))
%C=sum(abs(B))/(max(X))
%D=sum(residual)


%X1=[200 max(Y)/2 0.1 max(Y)/2 0.1]'
%options = optimset('Largescale','off');
%options = optimset('MaxFunEvals',10000);
%options = optimset('MaxIter',1000000);
%[x,resnorm2,residual2,exitflag2,output2,lambda2,jacobian2]=lsqnonlin(@fit_simp2,X1,[],[],options,X,Y);
%Y_new2 = x(1) + x(2).*exp(-x(3).*X) +x(4).*exp(-x(5).*X);
%plot(X,Y,'+r',X,Y_new2,'b')

%x(1)
%x(2)
%x(3)
%x(4)
%x(5)

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles = guidata(gcf);
offset=0;
offset=sscanf(get(handles.edit1,'String'),'%d')
data= [(handles.traces(1,(offset+4):handles.sizey))' (handles.traces(handles.molecule,(offset+4):handles.sizey))'];

X=data(:,1)-offset;
Y=data(:,2);
maxi=max(Y)


X1=[200 max(Y)/2 0.1 200 max(Y)/2 0.1]'

%chi=100000000000000000000000000000000000000000000000;
%for i=1:100
%X1=[rand(1)*max(Y) rand(1)*max(Y) 1/(rand(1)*max(X)) rand(1)*max(Y) 1/(rand(1)*max(X))]';
options = optimset('Largescale','off');
options = optimset('MaxFunEvals',100000);
options = optimset('MaxIter',1000000);
[x,resnorm2,residual2,exitflag2,output2,lambda2,jacobian2]=lsqnonlin(@fit_simp2,X1,[],[],options,X,Y);
%if resnorm2<chi
% fx=x;
% fresnorm2=resnorm2;
 %fresidual2=residual2;
 %fexitflag2=exitflag2;
 %foutput2=output2;
 %flambda2=lambda2;
 %fjacobian2=jacobian2;
%end
%end

resnorm2=fresnorm2;
residual2=fresidual2;
exitflag2=fexitflag2;
output2=foutput2;
lambda2=flambda2;
jacobian2=fjacobian2;


Y_new2 = x(1) + x(2).*exp(-x(3).*X) +x(4).*exp(-x(5).*X);
plot(X,(residual2));
%plot(X,Y,'+r',X,Y_new2,'b')

x(1)
x(2)
x(3)
x(4)
x(5)

half1=log(2)/abs(x(3))
half2=log(2)/abs(x(5))



function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

set(handles.checkbox1,'Value',0);



