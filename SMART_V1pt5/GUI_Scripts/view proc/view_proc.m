function varargout = view_proc(varargin)
% VIEW_PROC M-file for view_proc.fig
%      VIEW_PROC, by itself, creates a new VIEW_PROC or raises the existing
%      singleton*.
%
%      H = VIEW_PROC returns the handle to a new VIEW_PROC or the handle to
%      the existing singleton*.
%
%      VIEW_PROC('CALLBACK',hObject,eventData,handles,...) calls the
%      local
%      function named CALLBACK in VIEW_PROC.M with the given input
%      arguments.
%
%      VIEW_PROC('Property','Value',...) creates a new VIEW_PROC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_proc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to view_proc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_proc

% Last Modified by GUIDE v2.5 12-May-2011 20:28:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_proc_OpeningFcn, ...
                   'gui_OutputFcn',  @view_proc_OutputFcn, ...
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
 

% --- Executes just before view_proc is made visible.
function view_proc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_proc (see VARARGIN)

% Choose default command line output for view_proc


handles.output = hObject;

set(handles.figure1,'CloseRequestFcn','closereq')
%set(handles.figure1,'WindowButtonDownFcn','')


% Tharee 4 looks of this gui
handles.view_look = 'blank';
view_proc_look(handles);

handles.zoom_state = 'off';


%set(handles.figure1,'HitTest', 'off')

guidata(hObject, handles);

% UIWAIT makes view_proc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = view_proc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)









% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Update the postion the molecule


new_position = round(get(handles.slider1,'Value'));

handles.view_data = handles.selected_data(new_position,:);

if new_position > size(handles.to_plot,1)
    new_position = size(handles.to_plot,1);
end

handles.index = new_position;


update_proc_look(handles);
active_plot(handles);


guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

val = get(hObject,'value');


    
guidata(hObject, handles);





% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(handles.popupmenu1,'Value');


switch val
    case 2  % View Data Sort Window

    if isfield(handles, 'selected_data') == true    
    
    handles = rmfield(handles,'selected_data');
    
    view_proc_look(handles); 
    
    end
    
    
    case 5
        
       output = generate_clusters(handles);
       cluster_output = output;
       save('cluster_output','cluster_output')
       handles.clustFitOutputs = output;
       
       plot_clusters(handles)
         
end   


guidata(hObject, handles);
        
        

% --- Executes on selection change in popupmenu1.
function output = popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu1




val = get(handles.popupmenu1,'Value');

if val == 4
    val = 3;
end



switch val
    
    
    case 1
        
            handles.view_look = 'blank';
            view_proc_look(handles);
        
    
    case 2  % View Data Sort Window
        
 
            handles.view_look = 'sort';
            view_proc_look(handles);
     
        
    case 3  % View All Data
        

            
            sort_spec.uitable1 = get(handles.uitable1);
            sort_spec.uitable2 = get(handles.uitable2);
            sort_spec.uitable3 = get(handles.uitable3);
            handles.sort_spec = sort_spec;
            
            % this gets reset if not comming from sort.
            if islogical(handles.sort_spec.uitable1.Data{1,1})==true
            selected_data = sort_sm_molecules(handles);
            handles.selected_data = selected_data; % Update Sorted Data
            end
           
            
            
             %selected_data = handles.selected_data;
            % selected_data = sort_sm_molecules(handles);
            %end 
             
            if isempty(handles.selected_data) == true;
             handles.selected_data = handles.proc_data; 
             %selected_data = handles.selected_data;
             selected_data = sort_sm_molecules(handles);
            end
            
            
            
            selected_data = handles.selected_data;
        %    size(selected_data)
            disp(['Number of Molecule Selected = ',num2str(size(handles.selected_data,1))])

            
            
            handles.index = 1;
            handles.view_data = selected_data(handles.index,:); % Update the Current Molecule
            

                     
            handles.view_look = 'blank';
            view_proc_look(handles);
            
            %output = active_view_proc(handles);
            output = generate_smart_table(handles,1);
            
            handles.cont_or_discA = 'disc';
            if get(handles.checkbox3,'Value') == true
                handles.cont_or_discA = 'cont';
            end 
            
            
            
            handles.to_plot = output{1};
            handles.plot_types = output{2};
            
            handles.view_look = 'data';
            view_proc_look(handles)
            
            update_proc_look(handles);    

    case 5
                 

            handles.view_look = 'blank';
            view_proc_look(handles);
        
            handles.view_look = 'cluster';
            view_proc_look(handles);
            %handles.selected_data{3,7}.covmats{1}.varnames{1} = 'adsfds';
            
            get_cluster_info(handles);


                      
end


guidata(hObject, handles);
%output = handles;





% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes when user attempts to close figure1.
% function figure1_CloseRequestFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: delete(hObject) closes the figure
% delete(hObject);






% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

%if get(handles.checkbox1,'Value') == 0




output = updatae_select_molecules(handles);
handles.selected_data = output{1};


handles.selected = output{2};

view_proc_look(handles);

guidata(hObject, handles);

%updatae_select_molecules(handles);








%end


% --- Executes when entered data in editable cell(s) in uitable3.
function uitable3_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


%if get(handles.checkbox1,'Value') == 0



output = updatae_select_molecules(handles);

handles.selected_data = output{1};


handles.selected = output{2};

view_proc_look(handles);

guidata(hObject, handles);

updatae_select_molecules(handles);




%end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2




if strcmp(handles.view_look,'bic')
    
     update_model_select_look(handles);
    
elseif strcmp(handles.view_look,'cluster')
    
    plot_clusters(handles)
    
else

    
active_plot(handles);

end



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3



if strcmp(handles.view_look,'cluster')
  
    
    
else

    
active_plot(handles);

end







% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
 function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% 
% 



temp = get(handles.figure1,'CurrentAxes');

if temp == handles.axes1;


if get(handles.popupmenu1,'Value') == 3 || get(handles.popupmenu1,'Value') == 4

val(1) = get(handles.popupmenu2,'Value');
val(2) = get(handles.popupmenu3,'Value');


if  val(2) ~=1 


new_molecule = find_new_point(handles); 



%if isempty(new_molecule) == false

handles.view_data = handles.selected_data(new_molecule,:);
handles.index = new_molecule ;

% skip update if no moleucle is found.

if isempty(new_molecule)==false


update_proc_look(handles)
active_plot(handles)


set(handles.slider1,'Value',new_molecule)

guidata(hObject, handles);
end


end
end
end






% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% modifed to allow multiple filed to be loaded...mainly for bic/logPx plots
tdata = {};
tdata_name = {};

reply = 'Yes';
while strcmpi(reply, 'Yes')
    
[load_name load_path] = uigetfile({'*.proc*','Choose a (.proc) file'});
% get rid of an error
if isstr(load_path) ==true
    cd(load_path);
    load(load_name,'-mat')
    
end   

tdata_name = cat(2,tdata_name,{load_name});
tdata = cat(2,tdata,{proc_data});


reply = questdlg('Do you want to load more files?', ...
        'More Files?','Yes','No','No');

end


reply = questdlg('Do you want to do model selection with the loade files?', ...
        'Model Selection','Yes','No','No');




if strcmp(reply,'No')
    
    
    proc_data = {};
    for i=1:size(tdata,2)
            
    proc_data = cat(1, proc_data,tdata{i});
    
    end
    
    handles.proc_data = proc_data;
    
    % now can have multiple load...so 
    handles.proc_name = tdata_name; 
    handles.view_look = 'sort';
    handles.round = {100 '%.2f'};
       
    output = generate_smart_table(handles,2);
    handles.proc_data = output{4};
   
    handles.sort_matrix = round(handles.round{1}*output{1})/handles.round{1};
    
    handles.sort_names = output{2};
    handles.selected = output{3};
    
        
  
    view_proc_look(handles);


    output = updatae_select_molecules(handles);
    
    handles.selected_data = output{1};
    %handles.sorted_data = output{2};
        
    handles.sort_selected = output{2};
    
    
    view_proc_look(handles);
    
    guidata(hObject, handles);
  
    
elseif strcmp(reply,'Yes')
    
    output = import_bic_logpx( tdata );
    handles.BIC = output.bic;
    handles.logPx = output.logpx;
    handles.tlength = output.length;
    
    handles.proc_name = tdata_name;
    
    % Probably do not need to save the data in this form...but
    handles.proc_data = tdata;

    
    handles.view_look = 'blank';
    view_proc_look(handles);
    
    handles.view_look = 'bic';
    view_proc_look(handles);
    
    guidata(hObject, handles);
    update_model_select_look(handles);
    
else
    
    
    
errordlg('No proc_data found')


end






% --------------------------------------------------------------------
function export_figure_Callback(hObject, eventdata, handles)
% hObject    handle to export_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



figure 
copyobj(handles.axes1,gcf)
set(gca,'Position', [0.1300    0.1100    0.7750    0.8150])





% --------------------------------------------------------------------
function save_sorted_Callback(hObject, eventdata, handles)
% hObject    handle to save_sorted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

possible_names = {strcat('sort2_', handles.proc_name),strcat('sort2_', handles.proc_name),strcat('sort3_', handles.proc_name),...
    strcat('sort4_', handles.proc_name),strcat('sort5_', handles.proc_name),strcat('sort6_', handles.proc_name),strcat('sort7_' ,handles.proc_name)...
    strcat('sort8_', handles.proc_name),strcat('sort9_', handles.proc_name),strcat('sort10_', handles.proc_name),handles.proc_name};

