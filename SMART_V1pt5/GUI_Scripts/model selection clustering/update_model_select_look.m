function update_model_select_look(handles)



val = get(handles.popupmenu2,'Value');


    

switch val
    
    
    
    case 1

cla(handles.axes1);
zoom(handles.axes1,'off')
%cla(handles.axes1,'reset');
for i=1:size(handles.BIC,1)
p1 = plot(handles.axes1,1:size(handles.BIC,2),handles.BIC(i,:));
set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
hold(handles.axes1,'on')
end

%hold(handles.axes1,'off')


%figure
%plot([ones(10,1) ones(10,1)*2],handles.BIC(1:10,:));

%for i=1:size(handles.BIC,1)
%p1 = plot(handles.axes1,ones(size(handles.BIC,1),1)*1:size(handles.BIC,2),handles.BIC,'*k');
%set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
%hold(handles.axes1,'on')
%end





ylabel(handles.axes1,'BIC')
xlabel(handles.axes1,'Fit Group')
%set(handles.axes2,'Xtick',1:size(handles.BIC,2))  
%zoom on


xrange = 1:size(handles.BIC,2);
xlim([xrange(1)-0.5 xrange(end)+0.5])
%zoom(handles.axes1,'on')
%zoom(handles.axes2,'on')
h = zoom;
                set(h,'Motion','both','Enable','on');
                
                handles.zoom_state = 'on';
                
                setAxesZoomMotion(h,handles.axes1,'both')




    case 2
    
cla(handles.axes1,'reset');
zoom(handles.axes1,'off')
for i=1:size(handles.BIC,1)
p1 = plot(handles.axes1,1:size(handles.BIC,2),handles.BIC(i,:)./handles.tlength(i,:));
set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
hold(handles.axes1,'on')
end

ylabel(handles.axes1,'Normalized BIC')
xlabel(handles.axes1,'Fit Group')
set(handles.axes1,'Xtick',1:size(handles.BIC,2))  
%zoom(handles.axes1,'on')
xrange = 1:size(handles.BIC,2);
xlim([xrange(1)-0.5 xrange(end)+0.5])
zoom(handles.axes1,'on')


    case 3

cla(handles.axes1,'reset');        
zoom(handles.axes1,'off')
for i=1:size(handles.logPx,1)
p1 = plot(handles.axes1,1:size(handles.logPx,2),handles.logPx(i,:));
set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
hold(handles.axes1,'on')
end

ylabel(handles.axes1,'LogPx')
xlabel(handles.axes1,'Fit Group')
set(handles.axes1,'Xtick',1:size(handles.logPx,2))  
%zoom(handles.axes1,'on')
    
xrange = 1:size(handles.BIC,2);
xlim([xrange(1)-0.5 xrange(end)+0.5])
zoom(handles.axes1,'on')


    case 4

        cla(handles.axes1,'reset');    
        zoom(handles.axes1,'off')
for i=1:size(handles.logPx,1)
p1 = plot(handles.axes1,1:size(handles.logPx,2),handles.logPx(i,:)./handles.tlength(i,:));
set(p1,'Marker','*','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',0.5,'Color','k');
hold(handles.axes1,'on')
end

ylabel(handles.axes1,'Normalized LogPx')
xlabel(handles.axes1,'Fit Group')
set(handles.axes1,'Xtick',1:size(handles.logPx,2))  
%zoom(handles.axes1,'on')

xrange = 1:size(handles.BIC,2);
xlim([xrange(1)-0.5 xrange(end)+0.5])
zoom(handles.axes1,'on')



end











