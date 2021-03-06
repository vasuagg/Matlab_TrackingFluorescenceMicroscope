function  output = kbleach_April08(prefix,filenumber1,filenumberlast)
% Calculates total lifetime of the molecule in high fluorescence state
k=1;
TimeTotal(1,1) = 0;
Kin = [];
for i=filenumber1:filenumberlast
    filename = strcat(prefix, 'cascade', num2str(i),'(4).dat');
    try
        KinTemp = importdata(filename);
        Kin=[Kin;KinTemp];
    catch
        strcat('error, possibly file ',filename,'  missing')
    end
end

for j=2:(length(Kin))

    if Kin(j,1)~=9
%                 
        TimeTotal(k,1) = TimeTotal(k,1) + (isfinite(Kin(j,2))*Kin(j,2));

    elseif Kin(j,2)~=9
        k=k+1;
        TimeTotal(k,1) = 0;
    %elseif Kin(j,2)==9    
    end


end

newfilename = strcat('kbleach(',num2str(filenumber1),'_',num2str(filenumberlast),').dat');
fid = fopen(newfilename,'w');
fprintf(fid,'%d\n',TimeTotal');
fclose(fid)
