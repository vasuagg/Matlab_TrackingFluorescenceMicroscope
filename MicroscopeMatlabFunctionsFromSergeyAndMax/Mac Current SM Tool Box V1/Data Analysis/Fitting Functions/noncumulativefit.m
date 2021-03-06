function  output = noncumulativefit(datasource,datasource2, concentration, fps)


% This was created by Max Greenfeld on 051908 to fit traces in a
% noncumulative way

%% First Section Imports The Data

% Comment out this section if calling the function through another function
% of the comand line
datasource = '(kinetics)cascade14.15.16.17.18.19.20.21.22.(25 mM)(4).dat';
datasource2 ='(kinetics2)cascade14.15.16.17.18.19.20.21.22.(25 mM)(4).dat';
concentration = 5;
fps = 25;
%
%

frame = 1/fps;
if regexpi(datasource, 'refold') ~= 0
    backwards = 1
elseif regexpi(datasource, 'shorten') ~= 0
    backwards = 1
else
    backwards = 0
% regexpi(str, 'c[aeiou]+t')
end

%Count the number of molecules using datasource2

B = importdata(datasource2);
sortedmolecule= sortrows(B,1);
numbermolecules= find(sortedmolecule(:,1)==9);
numbermolecules= size(numbermolecules,1);
%

%first grab the data
A = importdata(datasource);

% then sort it
sorted= sortrows(A,1);

%  find the low/high breakpoint
low = find(sorted,1) - 1;

% create a low fret array
lowsorted = sorted(1:low,:);
%create the high fret array
highsorted = sorted(low+1:end,:);

%switch refolding
if backwards == 1
    temp = lowsorted;
    lowsorted = highsorted;
    highsorted = temp;
end


% find the frequency data
% grab the dwells times into a single array, and divide by the frame rate
highfretdwells = highsorted(:,2)'/fps;
lowfretdwells = lowsorted(:,2)'/fps;
%create a the bin centers vectors from 0 to a value
 
    % get a table of frequency data
    hightable = tabulatebetter(highfretdwells);
    lowtable = tabulatebetter(lowfretdwells);

% This code fills in dwell time that dont have an observed transition with
% the fraction of events of the earliest real observation
% 120407 This was commented out by Greenfeld, this does not seem to be a
% legit way of processing data


% % % % % % % % % % % % % % % % % % % % 
% fill in the zeros on the table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

