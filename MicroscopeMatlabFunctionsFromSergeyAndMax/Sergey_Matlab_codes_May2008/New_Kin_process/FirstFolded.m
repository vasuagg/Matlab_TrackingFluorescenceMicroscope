function output = FirstFolded(filename)
%This script will concatenate kinetics matrixes from files with numbers
%given by parameters, and make a histogram of the times each molecule spent
%in first High FRET dwell. 

Kinetics=[];
%for i=filenumber1:filenumberlast
    %filename = strcat('(kinetics)cascade', num2str(i),'(4)','.dat');
    try
        tempdata = importdata(filename);
        Kinetics = [Kinetics;tempdata];
    catch
        errorS = strcat('No file with ', filename, ' name')
    end
%end
max = size(Kinetics);
FirstFoldedHist = [];
Counter = 0;
for j=1:(length(Kinetics)-1)    
    if (Kinetics(j,1)==9)%&&(Kinetics(j,2)~=9)
%         Counter = Counter+1;
        if Kinetics(j+1,1)==3
          if Kinetics(j+2,1)==0  
            FirstFoldedHist = [FirstFoldedHist;Kinetics(j+1,2)];
          else
          end
        elseif Kinetics(j+2,1)==3
            if Kinetics(j+3,1)==0  
                FirstFoldedHist = [FirstFoldedHist;Kinetics(j+2,2)];
            else
            end
            
        end
    else
    end
end
%size(FirstFoldedHist)
%Counter
%return
hist(FirstFoldedHist)
outputfilename = strcat('(1stFoldedChosen(',num2str(filename),').dat');
fid = fopen(outputfilename,'w');
count = fprintf(fid,'%d\n',FirstFoldedHist);
fclose(fid);
        