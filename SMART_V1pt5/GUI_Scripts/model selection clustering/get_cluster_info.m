function output = get_cluster_info(handles)



numTraces = size(handles.selected_data,1);

temp_var_names = [];
for k=1:numTraces
    
   temp_covar = [];
    for i=1:size(handles.selected_data{k,7}.covmats,2)
       
        temp_name = [];
        for j=1:size(handles.selected_data{k,7}.covmats{i}.varnames,2)
           temp_name = [temp_name ,',',handles.selected_data{k,7}.covmats{i}.varnames{j} ];  
        end
        temp_name(1) = '(';
        temp_name = [temp_name ')'];
        
        
        
        temp_covar = [temp_covar {temp_name}];
    end
    
    temp_var_names = [temp_var_names; [temp_covar [temp_covar{:}]]];
    
end


poor_match = [];
for k=1:numTraces-1
    poor_match = [poor_match strcmp(temp_var_names{k,end},temp_var_names{k+1,end})]  ;
end

te = find(poor_match==0);

if ~isempty(te)
    cat(2,mat2cell(1:size(temp_var_names,1),1,ones(size(temp_var_names,1),1))',temp_var_names)
    error('Not all covmatx allign  All traces must have the same covmatx.') 
    

end


output = temp_covar;






