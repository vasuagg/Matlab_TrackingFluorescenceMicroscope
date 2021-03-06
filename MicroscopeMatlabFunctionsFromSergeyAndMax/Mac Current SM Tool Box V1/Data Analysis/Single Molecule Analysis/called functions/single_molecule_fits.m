function  output = single_molecule_fits(finaldata,finalrawdata,fps,minimumlifetime)
%


%For Simulations
%finaldata = allmlecules;
%end of input variables

% This first secton removes creates a vector with the header and footer
% removed so bulk kinetic anaiysis can be done latter on

bulkdata = finaldata;
headerposition = find(bulkdata(:,1)==-9);
bulkdata(headerposition,:)=[];
footerposition = find(bulkdata(:,1)==9);
bulkdata(footerposition,:)=[];


rawbulkdata = finalrawdata;
headerposition = find(rawbulkdata(:,1)==-9);
rawbulkdata(headerposition,:)=[];
footerposition = find(rawbulkdata(:,1)==9);
rawbulkdata(footerposition,:)=[];


% End making bulk data

numberrows = size(finaldata,1);

%Reduing the earlier section more efficienty
% this will basicly creat individual kinetics files

tempdewells = [];
singletracesummary=[];

for j=1:numberrows;    
    
    if finaldata(j,1)== 9 
       
        if finaldata(j,4)== 9; %finaldata(j,4)== 9 this can be used for scoring in the future
            A=tempdewells(2:end,:); % change of variables grabed code from kinanyfps2residuals
            tempsignaltonoise = tempdewells(1,4);
            tempmeanintensity = tempdewells(1,3);
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
            

        if (timetotalhigh+timetotallow) > minimumlifetime;
        
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
        
        tempdltg=-1.987*293*log(equilibrium)/1000;

        
        
        
        %   fit with single and double exponenetials
options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',1000,'TolX',1e-9,'MaxIter',1000,'Display','Final');

%unfolding
[singlefithigh resnormhighsingle]= lsqcurvefit(@singleexponential,[0.001],hightable(:,1),hightable(:,4));
resnormhighsingle
xvalues=hightable(:,1);
ysingle=(singleexponential(singlefithigh,xvalues));
meanunfoldingresidual = mean(hightable(:,4)-ysingle);      

unfoldingreslduals = hightable(:,4)-ysingle;      
concatlength=500-size(ysingle,1);
newunfoldingreslduals = [ unfoldingreslduals' zeros(1, concatlength)];
newunfoldingxvalues = [ xvalues' zeros(1, concatlength)];

[doublefithigh, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.01],hightable(:,1),hightable(:,4),[0 0.1 0.1],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
resnormhigh
ydouble=(doubleexponential(doublefithigh,xvalues))
doubleunfoldingreslduals = hightable(:,4)-ydouble; 
newdoubleunfoldingreslduals = [ doubleunfoldingreslduals' zeros(1, concatlength)];
%Check that doublefithigh in in the right order if they are not correct
if doublefithigh(2)<doublefithigh(3)
    tempslow = doublefithigh(2);
    tempfast = doublefithigh(3);
    tempamp  = 1-doublefithigh(3);
    doublefithigh(1,1:3) =[tempamp tempfast tempslow];
end


%folding
[singlefitlow, resnormlowsingle] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
resnormlowsingle
xvalues=lowtable(:,1);
ysingle=(singleexponential(singlefitlow,xvalues));
meanfoldingresidual = mean(lowtable(:,1)-ysingle);


foldingreslduals = lowtable(:,4)-ysingle;      
concatlength=500-size(ysingle,1);
newfoldingreslduals = [ foldingreslduals' zeros(1, concatlength)];
newfoldingxvalues = [ xvalues' zeros(1, concatlength)];

[doublefitlow, resnormhigh] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],lowtable(:,1),lowtable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
resnormhigh
ydouble=(doubleexponential(doublefitlow,xvalues));
doublefoldingreslduals = lowtable(:,4)-ydouble; 
newdoublefoldingreslduals = [ doublefoldingreslduals' zeros(1, concatlength)];
%Check that doublefithigh in in the right order if they are not correct
if doublefitlow(2)<doublefitlow(3)
    tempslow = doublefitlow(2);
    tempfast = doublefitlow(3);
    tempamp  = 1-doublefitlow(3);
    doublefitlow(1,1:3) =[tempamp tempfast tempslow];
end
    




       
% single trace summary is a summary carrying 
 tempsummary =[tempdltg,tracelength,singlefithigh,doublefithigh,singlefitlow,doublefitlow ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals, tempsignaltonoise, tempmeanintensity, meanhighfret, meanlowfret];
%tempsummary =[tempdltg,tracelength,singlefithigh,meanunfoldingresidual,singlefitlow,meanfoldingresidual ,newunfoldingxvalues,newunfoldingreslduals, newdoubleunfoldingreslduals, newfoldingxvalues, newfoldingreslduals,newdoublefoldingreslduals];
           
        singletracesummary = [singletracesummary;tempsummary];
       
        
        clear x;
        clear tempdewlls;
        tempdewells = [];
        j=j+1;
        
        else
        clear x;
        clear tempdewlls;
        tempdewells = [];
        j=j+1;
        end

        else 
        clear x;
        clear tempdewlls;
        tempdewells = [];
        j=j+1;
        end  
        
    continue 
    
    else
        tempdewells=[tempdewells; finaldata(j,:)];
        
        continue        
    end
end


numberofmolecules  = size(singletracesummary,1);

meanfractionfolede = mean(singletracesummary(:,1));
meantracelength    = mean(singletracesummary(:,2));
meankfold    = mean(singletracesummary(:,3));
meankunfold    = mean(singletracesummary(:,5));


sorted= sortrows(singletracesummary,1);



output = {numberofmolecules,meanfractionfolede,meantracelength,meankfold,meankunfold, sorted,bulkdata,rawbulkdata};