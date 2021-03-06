function new_tags=peak_eater(tags,dt,level,plot_flag)
% 
% 
% %bin the tags into a rate thing. 
% [I, t] = atime2bin(tags, dt);
%  
%  %at the index where I is equal to level, pk_up_down is 1. 
%  %after that point, if I is just bigger than level, pk_up_down is -1. 
% pk_up_down=diff(I>level);
% 
% %now all you need to do is just to find the maximum between the 1 and -1. 
% 
% pk_up_index=find(pk_up_down==1);
% pk_down_index=find(pk_up_down==-1);
%  
% N_pk=min(length(pk_up_index),length(pk_down_index));
% 
% 
% 
% new_tags=tags;
% %eaten_index=cell(N_pk,1);
% %eaten_index_temp=[];
% 
% eaten_index=[];
% 
% for j=1:1:N_pk
%      eaten_index_temp=[];
%      
%     if pk_up_index(j)<pk_down_index(j)
%        time_up=t(pk_up_index(j));
%        time_down=t(pk_down_index(j));
%        eaten_index_temp=find(tags>=time_up & tags<=time_down);
%        eaten_index=[eaten_index,eaten_index_temp];
%     end
% end
%  

[I, t] = atime2bin(tags, dt);
new_tags=tags;
[pk_time,pk_index,pk_count]=peak_detector_boss(tags,dt,level,0);

eaten_index=[];

for j=1:1:length(pk_time)
    temp_high=min(find(tags>(pk_time(j)+0.5)));
    temp_low=max(find(tags<(pk_time(j)-0.5)));
    temp_eaten=(temp_low:1:temp_high);
    eaten_index=[eaten_index,temp_eaten];
end


if isempty(eaten_index)
        %do nothing
else
    new_tags(eaten_index)=[];
end
    
size(eaten_index);
if plot_flag
    [I_new, t_new] = atime2bin(new_tags, dt);
    scrsz = get(0,'ScreenSize');
    figure('Name',cd,'Position',[1 scrsz(4)/2-100 scrsz(3) scrsz(4)/2-100]); clf;
    subplot(1,2,1);
    plot(t, I);
    subplot(1,2,2);
    plot(t_new,I_new);

    set(gca, 'Box', 'On');
    xlabel('Time [s]', 'FontSize', 14);

    if 10^-6<=dt<10^-3
        ylabel(sprintf('Counts in %g uS',dt*10^6), 'FontSize', 14);
    end
    if 10^-3<=dt<=10^-0
    ylabel(sprintf('Counts in %g mS',dt*10^3), 'FontSize', 14);
    end
    set(gca, 'FontSize', 12);
    set(gca, 'LineWidth', 1);
    title('Peak Eaten!');
end    