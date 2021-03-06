
function output = imol_kinetics(temptrace,thresh_spec)


threshold_method = 2;

switch threshold_method
    
    case 1
        
    case 2
        
        
        % The historic Chu version > gui_tracep
        th_param(1)= thresh_spec.threshold;
        th_param(2)= thresh_spec.threshold;   
        thresholded = threshold_std(temptrace,th_param);
        
    case 3
        
        % Max Version work in progress
        th_param(1)= ave_param.table{13,2};
        th_param(2)= ave_param.table{14,2};
        th_param(3)= ave_param.table{12,2};
        thresholded = threshold_max(temptrace,th_param);

end    


thresh_summary.thresholded = thresholded;
%fps = ave_param.table{4,2};


% thresholded data
A = thresholded;


% then sort it
sorted= sortrows(A,1);
% find the low/high breakpoint
low = find(sorted,1) - 1;
 % create a low fret array
lowsorted = sorted(1:low,:);
%create the high fret array
highsorted = sorted(low+1:end,:);
    
% Addigne times to the dwells   
%highfretdwells = highsorted(:,2)'/fps;
%lowfretdwells = lowsorted(:,2)'/fps;
highfretdwells = highsorted(:,2)';
lowfretdwells = lowsorted(:,2)';

% get a table of frequency data    
hightable = tabulatebetter(highfretdwells);
[y x] = ecdf(highfretdwells);
hightable = zeros(size(y,1),4);
hightable(:,1) = x;
hightable(:,4) = y;

lowtable = tabulatebetter(lowfretdwells);
[y x] = ecdf(lowfretdwells);
lowtable = zeros(size(y,1),4);
lowtable(:,1) = x;
lowtable(:,4) = y;


%figure;scatter(hightable(:,1),hightable(:,4)); hold on
[y x] = ecdf(highfretdwells);
y = y+0.01;
%scatter(x,y)


%longestdwellhigh = max(hightable(:,1));
%longestdwelllow  = max(lowtable(:,1));
    
%total length of dwells
%timetotalhigh   = sum(highsorted(:,2))/fps;    
%timetotallow    = sum(lowsorted(:,2))/fps;
%timetotalhigh   = sum(highsorted(:,2));    
%timetotallow    = sum(lowsorted(:,2));


%number of dwells
%totaldwellshigh = size(highsorted,1);
%totaldwellslow  = size(lowsorted,1);
            
 
        
%   fit with single and double exponenetials
options = optimset('LevenbergMarquardt','on','TolFun',0.0000000001,'MaxFunEvals',...
    1000,'TolX',1e-9,'MaxIter',1000,'Display','Final');

% Unfolding
% Fit with single exponential
[singlefithigh resnormhighsingle unfoldingreslduals ]= lsqcurvefit(@singleexponential,[0.001],hightable(:,1),hightable(:,4));
singlefithigh = [singlefithigh resnormhighsingle];
unfoldingxvalues=hightable(:,1);
ysingle=(singleexponential(singlefithigh,unfoldingxvalues));

thresh_summary.k2to1_single = singlefithigh(1);
thresh_summary.k2to1_xval = unfoldingxvalues;
thresh_summary.k2to1_single_yval = ysingle;
thresh_summary.k2to1_single_residuals = unfoldingreslduals;

% Fit with double exponential
%[doublefithigh, resnormhigh doubleunfoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.01],...
 %   hightable(:,1),hightable(:,4),[0 0.1 0.1],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
[doublefithigh, resnormhigh doubleunfoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.01],...
    hightable(:,1),hightable(:,4),[0 0.0001 0.0001],[1 1 1],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)


doublefithigh = [doublefithigh resnormhigh];
ydouble=(doubleexponential(doublefithigh,unfoldingxvalues));

%Check that doublefithigh in in the right order if they are not correct
if doublefithigh(2)<doublefithigh(3)
    tempslow = doublefithigh(2);
    tempfast = doublefithigh(3);
    tempamp  = 1-doublefithigh(1);
    doublefithigh(1,1:3) =[tempamp tempfast tempslow];
end

thresh_summary.k2to1_dobule = doublefithigh(1:3);
thresh_summary.k2to1_dobule_yval = ydouble;
thresh_summary.k2to1_dobule_residuals = doubleunfoldingreslduals;



  
%folding
% Fit with single exponential
[singlefitlow, resnormlowsingle foldingreslduals] = lsqcurvefit(@singleexponential,[1],lowtable(:,1),lowtable(:,4));
singlefitlow = [singlefitlow resnormlowsingle];
foldingxvalues=lowtable(:,1);
ysingle=(singleexponential(singlefitlow,foldingxvalues));

thresh_summary.k1to2_single = singlefitlow(1);
thresh_summary.k1to2_xval = foldingxvalues;
thresh_summary.k1to2_single_yval = ysingle;
thresh_summary.k1to2_single_residuals = foldingreslduals;


% Fit with double exponential
%[doublefitlow, resnormhigh doublefoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],...
%    lowtable(:,1),lowtable(:,4),[0 0.001 0.001],[1 fps fps],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)
[doublefitlow, resnormhigh doublefoldingreslduals] = lsqcurvefit(@doubleexponential,[0.6,3,0.1],...
    lowtable(:,1),lowtable(:,4),[0 0.0001 0.0001],[1 1 1],options); %lsqcurvefit(@function,[GUESSES],xdata,ydata)


doublefitlow = [doublefitlow resnormhigh];
ydouble=(doubleexponential(doublefitlow,foldingxvalues));

%Check that doublefithigh in in the right order if they are not correct
if doublefitlow(2)<doublefitlow(3)
    tempslow = doublefitlow(2);
    tempfast = doublefitlow(3);
    tempamp  = 1-doublefitlow(1);
    doublefitlow(1,1:3) =[tempamp tempfast tempslow];
end


thresh_summary.k1to2_dobule = doublefitlow(1:3);
thresh_summary.k1to2_dobule_yval = ydouble;
thresh_summary.k1to2_dobule_residuals = doublefoldingreslduals;




output =  thresh_summary;

