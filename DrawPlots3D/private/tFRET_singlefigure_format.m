function tFRET_singlefigure_format(tags, trackdata, t0, stage_pos, daqdata, ...
    daq_out, num_var, var_args);

disp('tFRET single format used')

if length(var_args)==2
   filenum=var_args{1};
   plot_title = sprintf('data\\_%g.mat', filenum);   
   dt = 10*10^-3; % bined at 10ms. 
end

if length(var_args)==5
   filenum=var_args{1};
   plot_title = sprintf('data\\_%g.mat', filenum);
   dt = var_args{2};
   t_begin = var_args{3};
   t_end = var_args{4};
end



if num_var > 1,
    if ~strcmp(class(var_args{2}), 'char'),
        dt = var_args{2};
    else
        if num_var == 3,
            dt = var_args{3};
        end;
    end;
end;


%numPlots = 1 + trackdata + daqdata;


scrsz = get(0,'ScreenSize');

%[left, bottom, width, height]:
if length(var_args)==2
    %figure('Name',cd,'Position',[100 50 scrsz(3)-400 scrsz(4)-150]);
    
    
    figure(777)
    clf
    set(gcf,'Position',[150 50 scrsz(3)-400 scrsz(4)-150]);
    
end 

%if length(var_args)==5
 %   h=figure('Name',cd,'Position',[500 100 scrsz(3)/3 scrsz(4)-200]);
%end



subplot(4, 1, 1:2);
t = cell(length(tags), 1);
hold all;
if length(tags)==1
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    plot(t{1},I{1}*1e-3/dt,'b');
elseif length(tags)==2
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    plot(t{1},I{1}*1e-3/dt,'b');
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    plot(t{2},I{2}*1e-3/dt,'r');
elseif length(tags)==3
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    plot(t{1},I{1}*1e-3/dt,'b');
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    plot(t{2},I{2}*1e-3/dt,'r');
    [I{3}, t{3}] = atime2bin(tags{3}, dt);
    plot(t{3},I{3}*1e-3/dt,'g');
elseif length(tags)==4
    [I{1}, t{1}] = atime2bin(tags{1}, dt);
    [I{2}, t{2}] = atime2bin(tags{2}, dt);
    [I{3}, t{3}] = atime2bin(tags{3}, dt);
    [I{4}, t{4}] = atime2bin(tags{4}, dt);
    
    plot(t{1},I{1}*1e-3/dt,'r');
    
    plot(t{2},I{2}*1e-3/dt,'b');
    
    plot(t{3},-I{3}*1e-3/dt,'r');
    
    plot(t{4},-I{4}*1e-3/dt,'b');
    
    plot(t{1},t{1}*0,'k')
    
    
end

 
if length(var_args)==5
    
   
    axis([t_begin t_end 0 1])
    axis 'auto y';
end 

hold off;
set(gca, 'Box', 'On');

xlabel('Time [s]', 'FontSize', 14);
ylabel('Fluorescence [kHz]', 'FontSize', 14);
set(gca, 'FontSize', 12);
title(plot_title);

if trackdata,
    subplot(4, 1, 3);
    plot(t0, stage_pos(:,1),t0, stage_pos(:,2),t0, stage_pos(:,3));
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Position [\mum]', 'FontSize', 14);
    set(gca, 'FontSize', 12);
    set(gca, 'LineWidth', 1);
    if length(var_args)==5
        axis([t_begin t_end 0 100])
        axis 'auto y';
    end 
end;


if daqdata,
    subplot(4,1,4);
    plot(t0,daq_out(:,1),'k');
    hold on;
    plot(t0,daq_out(:,2),'g');
    
    xlabel('Time [s]', 'FontSize', 14);
    ylabel('Qdot Fluorescence [A.U.]', 'FontSize', 14);
    set(gca, 'FontSize', 12);
    set(gca, 'LineWidth', 1);
    
    if length(var_args)==5
        
        axis([t_begin t_end 0 10]);
        axis 'auto y';
    end 
    
    %[AX,H1,H2]=plotyy(t0,daq_out(:,1),t0,daq_out(:,2));
    %set(get(AX(1),'Ylabel'),'String','Qdot Fluorescence') 
    %set(get(AX(2),'Ylabel'),'String','Laser Intensity') 
   
end

if length(var_args)==5
   set(gcf, 'PaperPositionMode', 'manual');
   set(gcf, 'PaperUnits', 'inches');
   set(gcf, 'PaperPosition', [2 1 6 10]);%[left bottom width height]
    
    
    fig_name = sprintf('plot_%g', filenum);
    saveas(gcf,fig_name,'fig');
    saveas(gcf,fig_name,'png');
    
    
end 

hold off;
