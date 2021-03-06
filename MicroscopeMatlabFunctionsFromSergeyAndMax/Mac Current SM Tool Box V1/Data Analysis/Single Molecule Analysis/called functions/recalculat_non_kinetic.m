function recalculated = recalculat_non_kinetic(data,xtalk, recalculate_dlt_G, new_trace_length,dltG_method,threshold_point,...
    recalculate_signal_to_noise,noise_cutoff,intensit_threshold)
 

%the following section will recalculate the dltaG for each molecule by
%fitting the trace two a two state gausian and it will not use more data
%than specified by the new_trace_length parameter.  For traces that are
%longer than the desired length, the two raw data files will be trimed down
%in a linear fashion


recalculated = data;
cat(2,recalculated,cell(size(data,1),2))



runsection = strcmp(recalculate_dlt_G, 'yes');
    
if  runsection == 1;

i=1;
while i <= size(recalculated,1) 
    
    temptrace       = [];
    temptrace       = [];
    %tempkinetics    = [];
    tempfret=[];
    fps = recalculated{i,5};
    trace_size= fps *new_trace_length;
    
    temptrace    = recalculated{i,10}; 
    %tempkinetics = recalculated{i,11}; 

    if size(temptrace,1) > trace_size;        
        
        temptrace((trace_size+1):end,:)    =[]; 
        %tempkinetics((trace_size+1):end,:) =[];
    end
    
    
    tempfret = (temptrace(:,1)-xtalk*temptrace(:,2))./(temptrace(:,2)+temptrace(:,1)-xtalk*temptrace(:,2));
    
    anomolous = find(tempfret < -0.1 | tempfret > 1.1);
    tempfret(anomolous) =[];
     

    runsection = strcmp(dltG_method, '2gausian');
if  runsection == 1;

    lowerbound = [0 0 0 0 0.3 0 ];
    upperbound = [10000 .5 .6 10000 1 .6 ];
    tweak = [100 0.15 0.1 100 0.8 0.15];
    options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
    
   
    [tempy tempx] = hist(tempfret,50);
    histfit=lsqcurvefit(@gauss2,tweak,tempx,tempy,lowerbound,upperbound,options);
    
    equilibrium = histfit(4)/histfit(1);
   
end
    
runsection = strcmp(dltG_method, 'threshold');
if  runsection == 1;
    
    highposition = find(tempfret > threshold_point);
    highfret = tempfret(highposition);
    tempfret(highposition) = [];
    lowfret  = tempfret;   
    equilibrium = size(highfret,1)/size(lowfret,1);
end
   

     if    equilibrium == 0;
           equilibrium = 0.0000001;
        end
        if equilibrium == Inf;
           equilibrium = 10^7;
        end
        
         dltg=-1.987*293*log(equilibrium)/1000;
         
         recalculated{i,10} = temptrace;
         recalculated{i,28} = histfit;
         %recalculated{i,11} = tempkinetics;
         recalculated{i,12} = dltg;
      
         i=i+1;
end
end



runsection = strcmp(recalculate_signal_to_noise, 'yes');

if runsection == true
    
   
for i =1:size(recalculated,1) 
    
    % Max Improvized Method
    temptrace    = [];
    temptrace    = recalculated{i,10}; 
    total_intensity =        (temptrace(:,2)+temptrace(:,1)-xtalk*temptrace(:,2));
    
    lowerbound = [0 0 0  ];
    upperbound = [10000000 20000 30000  ];
    tweak = [ 1000 2000 1000 ];
    options = optimset('LevenbergMarquardt','on','TolFun',0.000000000001,'MaxFunEvals',1000000,'TolX',1e-9,'MaxIter',1000,'Display','Final');
    
   
    [tempy tempx] = hist(total_intensity,20);
    histfit=lsqcurvefit(@gauss1,tweak,tempx,tempy,lowerbound,upperbound,options);
    
    noise_bound = histfit(3)*noise_cutoff;
 
signal_positions = find(total_intensity <= (histfit(2)+ noise_bound) & total_intensity >= (histfit(2)-noise_bound));
    

    signal = total_intensity(signal_positions);
    total_intensity(signal_positions)=[];
    noise =  total_intensity;
    
    signal_to_noise = size(signal,1) / size(noise,1);
   
    % END Max
    
    %Sergey Method...Currently (101208) in trace viewer 

total_I = total_intensity';

total_I_signal = [];
total_I_av = total_I;
ind_max = find(total_I,1,'last');%SergeyDec2007 made averaging before finding Imax, should avoide spikes better
for ind=20:(ind_max-10)
    if total_I(ind)>intensit_threshold%SERGEY - threshold for "real" signal, still better use human judgement here
        total_I_signal = [total_I_signal total_I(ind)];
    end
  total_I_av(1,ind) = sum(total_I(1,ind:ind+9))/10;%Sergey replaced with forward running average over 10 points
%(total_I(ind-2)+total_I(ind-1)+total_I(ind)+total_I(ind+1)+total_I(ind+2))/5;
end

%SERGEY try calculating SNR here
[total_I_hist,total_I_out] = hist(total_I_signal,30);

for p=2:30
    total_I_hist(p) = total_I_hist(p-1)+total_I_hist(p);
end
total_I_hist = total_I_hist/total_I_hist(30);
total_I_middle = total_I_out(find(total_I_hist>=0.5,1,'first'));
total_I_sigma = (total_I_out(find(total_I_hist>=0.83,1,'first')) - total_I_out(find(total_I_hist>=0.17,1,'first')))/2;

SNR = total_I_middle/total_I_sigma;
    
    
     %recalculated{i,29} = [recalculated{i,24} SNR signal_to_noise];
     recalculated{i,24} = [recalculated{i,24} SNR signal_to_noise];
    
    
    
    total_I_signal = [];
    
    
    
    
end
    
    
    
    
end




















 output=recalculated;