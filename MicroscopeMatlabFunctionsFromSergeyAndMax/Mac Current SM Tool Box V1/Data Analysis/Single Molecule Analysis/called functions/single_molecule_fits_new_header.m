function  output = single_molecule_fits_new_header(finaldata,finalrawdata,fps,groupnumber,new_names)
%


%For Simulations
%finaldata = allmlecules;
%end of input variables

% This first secton removes creates a vector with the header and footer
% removed so bulk kinetic anaiysis can be done latter on

% bulkdata = finaldata;
% while find(bulkdata(:,1)==-9   & bulkdata(:,2)==-9);
% headerposition = find(bulkdata(:,1)==-9   & bulkdata(:,2)==-9);
% bulkdata(headerposition:(headerposition+9),:)=[];
% end
% footerposition = find(bulkdata(:,1)==9);
% bulkdata(footerposition,:)=[];


% rawbulkdata = finalrawdata;
% headerposition = find(rawbulkdata(:,1)==-9  & rawbulkdata(:,2)==-9);
% while find(rawbulkdata(:,1)==-9  & rawbulkdata(:,2)==-9);
% headerposition = find(rawbulkdata(:,1)==-9  & rawbulkdata(:,2)==-9);
% rawbulkdata(headerposition:(headerposition+9),:)=[];
% end
% footerposition = find(rawbulkdata(:,1)==9);
% rawbulkdata(footerposition,:)=[];
% 
% 090808 New Strategy Alignt the matricies before doing anything
finaldata;
finalrawdata;
kinetic_data ={};
temp_kinetic_data = finaldata;
while find(temp_kinetic_data(:,1)==-9   & temp_kinetic_data(:,2)==-9);
headerposition = find(temp_kinetic_data(:,1)==-9   &temp_kinetic_data(:,2)==-9);

if size(headerposition,1)> 1;
kinetic_data = [kinetic_data; {temp_kinetic_data((headerposition):(headerposition(2)-2),:)}];
temp_kinetic_data(headerposition:(headerposition+9),:)=[];
else
kinetic_data = [kinetic_data; {temp_kinetic_data((headerposition):(end-1),:)}];    
temp_kinetic_data(headerposition:(headerposition+9),:)=[];
end
end
%footerposition = find(bulkdata(:,1)==9);
%bulkdata(footerposition,:)=[];

raw_data ={};
temp_raw_data = finalrawdata;
while find(temp_raw_data(:,1)==-9   & temp_raw_data(:,2)==-9);
headerposition = find(temp_raw_data(:,1)==-9   &temp_raw_data(:,2)==-9);

if size(headerposition,1)> 1;
raw_data = [raw_data; {temp_raw_data((headerposition+10):(headerposition(2)-2),:)}];
temp_raw_data(headerposition:(headerposition+9),:)=[];
else
raw_data = [raw_data; {temp_raw_data((headerposition+10):(end-1),:)}];    
temp_raw_data(headerposition:(headerposition+9),:)=[];
end
end

data = [raw_data, kinetic_data];

% Check the alignment

% for i=1:size(data,1)
%     
% temp_klength =data{i,2}; 
% temptracelength = sum(temp_klength(11:end,2));
% if temptracelength ~= size(data{i,1},1)-1 % there can be a slight counting error
% %tell=size(data{i,1},1)-1
% str0 = 'Place of Failure'
% str1 = strcat('group number=', num2str(groupnumber));
% str2 = strcat('donor_acceptor_defmlc File', new_names(1));
% str3 = strcat('kinetics_defmlc File', new_names(2));
% strvcat(str0, str1,str2{1},str3{1})
%   
% error('alignment error frame in raw trace different than kinetics')
% 
% end
% temp_klength=[];
% end

% End making bulk data

numberrows = size(data,1);

%Reduing the earlier section more efficienty
% this will basicly creat individual kinetics files

tempdewells = [];
singletracesummary=[];
newsingletracesummary={};

