function output = group_mtraces(gui_state)

% concatenates mtraces files
%  
% output = concat_mtraces(gui_state)
% gui_state is a structu
% 
% gui_state.uitable1_Data =[movie_start movie_end  group_start group_end]
% example gui_state.uitable1_Data = [ 0 10 1 1;...]  
% example gui_state.uitable1_Data = [ 0 10 1 1;12 15 1 1] 
%
% gui_state.edit1_String = 'save name'
% 
% output = gui_state.edit1_String
%
% will save a .concat file of the concatenated mtraces files in the current
% directionr


%Movies to Concatenate
movie_to_get = gui_state.uitable1_Data;



% Only Sort For Selected Molecules
temp = find(movie_to_get(:,1)==0 & movie_to_get(:,2)==0 & movie_to_get(:,3)==1 & movie_to_get(:,4)==1);
movie_to_get(temp,:)=[];


    no_mtraces = {};
    group_data ={};
    imported_data =[];
    imported_group =[];


for k = 1:size(movie_to_get,1)
    
    movie_numbers = [  movie_to_get(k,1):movie_to_get(k,2) ];
    s_movie = [  movie_to_get(k,3) movie_to_get(k,4) ];
    
    
    % generate names that look like movie  names from the imput movie numbers
    

            
    file_names = generate_file_name(movie_numbers,s_movie, '.mtrace');
            
     
    number_of_movies = size(file_names,1);
    


    
    
    
    
    for i=1:number_of_movies
        
        
        try
        
        % generate names for the raw and kinetic files
        %new_names = track_filename(core_file_name{i},s_movie);
        
        
        % import raw data if the file exists
        
                    
                    load(file_names{i,1},'-mat')
                    
                    trace_info = dir(file_names{i,1});
                    trace_info.cd = cd;
                    
                    trace_info.movie_num = file_names{i,2};
                    trace_info.movie_ser = file_names{i,3};
                    
                    %not yet applicaible in this script=
                    trace_info.gp_num = NaN;
                    
                    % import the selected molecule and regions
                    selected_molecules = process_setting.selected;
                    for j =1:data.number_mol
                    
                    if selected_molecules(j)==1
                    
                    select_region = find(process_setting.selected_region(j,:)==1);
                    donor = data.traces(2*j-1,select_region);
                    acceptor = data.traces(2*j,select_region);


                    
                    temptrace = [donor' acceptor'];
                    
                    trace_info.accept_positions = data.positions(j,3:4);
                    trace_info.trace_num = j;
                    trace_info.spots_in_movie = data.number_mol; % the number of spots in a movie that 
%                    trace_info.tv_settings = process_setting.tv_settings; % the trace viewer settings 
                   
                    group_data = cat(1, group_data, {trace_info temptrace});
                    
                    

                   
                    end
                    end
                       
                    
                    imported_data = [imported_data, file_names{i,2}];
                    imported_group = [imported_group, file_names{i,3}];


        
                    
                    catch
       
                            no_mtraces = cat(1, no_mtraces, file_names{i,1});
                            
                    end
                    
                    
                    
    end
    end
    

no_mtraces    
    

if isempty(group_data) == true
   
    errordlg('No Files Found','File Error');
    
    
else





% save the concatenated data
%default_name =[''];
save_name =gui_state.edit1_String;
if strmatch(save_name, 'Default Name    movie[X X X ]_group[X X X].concat', 'exact') == true
    
    save_name = ['movie_' , mat2str(unique(imported_data)),'_group[',mat2str(unique(imported_group)),'].concat'];
    %default_name  = save_name;
    
else
    
    temp = findstr(save_name, '.concat') ;
    
    if isempty(temp)==true
        save_name = [save_name,'.concat'];
    end
    
    
end

save(save_name,  'group_data')

save_name

%gui_state.edit1_String = save_name;


end


output =  gui_state;

