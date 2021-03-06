function output = find_new_point(handles)

val(1) = get(handles.popupmenu2,'Value');
val(2) = get(handles.popupmenu3,'Value');


new_point = get(handles.axes1,'CurrentPoint');
new_point = new_point(1,1:2);


slop_x = get(handles.axes1,'xlim');
slop_x = (slop_x(2) - slop_x(1))/50;


slop_y = get(handles.axes1,'ylim');
slop_y = (slop_y(2) - slop_y(1))/50;



%slop_x = std([handles.to_plot{:,val(1)}]')/5;
%slop_y = std([handles.to_plot{:,val(2)}]')/5;




if val(1) ==1 && val(2) ~=1

new_molecule = find(    [handles.to_plot{:,val(2)}]'>=new_point(2)-slop_y & ...
        [handles.to_plot{:,val(2)}]'<=new_point(2)+slop_y );

    if ~isempty(new_molecule)
        new_molecule = new_molecule(1);
    end

else
    
    new_molecule = find(    [handles.to_plot{:,val(1)}]'>=new_point(1)-slop_x & ...
        [handles.to_plot{:,val(1)}]'<=new_point(1)+slop_x & ...
        [handles.to_plot{:,val(2)}]'>=new_point(2)-slop_y & ...
        [handles.to_plot{:,val(2)}]'<=new_point(2)+slop_y );
    
    
    
    % prefent error if no molecule found
    if ~isempty(new_molecule)
    
    
    
    temp_find = [handles.to_plot{new_molecule(1), val}];
    temp_find = [new_molecule(1) temp_find];
    
    temp_find(:,2) = temp_find(:,2) - new_point(1);
    temp_find(:,3) = temp_find(:,3) - new_point(2);
    
    temp_dot = [];
    for i=1:size(temp_find,1)
        x = dot(temp_find(i,2:3),temp_find(i,2:3));
        temp_dot = [ temp_dot; x];
        
    end
    
    temp_find = [ temp_find temp_dot];
    
    if isempty(new_molecule) == true
        temp_find = [ 1 1 1 1];
    end
    
    temp_find = sortrows(temp_find,4);
    
    new_molecule = temp_find(1,1);
    
    end

end

output = new_molecule;