for j=1:numberrows;    


    str0 = 'current trace'
    str1 = strcat('group number=', num2str(groupnumber));
    str2 = strcat('donor_acceptor_defmlc File', new_names(1));
    str3 = strcat('kinetics_defmlc File', new_names(2));
    str4 = strcat('trace number=', num2str(j));
    strvcat(str0, str1,str2{1},str3{1},str4)
    
    
    
            tempdewells = [];
            tempdewells = data{j,2};
            
            A=tempdewells(11:end,:); % change of variables grabed code from kinanyfps2residuals
            
            acceptorpositionx = tempdewells(1,3);
            acceptorpositiony = tempdewells(1,4);
                        
            
            temp_name = new_names{1};
            tems = findstr(new_names{1},'(')
            teme = findstr(new_names{1},')')
            
            movie_ser = str2num(temp_name((tems(2)+1):(teme(2)-1)));
            movidnumber = tempdewells(2,2);
            tracenumber = tempdewells(2,3);
            %fps = tempdewells(2,4);
            
            tempmeanintensity = tempdewells(3,3);
            tempsignaltonoise = tempdewells(3,4);
    % then sort it
sorted= sortrows(A,1);
    % find the low/high breakpoint
low = find(sorted,1) - 1;
    % create a low fret array
lowsorted = sorted(1:low,:);
    %create the high fret array
highsorted = sorted(low+1:end,:);
    %switch refolding

meanhighfret =[];
meanlowfret  =[];   
meanhighfret = mean(highsorted(:,3));
meanlowfret  = mean(lowsorted(:,3));
    % find the frequency data
    % grab the dwells times into a single array, and divide by the frame rate
highfretdwells = highsorted(:,2)'/fps;
lowfretdwells = lowsorted(:,2)'/fps;
   %create a the bin centers vectors from 0 to a value

    % get a table of frequency data
    
    
hightable = tabulatebetter(highfretdwells);
lowtable = tabulatebetter(lowfretdwells);

longestdwellhigh = max(hightable(:,1));
longestdwelllow  = max(lowtable(:,1));
    
    %total length of dwells
timetotalhigh   = sum(highsorted(:,2))/fps;    
timetotallow    = sum(lowsorted(:,2))/fps;

    %number of dwells
totaldwellshigh = size(highsorted,1);
totaldwellslow  = size(lowsorted,1);
            

      %  if (timetotalhigh+timetotallow) > minimumlifetime;
        
        tracelength          =  timetotalhigh+timetotallow;
        tempfractionhighfret =  timetotalhigh/tracelength;
        equilibrium = tempfractionhighfret/(1-tempfractionhighfret);
        
        %Reasign the equlibrium constant to extreme but real values forthe molecule
        %the never fold
        if equilibrium == 0;
           equilibrium = 0.0000001;
        end
        if equilibrium == Inf;
           equilibrium = 10^7;
        end
        
         dltg=-1.987*293*log(equilibrium)/1000;

    
        
        %   fit with single and double exponenetials
options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',...
    1000,'TolX',1e-9,'MaxIter',1000,'Display','Final');

%unfolding
[singlefithigh resnormhighsingle unfoldingreslduals ]= lsqcurvefit(@singleexponential,[0.001],...
    hightable(:,1),hightable(:,4));
singlefithigh = [singlefithigh resnormhighsingle];
unfoldingxvalues=hightable(:,1);
ysingle=(singleexponential(singlefithigh,unfoldingxvalues));

%meanunfoldingresidual = mean(hightable(:,4)-ysingle);      
%unfoldingxvalues = xvalues;

%unfoldingreslduals = hightable(:,4)-ysingle;      

