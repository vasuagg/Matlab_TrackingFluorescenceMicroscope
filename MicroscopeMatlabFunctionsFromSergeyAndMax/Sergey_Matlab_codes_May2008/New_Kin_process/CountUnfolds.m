function output = CountUnfolds(filename,minlength)
%This script will concatenate kinetics matrixes from files with numbers
%given by parameters, and make a histogram of how many times each molecule
%visited Low FRET state. 
%Now works only with "postflow" kinetics files that have 4th column of "time
%after start of the trace"
Kinetics=[];
%for i=filenumber1:filenumberlast
    %filename = strcat(prefix,'(kinetics)',suffix,'cascade', num2str(i),'(4)','.dat');
    try
        tempdata = importdata(filename);
        Kinetics = [Kinetics;tempdata];
    catch
        ans = strcat('No file with ', filename, ' name')
    end
%end

UHist = [];
UnfoldCounter = 0;
for j=2:length(Kinetics)    
    if Kinetics(j,1)~=9
        if Kinetics(j,1)==0
            UnfoldCounter = UnfoldCounter+1;
        else
        end
    else
        if Kinetics(j,2)==9
            if (Kinetics(j-1,4)*Kinetics(1,2)/1000)<minlength
            %TEMPif (Kinetics(j-1,4)*Kinetics(1,2)/1000)>minlength
               UHist = [UHist;UnfoldCounter];
               UnfoldCounter = 0;
            else
               UnfoldCounter = 0;
            end
        end
    end
end
hist(UHist)
outputfilename = strcat('CountU(',filename,'(',num2str(minlength),'s).dat');
fid = fopen(outputfilename,'w');
count = fprintf(fid,'%d\n',UHist);
fclose(fid);
        