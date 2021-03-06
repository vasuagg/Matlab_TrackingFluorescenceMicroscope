%function FRET_calculator_boss look into fluo data file and calculate FRET
%efficiency. It returns the peak counts in both Donor and Aceptor and
%calculate FRET efficencies for all the peaks. You probably have to use the
%mean and std of FRET_e to report your findings...

%Created 02/15/2009 by ZK.

function [Don_pk_C,Acp_pk_C,FRET_e]=FRET_calculator_boss(filenum,dt,level)


if exist(sprintf('./data_%g.mat',filenum))
    %disp(cd);
    display(sprintf('processing data_%g.mat',filenum));
    load(sprintf('./data_%g.mat',filenum));
    plot_title = sprintf('data\\_%g.mat', filenum);
else
    error('File does not exist.');
end

%this is just how the data is saved for 082809 data. 
Don_tags=tags{2};
Acp_tags=tags{1};

[Don_C, Don_t] = atime2bin(Don_tags, dt);
[Acp_C, Acp_t] = atime2bin(Acp_tags, dt);

% Acp_t_size=size(Acp_t)
 %Don_t_size=size(Don_t)
    
%this is the core of this code - looking into Acceptor counts to look for
%FRET events as the FRET events will only be there if the acceptor
%fluoresce. It basically find locations of acceptor fluorescence peaks and
%then look at the corresponding locations of donor signal. Then it use the
%count information at both channels to calculate the FRET efficiency. 
clear Acp_pk_time;
clear Acp_pk_index
[Acp_pk_time,Acp_pk_index,Acp_pk_count]=peak_detector_boss(Acp_tags,dt,level);

% number of peaks
N_pk=length(Acp_pk_index);



%one cannot just use the Acp_pk_index for the donor fluo as the index might
%be slightly different. You can see that by comparing the sizes of the two
%times: Acp_t and Don_t. Thus here we use the Acp_pk_time to locate the
%cloest time in the Don channel to find the right spot to do the
%comparison. 

for j=1:1:N_pk
    %find the right time spot and assign Don_pk_index. 
    Don_pk_index(j)=dsearchn(Don_t',Acp_pk_time(j));
    Don_pk_time(j)=Don_t(Don_pk_index(j));
     
end




for j=1:1:N_pk
    if Acp_pk_index~=0
    
    %this is used to find the top 12 to display.
    Acp_pk(j)=Acp_C(Acp_pk_index(j));
    
    %sum up the counts around the pks.     
    Acp_pk_C(j)=Acp_C(Acp_pk_index(j)-2)+Acp_C(Acp_pk_index(j)-1)+Acp_C(Acp_pk_index(j))+Acp_C(Acp_pk_index(j)+1)+Acp_C(Acp_pk_index(j)+2);

    % sum the counts at Don channel. 
    Don_pk_C(j)=Don_C(Don_pk_index(j)-2)+Don_C(Don_pk_index(j)-1)+Don_C(Don_pk_index(j))+Don_C(Don_pk_index(j)+1)+Don_C(Don_pk_index(j)+2);
       
    %Don_pk_C(j)=Don_C(Acp_pk_index(j)-2)+Don_C(Acp_pk_index(j)-1)+Don_C(Acp_pk_index(j))+Don_C(Acp_pk_index(j)+1)+Don_C(Acp_pk_index(j)+2);
    else
        Acp_pk_C=-1;
        Don_pk_C=-1;

    end
    
end


%calculate the FRET efficiency
if Acp_pk_C>0
    FRET_e=Acp_pk_C./(Acp_pk_C+Don_pk_C);
else
    FRET_e=-0.1;
end

 

if 0
%get screen size for a big figure.
scrsz = get(0,'ScreenSize');

%plot the pks in a plot. 
if N_pk<=12
    figure_h=figure('Name',strcat(cd,' data', num2str(filenum),' ALL'),'Position',[1 scrsz(4)-1270 scrsz(3) scrsz(4)]); hold all; clf;
      
    for j=1:1:N_pk
        subplot(3,4,j);
        
        plot(Don_t( (Don_pk_index(j)-0.5*1e-2/dt):(Don_pk_index(j)+0.5*1e-2/dt) ), Don_C( (Don_pk_index(j)-0.5*1e-2/dt):(Don_pk_index(j)+0.5*1e-2/dt) ),'b')
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Counts in 250 uS', 'FontSize', 14);
        
        hold on;
        
        plot(Acp_t( (Acp_pk_index(j)-0.5*1e-2/dt):(Acp_pk_index(j)+0.5*1e-2/dt) ), Acp_C( (Acp_pk_index(j)-0.5*1e-2/dt):(Acp_pk_index(j)+0.5*1e-2/dt) ),'g')
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Counts in 250 uS', 'FontSize', 14);
        
    end


else
    figure('Name',strcat(cd,' data', num2str(filenum),' TOP 12'),'Position',[1 scrsz(4)-1270 scrsz(3) scrsz(4)]); hold all; clf;
    for j=1:1:12
        [max_C,max_C_index]=max(Acp_pk);    
        %so next round you won't find the same thing. 
        Acp_pk(max_C_index)=-1;
               
        subplot(3,4,j);
        plot(Don_t( (Don_pk_index(max_C_index)-0.5*1e-2/dt):(Don_pk_index(max_C_index)+0.5*1e-2/dt) ), Don_C( (Don_pk_index(max_C_index)-0.5*1e-2/dt):(Don_pk_index(max_C_index)+0.5*1e-2/dt) ),'b')
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Counts in 250 uS', 'FontSize', 14);
        
        hold on;
        
        plot(Acp_t( (Acp_pk_index(max_C_index)-0.5*1e-2/dt):(Acp_pk_index(max_C_index)+0.5*1e-2/dt) ), Acp_C( (Acp_pk_index(max_C_index)-0.5*1e-2/dt):(Acp_pk_index(max_C_index)+0.5*1e-2/dt) ),'g')
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Counts in 250 uS', 'FontSize', 14);
        
    end
    
   
  
    
    
end




    
        
end













