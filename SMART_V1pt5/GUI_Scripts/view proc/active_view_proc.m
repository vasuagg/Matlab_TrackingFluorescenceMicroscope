function output = active_view_proc(handles)






plot_types = { ...
    '' ''
    'movie_num' 'Movie Number'
    'movie_ser' 'Movie Seried'
    'trace_num' 'Trace Number'
    'spots_in_movie' 'Spots in Movie'
    'accept_positions_x' 'Acceptor X'
    'accept_positions_y' 'Acceptor y'
    'fps' 'fps'
    'trace_length' 'Trace Length'
    'dltg' 'dltg'
    'mean_total_i' 'Mean Total Intensity'
    'snr' 'SNR'
    'fold_cumufit_1(1)' 'fold_cumufit_1'
    'unfold_cumufit_1(1)' 'unfold_cumufit_1'
    'logPx' 'logPx'
    'BIC' 'BIC'};
    




meta_names = [];
    
    
to_plot = [];
hmm_to_plot = [];
hmm_names = {};
error_hmm_to_plot = [];
error_hmm_names = [];

for i=1:size(handles.selected_data,1)

   
    



%hmm_names = {};
%hmm_to_plot = [];
error_names = {};
error_data = {};
temp_error_data = [];
if ~isempty(handles.selected_data{i,7}.A)
    

    try

    reshape = handles.selected_data{i,7}.reshape ;
    
    %reshape.rate_1to1 = NaN
    
    temp_names = fieldnames(reshape);
    temp_data = struct2cell(reshape);
    
    temp = cellfun(@isempty, temp_data);
    temp_data(temp) = [];
    temp_names(temp) = [];

    temp = cellfun(@iscell, temp_data);
    error_data = temp_data(temp);
    error_names = temp_names(temp);
    temp_data(temp) = [];
    temp_names(temp) = []; 

    hmm_names = temp_names';
    hmm_to_plot =cell2mat(temp_data)';
    

    
    
    for k=1:size(error_data,1)
  
    temp = [error_data{k}{4} error_data{k}{6}];
    temp_error_data = [ temp_error_data {temp}];

    end
    
    catch
  
    temp_str = [ 'Trace' num2str(i) ' has a differn number of fields in the HMM Part \n\n'];
    fprintf(1,temp_str)
    rethrow(err)  
    
    end   
end





% get non HMM data
temp_to_plot = NaN(1,size(plot_types,1));

for j=1:size(plot_types,1)
    
    try

        for k=4:7
            
            if isfield(handles.selected_data{i,k},plot_types{j,1})
                  
                if isnan(temp_to_plot(j))
                    
                    if ~isempty(getfield(handles.selected_data{i,k},plot_types{j,1}))
                        temp_to_plot(j) = getfield(handles.selected_data{i,k},plot_types{j,1});
                    end
                   
                else
                    error('multiple fields of the same name')
                end
            end
        end
        
    catch
        
        temp_str = [ 'Trace' num2str(i) 'Has multiple fields of the same name \n\n'];
        
        fprintf(1,temp_str)
        rethrow(err)      
    end
end





try

% concatentat all all data
meta_names = [meta_names; [plot_types(:,1)' hmm_names error_names']];

tempcell = [temp_to_plot hmm_to_plot];
tempcell = mat2cell(tempcell,1,ones(1,size(tempcell,2)));

temp_to_plot = cat(2,tempcell,temp_error_data);
to_plot = [to_plot; temp_to_plot];

catch
    
disp(['Fields in Trace ' num2str(i) ' do no match field of first trace'])
    
    
end


end



1
% clean up for dispaly
display_plot_types = cellfun(@(x) regexprep(x,'_',' ') , meta_names(1,:)','uniformoutput',false);


set(handles.popupmenu2,'String' ,{'x axis' display_plot_types{:}}); 
set(handles.popupmenu3,'String' ,{'y axis' display_plot_types{:}});      
   
    
    


output = {to_plot meta_names(1,:)'};