% concatlength=500-size(ysingle,1);
% newunfoldingreslduals = [ unfoldingreslduals' zeros(1, concatlength)];
% newunfoldingxvalues = [ xvalues' zeros(1, concatlength)];


[doublefithigh, resnormhigh doubleunfoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.01],...
    hightable(:,1),hightable(:,4),[0 0.1 0.1],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
doublefithigh = [doublefithigh resnormhigh];
ydouble=(doubleexponential(doublefithigh,unfoldingxvalues));

%doubleunfoldingreslduals = hightable(:,4)-ydouble; 
%newdoubleunfoldingreslduals = [ doubleunfoldingreslduals' zeros(1, concatlength)];
%Check that doublefithigh in in the right order if they are not correct
if doublefithigh(2)<doublefithigh(3)
    tempslow = doublefithigh(2);
    tempfast = doublefithigh(3);
    tempamp  = 1-doublefithigh(1);
    doublefithigh(1,1:3) =[tempamp tempfast tempslow];
end

  
%folding
[singlefitlow, resnormlowsingle foldingreslduals] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
%resnormlowsingle
singlefitlow = [singlefitlow resnormlowsingle];
foldingxvalues=lowtable(:,1);
ysingle=(singleexponential(singlefitlow,foldingxvalues));
%meanfoldingresidual = mean(lowtable(:,1)-ysingle);
%foldingxvalues = xvalues;
%foldingreslduals = lowtable(:,4)-ysingle;      
% concatlength=500-size(ysingle,1);
% newfoldingreslduals = [ foldingreslduals' zeros(1, concatlength)];
% newfoldingxvalues = [ xvalues' zeros(1, concatlength)];


[doublefitlow, resnormhigh doublefoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],...
    lowtable(:,1),lowtable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
%resnormhigh
doublefitlow = [doublefitlow resnormhigh];
ydouble=(doubleexponential(doublefitlow,foldingxvalues));
%doublefoldingreslduals = lowtable(:,4)-ydouble; 
%newdoublefoldingreslduals = [ doublefoldingreslduals' zeros(1, concatlength)];
%Check that doublefithigh in in the right order if they are not correct
if doublefitlow(2)<doublefitlow(3)
    tempslow = doublefitlow(2);
    tempfast = doublefitlow(3);
    tempamp  = 1-doublefitlow(1);
    doublefitlow(1,1:3) =[tempamp tempfast tempslow];
end
    
 %       end

% I Might want the donor and acceptor positins in the fugure...and if so I
% want them in a specif place in the cell...so these are just place holders
% for the moment.
    donorpositionx = 0;
    donorpositiony = 0;

       
% single trace summary is a summary carrying 
 %tempsummary =[tempdltg,tracelength,singlefithigh,doublefithigh,singlefitlow,doublefitlow ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals, tempsignaltonoise, tempmeanintensity, meanhighfret, meanlowfret];
newtempsummary = {
    groupnumber,...
    movie_ser,...
    movidnumber,...
    tracenumber,...
    fps,...
    acceptorpositionx,...
    acceptorpositiony,...
    donorpositionx,...
    donorpositiony,...
    data{j,1},...
    data{j,2},...
    dltg,...
    tracelength,...
    singlefithigh,...
    doublefithigh,...
    singlefitlow,...
    doublefitlow,...
    unfoldingxvalues,...
    unfoldingreslduals,... 
    doubleunfoldingreslduals,...
    foldingxvalues,...
    foldingreslduals,...
    doublefoldingreslduals,...
    tempsignaltonoise,...
    tempmeanintensity,... 
    meanhighfret,... 
    meanlowfret
   };





%tempsummary =[tempdltg,tracelength,singlefithigh,meanunfoldingresidual,singlefitlow,meanfoldingresidual ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals];
           
     %  singletracesummary = [singletracesummary;tempsummary];
       newsingletracesummary = cat(1,newsingletracesummary, newtempsummary);
        
        end
        

    
 
  



% numberofmolecules  = size(singletracesummary,1);
% 
% meanfractionfolede = mean(singletracesummary(:,1));
% meantracelength    = mean(singletracesummary(:,2));
% meankfold    = mean(singletracesummary(:,3));
% meankunfold    = mean(singletracesummary(:,5));
% 
% 
% sorted= sortrows(singletracesummary,1);



output =  newsingletracesummary;
    