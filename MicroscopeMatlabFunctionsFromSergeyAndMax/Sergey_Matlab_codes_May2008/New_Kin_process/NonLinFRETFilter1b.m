function output = NonLinFRETFilter1b(filenumber1,filenumberlast,K,M,p)
%This script will implement G. Harans's (Chem.Phys. 307,137, (2004))
%algorithm for non-liner filtering of FRET data.
%

for ind=filenumber1:filenumberlast
    filename = strcat('cascade', num2str(ind),'(4)','.traces');
    try
        fid=fopen(filename);
        length = fread(fid,1,'int32');
        
        NumberTraces = fread(fid,1,'int16');
        Data = fread(fid,[NumberTraces+1 length],'int16');
        fclose(fid);
        size(Data);
%         Data(3,100:120);
        Data_dF = zeros(length, K);
        Data_dB = zeros(length, K);
        Data_aF = zeros(length, K);
        Data_aB = zeros(length, K);
%         
%         f = ones(length,window);
%         b = ones(length,window);
        
        for N=2:2:NumberTraces
%             Data_dF = Data;
%             Data_dB = Data;
%             Data_aF = Data;
%             Data_aB = Data;
              f=[];
              b=[];
            for i = (2^K)+1:(length-(2^K)-1)
                for k=1:K
                    
                    Data_dF(i,k)=(1/2^K)*sum(Data(N,(i-(2^K)):(i-1)));
                    Data_dB(i,k)=(1/2^K)*sum(Data(N,(i+1):(i+(2^K))));
                    Data_aF(i,k)=(1/2^K)*sum(Data(N+1,(i-(2^K)):(i-1)));
                    Data_aB(i,k)=(1/2^K)*sum(Data(N+1,(i+1):(i+(2^K))));
                end
                %OK, the above loop works correctly
            end
          
            for i = M+2:(length-M-2)
                for k=1:K
%                    
                      for j=0:M-1
                        fpart(j+1) = (Data(N,i-j)-Data_dF(i-j,k) + Data(N+1,i-j)-Data_aF(i-j,k))^2;
                        bpart(j+1) = (Data(N,i-j)-Data_dB(i-j,k) + Data(N+1,i-j)-Data_aB(i-j,k))^2;
                      end
%                     
                    f(i,k) = sum(fpart)^-p;
                    b(i,k) = sum(bpart)^-p;
                    
                end
%                
            end
            
            Cnorm = (sum(f,2)+sum(b,2)).^-1;
            Cnorm(1:M+1) = 0;
            for k=1:K
                f(:,k) = f(:,k).*Cnorm(:);
                b(:,k) = b(:,k).*Cnorm(:);
            end
%             f
%             b
%             Cnorm
%             return
            
            f=[f;zeros(M+2,K)];
            b=[b;zeros(M+2,K)];
            size(f);
            size(Data_aB);
            size(f.*Data_aB);
%             return
            
                Temp_dData = sum(f.*Data_dF,2) + sum(b.*Data_dB,2);
                Temp_aData = sum(f.*Data_aF,2) + sum(b.*Data_aB,2);
                
%             
           
%            Data(N,:) = Temp_dData;
%             return
%             size(Temp_dData(M+2:(length-M-2)))
%             return
            for i = M+2:(length-M-2)
            Data(N,i) = Temp_dData(i);
            Data(N+1,i) = Temp_aData(i);
            end
            size(Data);
            
        end
         size(Data);
%          return
    %Data(3,100:120)
    outputfilename = strcat('(NLFF1b',num2str(K),',',num2str(M),',',num2str(p),')cascade',num2str(ind),'(4).traces');
    %outputfilename = strcat('(NLFF',num2str(window),',',num2str(M),',',num2str(p),')test.traces');

    fid = fopen(outputfilename,'w');
    fwrite(fid,length,'int32');
    fwrite(fid,NumberTraces,'int16');
    fwrite(fid,Data,'int16');
    fclose(fid);
    catch
        output = strcat('No file named ', filename, ' found, or something else is wrong')
    end
end