new_names = cell(1,10);
for i = 1:11
temp = dir(possible_names{i}{1});
%temp = dir(handles.proc_name)
%temp = dir
if isempty(temp) == false

new_names{i} = possible_names{i}{1};

end



end

temp = cellfun(@isempty, new_names);
temp = find(temp ~= 0);

temp_string = ['Press enter to continue.\nThe default name is:  ', possible_names{temp(1)}{1}, '\nOr enter a name of your choosing     ' ];

user_entry = input(temp_string, 's');



if isempty(user_entry) == true
      
    save_name = possible_names{temp(1)}{1};
    
else
    
    save_name = [user_entry,'.proc'];
    
    
end


proc_data = handles.selected_data;

save(save_name, 'proc_data');


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


keypressed=get(hObject,'CurrentCharacter');
switch keypressed
    %lets test this out for all keyboard friendly:

    
    case 'z'
        
        
        if  strmatch('off', handles.zoom_state , 'exact') == true
            
            
            if strcmp(handles.view_look,'bic')
                % zooming on the BIC differnet than the other view_process look.
                
                %linkaxes([handles.axes1], 'xy')
                %zoom(handles.axes1, 'on')
                %zoom(handles.figure1,'on')
                
            else
                %
                linkaxes([handles.axes2 handles.axes3], 'x')
                %set(h,'Motion','both','Enable','on','ButtonDownFilter',@mycallback);
                h = zoom;
                set(h,'Motion','both','Enable','on');
                
                handles.zoom_state = 'on';
                
                setAxesZoomMotion(h,handles.axes1,'both')
                setAxesZoomMotion(h,handles.axes2,'both')
                setAxesZoomMotion(h,handles.axes3,'both')
                setAxesZoomMotion(h,handles.axes4,'both')
                setAxesZoomMotion(h,handles.axes5,'both')
                
                %setAxesZoomMotion(h,handles.axes6,'both')
                % the following is valid while zoom is active
                % trick to get things to work from
                % http://groups.google.ca/group/comp.soft-sys.matlab/msg/db42cf51392b442a
                %@(hObject,eventdata)view_proc('figure1_WindowButtonDownFcn',hObject,eventdata,guidata(hObject))
                
                %hManager = uigetmodemanager(handles.figure1);
                %set(hManager.WindowListenerHandles,'Enable','off');
                %set(handles.figure1,'WindowKeyPressFcn',@(hObject,eventdata)view_proc('figure1_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));
  
            hManager = uigetmodemanager(handles.figure1);
            set(hManager.WindowListenerHandles,'Enable','off');
            set(handles.figure1,'WindowKeyPressFcn',@(hObject,eventdata)view_proc('figure1_WindowKeyPressFcn',hObject,eventdata,guidata(hObject)));

                
            end
            
            
                      
        else
            
            zoom off
            handles.zoom_state = 'off';

        end     
end


guidata(gcf, handles);

figure(handles.figure1)




% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
figure(handles.figure1)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

tv = get(handles.popupmenu1,'Value');

if tv == 3 
update_proc_look(handles);

elseif tv == 5
  % no update required for this at the time...
    
else
end
%active_plot(handles);
%guidata(hObject, handles);









% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

tv = get(handles.popupmenu1,'Value');

switch tv
    case 2
      
        % Need to consider how converting to FPS... 

        
    case 3
        
        tv = get(handles.checkbox3,'Value');
        if tv == true
        set(handles.axes1,'xScale','log','yScale','log')
        %set(handles.axes4,'xScale','log','yScale','log')
        else
        set(handles.axes1,'xScale','linear','yScale','linear')
        %set(handles.axes4,'xScale','linear','yScale','linear')
        end
        
        
end
        


% --------------------------------------------------------------------
function export_table_Callback(hObject, eventdata, handles)
% hObject    handle to export_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if strmatch(handles.view_look,'data')
    output = generate_smart_table(handles,1);
    data = output{1};
    column_names = output{2};
    
    
    save current_data data column_names
    disp('Data was saved to current_data in the current directory')
    disp('Rename to prevent overwiriting')
elseif strmatch(handles.view_look,'bic')
    
    bic_table = handles.BIC;
    logPx_table = handles.logPx;
    trace_length = handles.tlength;
    
    save logpx_bic_table bic_table logPx_table trace_length
    disp('Data was saved to logpx_bic_table in the current directory')
    disp('Rename to prevent overwiriting')
    
    
elseif strmatch(handles.view_look,'cluster')
    
    
else
end
        
        
        
       