longestdwellhigh = max(hightable(:,1));
%filler = [0:frame:longestdwellhigh]';
% uniquedwells = unique(hightable(:,1)
%for i=1:1:((longestdwellhigh/frame)+1)
%    spot = floor(filler(i)*1000);
%    spotintable = floor(hightable(i,1)*1000);
%    if spotintable == spot  % for some reason, 0.0389 ~= 0.0389!
      
%        continue
%    elseif spotintable > spot
%    addedrow = [filler(i) 0 hightable(i-1,3) hightable(i-1,4)];
%      spotintable*1000
%      spot*1000
%    hightable = [hightable;addedrow];
%    hightable = sortrows(hightable,1);
%     next i
%     continue
%    end
%end


hightable;

longestdwelllow = max(lowtable(:,1));

%filler = [0:frame:longestdwelllow]';
% uniquedwells = unique(hightable(:,1)
%for i=1:1:(longestdwelllow*fps+1)
%     spot = filler(i);
%     spotintable = lowtable(i,1);
%spot = floor(filler(i)*1000);
%    spotintable = floor(lowtable(i,1)*1000);
%if spotintable == spot
      
 %       continue
 %   elseif spotintable > spot
 %   addedrow = [filler(i) 0 lowtable(i-1,3) lowtable(i-1,4)];
 %   lowtable = [lowtable;addedrow];
 %   lowtable = sortrows(lowtable,1);
%     next i
%     continue
  %  end
%end
% % % % % % % % % % % % % % % % % % % %     

%total length of dwells
timetotalhigh = sum(highsorted(:,2))/fps;    
timetotallow  = sum(lowsorted(:,2))/fps;

%number of dwells
totaldwellshigh = size(highsorted,1);
totaldwellslow = size(lowsorted,1);

 title = [num2str(concentration) ' mM Metal kinetics' num2str(fps) ' fps'];

%% Fit The data with in Cumulative Way

% Unfolding Kinetics First

% fit with single exponenetial
options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
[doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],hightable(:,1),hightable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
% resnormhigh;
doublefithighval = [doublefithigh 0];
doublefithighval(4) = doublefithigh(3);
doublefithighval(3) = (1-doublefithigh(1));
% double exponenetials                
[singlefithigh resnormhighsingle]= lsqcurvefit(@singleexponential,[1],hightable(:,1),hightable(:,4));
%resnormhighsingle;
xvalueshigh=hightable(:,1);
ydoublehigh=(doubleexponential(doublefithigh,xvalueshigh));
ysinglehigh=(singleexponential(singlefithigh,xvalueshigh)); 
% Calculate Residualt
doubleresidualhigh = hightable(:,4)-ydoublehigh;
singleresidualhigh = hightable(:,4)-ysinglehigh;


% Folding Kinetics First

%   fit with single and double exponenetials
options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000000,'MaxIter',1000,'Display','Final');
[doublefitlow, resnormlow, residuallow] = lsqcurvefit(@doubleexponential,[0.6,30,0.1],lowtable(:,1),lowtable(:,4),[0 .001 0.001],[1 fps fps],options);
%resnormlow
%residuallow;
doublefitlowval = [doublefitlow 0];
doublefitlowval(4) = doublefitlow(3);
doublefitlowval(3) = (1-doublefitlow(1));
[singlefitlow, resnormlowsingle] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
%resnormlowsingle
xvalueslow=lowtable(:,1);
ydoublelow=(doubleexponential(doublefitlow,xvalueslow));
ysinglelow=(singleexponential(singlefitlow,xvalueslow));
                    
% Creats residuals
%%This cell was added by Max Greenfeld on 112707 To Plot Residuals

doubleresiduallow = lowtable(:,4)-ydoublelow;
singleresiduallow = lowtable(:,4)-ysinglelow;


 
%% Create figure with Fits of Cumulative FRET Histograms

figure1 = figure('Color',[1 1 1],'Name', title,'PaperPosition',[0 0 6 5],'papersize',[6 5]);
 
% Plot Unfolding

%Create axes - High FRET dwells
axes1 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.55 0.4 .4],'Parent',figure1,'Visible','on','box','on');
axes3 = axes('FontName','Arial','FontSize',10,'Position',[0.3 0.55 0.22 .4],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');

%Added Max 112707 Want To Plot Residuals
axes5 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.3 0.4 0.2],'Parent',figure1,'Visible','on','box','on');
axes6 = axes('FontName','Arial','FontSize',10,'Position',[0.3 0.3 0.22 0.2],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');
%End Added Max 112707 Want To Plot Residuals

ylim(axes1,[0 1.1]);
ylim(axes3,[0 1.1]);

set(axes3,'YTick', []);
set(axes6,'YTick', []);

%xlabel(axes1,'Dwell time (s)');
ylabel(axes1,'Normalized counts (cumulative)');
hold(axes1,'all');
hold(axes3,'all');
 
%%Added Max 112707 Want To Plot Residuals
ylim(axes5,[-0.2 0.2]);
ylim(axes6,[-0.2 0.2]);
xlabel(axes5,'Dwell time (s)');
ylabel(axes5,'Residuals');
hold(axes5,'all');
hold(axes6,'all');
%End Added Max 112707 Want To Plot Residuals

%Create scatter
scatter1 = scatter(hightable(:,1),hightable(:,4),'Parent',axes1,'Marker','square','MarkerEdgeColor',[0 0 0],'SizeData',[24],'DisplayName','unfoldingfast');
scatter3 = scatter(hightable(:,1),hightable(:,4),'Parent',axes3,'Marker','square','MarkerEdgeColor',[0 0 0],'SizeData',[24],'DisplayName','unfoldingslow');

%Create plot double exponential
plot1 = plot(xvalueshigh,ydoublehigh,'Color',[0 0 1],'LineWidth',2,'Parent',axes1,'DisplayName','double exponential');
plot3 = plot(xvalueshigh,ydoublehigh,'Color',[0 0 1],'LineWidth',2,'Parent',axes3,'DisplayName','double exponential');
  
%Create plot single exponential
plot2 = plot(xvalueshigh,ysinglehigh,'Color',[1 0 0],'LineWidth',2,'Parent',axes1,'DisplayName','single exponential');
plot4 = plot(xvalueshigh,ysinglehigh,'Color',[1 0 0],'LineWidth',2,'Parent',axes3,'DisplayName','single exponential');

%Creat plot of residuals
%This cell was added by Max Greenfeld on 112707 To Plot Residuals

plot5 = scatter(xvalueshigh,doubleresidualhigh,'Parent',axes5,'DisplayName','double exponential','Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
plot5a = scatter(xvalueshigh,doubleresidualhigh,'Parent',axes6,'DisplayName','double exponential','Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
plot6 = scatter(xvalueshigh,singleresidualhigh,'Parent',axes5,'DisplayName','single exponential','Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24]);
plot6a = scatter(xvalueshigh,singleresidualhigh,'Parent',axes6,'DisplayName','single exponential','Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24]);

% Adjust x limits
% middley = find ((10*hightable(:,4)') <= 7.5);
middley = find ((10*hightable(:,4)') <= 7.5);  %not bad
middley=max(middley);

if middley <= 4
    middley = 4;
end
xaxisbreak = hightable(middley,1);
% set(axes1,'XTick'
xlim(axes1,[0 xaxisbreak]);
xlim(axes3,[xaxisbreak/2 longestdwellhigh+1]);
%adjusts tick marks and labels

% Redone by Max...I could not get the orrigional work
currentticks = get(axes1,'XTick');
for j=1:numel(currentticks)
    
    if currentticks(j) < xaxisbreak/2;
     newticks(j)= currentticks(j)
    end  
end
set(axes1,'XTick', newticks);

xlim(axes5,[0 xaxisbreak]);
xlim(axes6,[xaxisbreak/2 longestdwellhigh+1]);

currentticks = get(axes5,'XTick');
for j=1:numel(currentticks)
    
    if currentticks(j) < xaxisbreak/2;
     newticks(j)= currentticks(j)
    end  
end
set(axes5,'XTick', newticks);

betterticks =[xaxisbreak/2 get(axes3,'XTick')];
set(axes3,'XTick', betterticks);

betterticks =[xaxisbreak/2 get(axes6,'XTick')];
set(axes6,'XTick', betterticks);

% Plot Folding

%Create axes - Low FRET dwells
axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.55 0.4 0.4],'Parent',figure1,'box','on');
axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.78 0.55 0.22 0.4],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');

%Added Max 112707 Want To Plot Residuals
axes7 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.3 0.4 0.2],'Parent',figure1,'box','on');
axes8 = axes('FontName','Arial','FontSize',10,'Position',[0.78 0.3 0.22 0.2],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');
%End Added Max 112707 Want To Plot Residuals

set(axes4,'YTick', []);
set(axes8,'YTick', []);

ylim(axes2,[0 1.1]);
ylim(axes4,[0 1.1]);
%xlabel(axes2,'Dwell time (s)');
ylabel(axes2,'Normalized counts (cumulative)');
hold(axes2,'all');
hold(axes4,'all');

%Added Max 112707 Want To Plot Residuals
ylim(axes7,[-0.2 0.2]);
ylim(axes8,[-0.2 0.2]);
xlabel(axes7,'Dwell time (s)');
ylabel(axes7,'Residuals');
hold(axes7,'all');
hold(axes8,'all');
%End Added Max 112707 Want To Plot Residuals

% Create scatter
scatter2 = scatter(lowtable(:,1),lowtable(:,4),'Parent',axes2,'Marker','o','SizeData',[24],'MarkerEdgeColor',[0 0 0],'DisplayName','foldingfast');
scatter4 = scatter(lowtable(:,1),lowtable(:,4),'Parent',axes4,'Marker','o','SizeData',[24],'MarkerEdgeColor',[0 0 0],'DisplayName','foldingslow');
         
%Create plot double exponential
plot1 = plot(xvalueslow,ydoublelow,'Color',[0 0 1],'LineWidth',2,'Parent',axes2,'DisplayName','double exponential');
plot3 = plot(xvalueslow,ydoublelow,'Color',[0 0 1],'LineWidth',2,'Parent',axes4,'DisplayName','double exponential');
 
%Create plot single exponential
plot2 = plot(xvalueslow,ysinglelow,'Color',[1 0 0],'LineWidth',2,'Parent',axes2,'DisplayName','single  exponential');
plot4 = plot(xvalueslow,ysinglelow,'Color',[1 0 0],'LineWidth',2,'Parent',axes4,'DisplayName','single  exponential');

plot7 = scatter(xvalueslow,doubleresiduallow,'Parent',axes7,'DisplayName','double exponential','Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
plot7a = scatter(xvalueslow,doubleresiduallow,'Parent',axes8,'DisplayName','double exponential','Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
plot8 = scatter(xvalueslow,singleresiduallow,'Parent',axes7,'DisplayName','single exponential','Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24]);
plot8a = scatter(xvalueslow,singleresiduallow,'Parent',axes8,'DisplayName','single exponential','Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24]);

% make it look nice
% Adjust x limits
middley = find ((10*lowtable(:,4)') <= 7.5);
middley=max(middley);

% set(axes1,'XTick'
if middley <= 4
    middley=4;
end
xaxisbreak = lowtable(middley,1);
xlim(axes2,[0 xaxisbreak]);
xlim(axes4,[xaxisbreak/2 longestdwelllow+1]);

currentticks = get(axes2,'XTick');
clear newticks
for j=1:numel(currentticks)
    
    if currentticks(j) < xaxisbreak/2;
     newticks(j)= currentticks(j)
    end  
end
set(axes2,'XTick', newticks);

xlim(axes7,[0 xaxisbreak]);
xlim(axes8,[xaxisbreak/2 longestdwelllow+1]);

currentticks = get(axes7,'XTick');
for j=1:numel(currentticks)
    
    if currentticks(j) < xaxisbreak/2;
     newticks(j)= currentticks(j)
    end  
end
set(axes7,'XTick', newticks);

betterticks =[xaxisbreak/2 get(axes3,'XTick')];
%set(axes4,'XTick', betterticks);

betterticks =[xaxisbreak/2 get(axes6,'XTick')];
%set(axes8,'XTick', betterticks);

%create annotation labels
a = ['k = ' num2str(round(100*singlefithigh)/100)];
b = ['A1 = ' num2str(round(100*doublefithighval(1))/100)];
c = ['k1 = ' num2str(round(100*doublefithighval(2))/100)];
d = ['A2 = ' num2str(round(100*doublefithighval(3))/100)];
e = ['k2 = ' num2str(round(100*doublefithighval(4))/100)];
f = [num2str(timetotalhigh) ' s'];
g = [num2str(totaldwellshigh) ' dwells'];
h = ['# Molecules = ' num2str(numbermolecules)];


% Create textbox
annotation1 = annotation(figure1,'textbox','Position',[0.1 0.1 0.1 0.1],'FitHeightToText','on','String',{a,b,c,d,e,},'LineStyle','none');
annotation3 = annotation(figure1,'textbox','Position',[0.25 0.1 0.1 0.1],'FitHeightToText','on','String',{f,g,h},'LineStyle','none');
annotation5 = annotation(figure1,'textbox','Position',[0.15 0.7 0.3 0.3],'String','Unfolding','LineStyle','None','FontSize',18);    

%create annotation labels
a = ['k = ' num2str(round(100*singlefitlow)/100)];
b = ['A1 = ' num2str(round(100*doublefitlowval(1))/100)];
c = ['k1 = ' num2str(round(100*doublefitlowval(2))/100)];
d = ['A2 = ' num2str(round(100*doublefitlowval(3))/100)];
e = ['k2 = ' num2str(round(100*doublefitlowval(4))/100)];
f = [num2str(timetotallow) ' s'];
g = [num2str(totaldwellslow) ' dwells'];
h = ['# Molecules = ' num2str(numbermolecules)];

% Create textbox
annotation2 = annotation(figure1,'textbox','Position',[0.59 0.1 0.1 0.1],'FitHeightToText','on','String',{a,b c,d e},'LineStyle','none');
annotation4 = annotation(figure1,'textbox','Position',[0.79 0.1 0.1 0.1],'FitHeightToText','on','String',{f,g,h},'LineStyle','none');
annotation6 = annotation(figure1,'textbox','Position',[0.65 0.7 0.3 0.3],'String','Folding','LineStyle','None','FontSize',18);  
%output answer

output = [concentration, singlefithigh doublefithighval, singlefitlow doublefitlowval timetotalhigh totaldwellshigh timetotallow totaldwellslow ];
%%%% Fit the Data Noncumulative

 TimesInHighFret = sort(highfretdwells)';
 TimesInLowFret = sort(lowfretdwells)';

 binsize = (1/fps)*3; %sec
 binstop = TimesInHighFret(size(TimesInHighFret,1),1);
 eventprobability = 1/size(TimesInHighFret,1);

 % Calculate Unfolding Rate
 i=1;
 highbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInHighFret(:,1)>binsize*(i-1) & TimesInHighFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 highbinneddata = [highbinneddata; binpribability];
 end
 unfolding = mle(highbinneddata, 'distribution','exponential');
 
 
 % Calculate folding Rate
 i=1;
 lowbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInLowFret(:,1)>binsize*(i-1) & TimesInLowFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 lowbinneddata = [lowbinneddata; binpribability];
 end
 folding = mle(lowbinneddata, 'distribution','exponential');
 


%% Fit the Data Noncumulative

 TimesInHighFret = sort(highfretdwells)';
 TimesInLowFret = sort(lowfretdwells)';

 binsize = (1/fps)*3; %sec
 binstop = TimesInHighFret(size(TimesInHighFret,1),1);
 eventprobability = 1/size(TimesInHighFret,1);

 % Calculate Unfolding Rate
 i=1;
 highbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInHighFret(:,1)>binsize*(i-1) & TimesInHighFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 binposition = binsize*i-binsize/2;
 highbinneddata = [highbinneddata; [binposition  binpribability]];
 end
 unfolding = (mle(highbinneddata(:,2), 'distribution','exponential'));
 
 
ysinglehigh=(singleexponential(unfolding,highbinneddata(:,1))-1); 
singleresidualhigh = highbinneddata(:,2)-ysinglehigh;


 
 % Calculate folding Rate
 i=1;
 lowbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInLowFret(:,1)>binsize*(i-1) & TimesInLowFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 binposition = binsize*i-binsize/2;
 lowbinneddata = [lowbinneddata; [binposition binpribability]];
 end
 folding = mle(lowbinneddata(:,2), 'distribution','exponential');
 
 ysinglelow=(singleexponential(unfolding,lowbinneddata(:,1))); 
 singleresiduallow = lowbinneddata(:,2)-ysinglelow;





%% Plot the Data


figure2 = figure('Color',[1 1 1],'Name', title,'PaperPosition',[0 0 6 5],'papersize',[6 5]);
 
% Plot Unfolding

%Create axes - High FRET dwells
axes1 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.55 0.4 .4],'Parent',figure2,'Visible','on','box','on');
%axes3 = axes('FontName','Arial','FontSize',10,'Position',[0.3 0.55 0.22 .4],'Parent',figure2,'Visible','on','YAxisLocation','right','YColor','black','box','on');

%Added Max 112707 Want To Plot Residuals
axes5 = axes('FontName','Arial','FontSize',10,'Position',[0.1 0.3 0.4 0.2],'Parent',figure2,'Visible','on','box','on');
%axes6 = axes('FontName','Arial','FontSize',10,'Position',[0.3 0.3 0.22 0.2],'Parent',figure2,'Visible','on','YAxisLocation','right','YColor','black','box','on');
%End Added Max 112707 Want To Plot Residuals

ylim(axes1,[0 1.1]);
%ylim(axes3,[0 1.1]);

set(axes3,'YTick', []);
%set(axes6,'YTick', []);

%xlabel(axes1,'Dwell time (s)');
ylabel(axes1,'Normalized counts (cumulative)');
hold(axes1,'all');
%hold(axes3,'all');
 
%%Added Max 112707 Want To Plot Residuals
ylim(axes5,[-0.2 0.2]);
%ylim(axes6,[-0.2 0.2]);
xlabel(axes5,'Dwell time (s)');
ylabel(axes5,'Residuals');
hold(axes5,'all');
%hold(axes6,'all');
%End Added Max 112707 Want To Plot Residuals



%Create scatter
scatter1 = bar(highbinneddata(:,1),highbinneddata(:,2),'Parent',axes1);
%scatter3 = scatter(hightable(:,1),hightable(:,4),'Parent',axes3,'Marker','square','MarkerEdgeColor',[0 0 0],'SizeData',[24],'DisplayName','unfoldingslow');

%Create plot double exponential
%plot1 = plot(xvalueshigh,ydoublehigh,'Color',[0 0 1],'LineWidth',2,'Parent',axes1,'DisplayName','double exponential');
%plot3 = plot(xvalueshigh,ydoublehigh,'Color',[0 0 1],'LineWidth',2,'Parent',axes3,'DisplayName','double exponential');
  
%Create plot single exponential
plot2 = plot(highbinneddata(:,1),ysinglehigh,'Color',[1 0 0],'LineWidth',2,'Parent',axes1,'DisplayName','single exponential');
%plot4 = plot(xvalueshigh,ysinglehigh,'Color',[1 0 0],'LineWidth',2,'Parent',axes3,'DisplayName','single exponential');

%Creat plot of residuals
%This cell was added by Max Greenfeld on 112707 To Plot Residuals

plot5 = scatter(highbinneddata(:,1),singleresidualhigh,'Parent',axes5,'DisplayName','double exponential','Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
%plot5a = scatter(xvalueshigh,doubleresidualhigh,'Parent',axes6,'DisplayName','double exponential','Marker','square','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
%plot6 = scatter(xvalueshigh,singleresidualhigh,'Parent',axes5,'DisplayName','single exponential','Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24]);
%plot6a = scatter(xvalueshigh,singleresidualhigh,'Parent',axes6,'DisplayName','single exponential','Marker','square','MarkerEdgeColor',[1 0 0],'SizeData',[24]);

% Adjust x limits
% middley = find ((10*hightable(:,4)') <= 7.5);
% middley = find ((10*hightable(:,4)') <= 7.5);  %not bad
% middley=max(middley);
% 
% if middley <= 4
%     middley = 4;
% end
% xaxisbreak = hightable(middley,1);
% % set(axes1,'XTick'
% xlim(axes1,[0 xaxisbreak]);
% %xlim(axes3,[xaxisbreak/2 longestdwellhigh+1]);
%adjusts tick marks and labels

% Redone by Max...I could not get the orrigional work
% currentticks = get(axes1,'XTick');
% for j=1:numel(currentticks)
%     
%     if currentticks(j) < xaxisbreak/2;
%      newticks(j)= currentticks(j)
%     end  
% end
% set(axes1,'XTick', newticks);
% 
% xlim(axes5,[0 xaxisbreak]);
% xlim(axes6,[xaxisbreak/2 longestdwellhigh+1]);
% 
% currentticks = get(axes5,'XTick');
% for j=1:numel(currentticks)
%     
%     if currentticks(j) < xaxisbreak/2;
%      newticks(j)= currentticks(j)
%     end  
% end
% set(axes5,'XTick', newticks);
% 
% betterticks =[xaxisbreak/2 get(axes3,'XTick')];
% set(axes3,'XTick', betterticks);
% 
% betterticks =[xaxisbreak/2 get(axes6,'XTick')];
% set(axes6,'XTick', betterticks);

% Plot Folding

%Create axes - Low FRET dwells
axes2 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.55 0.4 0.4],'Parent',figure2,'box','on');
%axes4 = axes('FontName','Arial','FontSize',10,'Position',[0.78 0.55 0.22 0.4],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');

%Added Max 112707 Want To Plot Residuals
axes7 = axes('FontName','Arial','FontSize',10,'Position',[0.59 0.3 0.4 0.2],'Parent',figure2,'box','on');
%axes8 = axes('FontName','Arial','FontSize',10,'Position',[0.78 0.3 0.22 0.2],'Parent',figure1,'Visible','on','YAxisLocation','right','YColor','black','box','on');
%End Added Max 112707 Want To Plot Residuals

%set(axes4,'YTick', []);
%set(axes8,'YTick', []);

ylim(axes2,[0 1.1]);
%ylim(axes4,[0 1.1]);
%xlabel(axes2,'Dwell time (s)');
ylabel(axes2,'Normalized counts (cumulative)');
hold(axes2,'all');
%hold(axes4,'all');

%Added Max 112707 Want To Plot Residuals
ylim(axes7,[-0.2 0.2]);
%ylim(axes8,[-0.2 0.2]);
xlabel(axes7,'Dwell time (s)');
ylabel(axes7,'Residuals');
hold(axes7,'all');
%hold(axes8,'all');
%End Added Max 112707 Want To Plot Residuals

% Create scatter
scatter2 = bar(lowbinneddata(:,1),lowbinneddata(:,2),'Parent',axes2);
%scatter4 = scatter(lowtable(:,1),lowtable(:,4),'Parent',axes4,'Marker','o','SizeData',[24],'MarkerEdgeColor',[0 0 0],'DisplayName','foldingslow');
         
%Create plot double exponential
plot1 = plot(xvalueslow,ydoublelow,'Color',[0 0 1],'LineWidth',2,'Parent',axes2,'DisplayName','double exponential');
%plot3 = plot(xvalueslow,ydoublelow,'Color',[0 0 1],'LineWidth',2,'Parent',axes4,'DisplayName','double exponential');
 
%Create plot single exponential
plot2 = plot(xvalueslow,ysinglelow,'Color',[1 0 0],'LineWidth',2,'Parent',axes2,'DisplayName','single  exponential');
%plot4 = plot(xvalueslow,ysinglelow,'Color',[1 0 0],'LineWidth',2,'Parent',axes4,'DisplayName','single  exponential');

plot7 = scatter(xvalueslow,doubleresiduallow,'Parent',axes7,'DisplayName','double exponential','Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
%plot7a = scatter(xvalueslow,doubleresiduallow,'Parent',axes8,'DisplayName','double exponential','Marker','o','MarkerEdgeColor',[0 0 1],'SizeData',[24]);
%plot8 = scatter(xvalueslow,singleresiduallow,'Parent',axes7,'DisplayName','single exponential','Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24]);
%plot8a = scatter(xvalueslow,singleresiduallow,'Parent',axes8,'DisplayName','single exponential','Marker','o','MarkerEdgeColor',[1 0 0],'SizeData',[24]);

% make it look nice
% % Adjust x limits
% middley = find ((10*lowtable(:,4)') <= 7.5);
% middley=max(middley);
% 
% % set(axes1,'XTick'
% if middley <= 4
%     middley=4;
% end
% xaxisbreak = lowtable(middley,1);
% xlim(axes2,[0 xaxisbreak]);
% xlim(axes4,[xaxisbreak/2 longestdwelllow+1]);
% 
% currentticks = get(axes2,'XTick');
% clear newticks
% for j=1:numel(currentticks)
%     
%     if currentticks(j) < xaxisbreak/2;
%      newticks(j)= currentticks(j)
%     end  
% end
% set(axes2,'XTick', newticks);
% 
% xlim(axes7,[0 xaxisbreak]);
% xlim(axes8,[xaxisbreak/2 longestdwelllow+1]);
% 
% currentticks = get(axes7,'XTick');
% for j=1:numel(currentticks)
%     
%     if currentticks(j) < xaxisbreak/2;
%      newticks(j)= currentticks(j)
%     end  
% end
% set(axes7,'XTick', newticks);
% 
% betterticks =[xaxisbreak/2 get(axes3,'XTick')];
% %set(axes4,'XTick', betterticks);
% 
% betterticks =[xaxisbreak/2 get(axes6,'XTick')];
% %set(axes8,'XTick', betterticks);

%create annotation labels
a = ['k = ' num2str(round(100*singlefithigh)/100)];
b = ['A1 = ' num2str(round(100*doublefithighval(1))/100)];
c = ['k1 = ' num2str(round(100*doublefithighval(2))/100)];
d = ['A2 = ' num2str(round(100*doublefithighval(3))/100)];
e = ['k2 = ' num2str(round(100*doublefithighval(4))/100)];
f = [num2str(timetotalhigh) ' s'];
g = [num2str(totaldwellshigh) ' dwells'];
h = ['# Molecules = ' num2str(numbermolecules)];


% Create textbox
annotation1 = annotation(figure1,'textbox','Position',[0.1 0.1 0.1 0.1],'FitHeightToText','on','String',{a,b,c,d,e,},'LineStyle','none');
annotation3 = annotation(figure1,'textbox','Position',[0.25 0.1 0.1 0.1],'FitHeightToText','on','String',{f,g,h},'LineStyle','none');
annotation5 = annotation(figure1,'textbox','Position',[0.15 0.7 0.3 0.3],'String','Unfolding','LineStyle','None','FontSize',18);    

%create annotation labels
a = ['k = ' num2str(round(100*singlefitlow)/100)];
b = ['A1 = ' num2str(round(100*doublefitlowval(1))/100)];
c = ['k1 = ' num2str(round(100*doublefitlowval(2))/100)];
d = ['A2 = ' num2str(round(100*doublefitlowval(3))/100)];
e = ['k2 = ' num2str(round(100*doublefitlowval(4))/100)];
f = [num2str(timetotallow) ' s'];
g = [num2str(totaldwellslow) ' dwells'];
h = ['# Molecules = ' num2str(numbermolecules)];

% Create textbox
annotation2 = annotation(figure1,'textbox','Position',[0.59 0.1 0.1 0.1],'FitHeightToText','on','String',{a,b c,d e},'LineStyle','none');
annotation4 = annotation(figure1,'textbox','Position',[0.79 0.1 0.1 0.1],'FitHeightToText','on','String',{f,g,h},'LineStyle','none');
annotation6 = annotation(figure1,'textbox','Position',[0.65 0.7 0.3 0.3],'String','Folding','LineStyle','None','FontSize',18);  
%output answer

output = [concentration, singlefithigh doublefithighval, singlefitlow doublefitlowval timetotalhigh totaldwellshigh timetotallow totaldwellslow ];
%%%% Fit the Data Noncumulative

 TimesInHighFret = sort(highfretdwells)';
 TimesInLowFret = sort(lowfretdwells)';

 binsize = (1/fps)*3; %sec
 binstop = TimesInHighFret(size(TimesInHighFret,1),1);
 eventprobability = 1/size(TimesInHighFret,1);

 % Calculate Unfolding Rate
 i=1;
 highbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInHighFret(:,1)>binsize*(i-1) & TimesInHighFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 highbinneddata = [highbinneddata; binpribability];
 end
 unfolding = mle(highbinneddata, 'distribution','exponential');
 
 
 % Calculate folding Rate
 i=1;
 lowbinneddata = [];
 for i = 1:((binstop/binsize))
 
 A=find (TimesInLowFret(:,1)>binsize*(i-1) & TimesInLowFret(:,1)<binsize*i);
 binpribability = size(A,1)*eventprobability;
 lowbinneddata = [lowbinneddata; binpribability];
 end
 folding = mle(lowbinneddata, 'distribution','exponential');









%% So the code don't stop




folding = mle(lowbinneddata, 'distribution','exponential');

 
 
 
 
 
 
 
 
 
 
 