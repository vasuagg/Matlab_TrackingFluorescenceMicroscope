function datalist=ABH(rng)
if (nargout==1),    
files=dir('data_*.mat');
filesnamesCell=struct2cell(files);
[a,n]=size(filesnamesCell);
M=zeros(n,1);
    for i=1:n
        cs=filesnamesCell{1,i};
        M(i)=str2num(cs(6:end-4));
    end
M=sort(M);
data2draw=[];    
datalist=[]; ndat = 0;
for i=1:length(rng)
    lastfile=(rng(i)-mod(rng(i),100))+100;
    x=find(M<lastfile & M>=rng);
    data2draw=cat(1,data2draw,M(x));
end
j=1; quitloop=-1; ll=[440   378   560   420]; kk=ll;
while ((j<=length(data2draw))&&(quitloop<0)),
    DrawPlots3D(data2draw(j)); thisfig = gcf; set(thisfig,'Position',ll);
    load(strcat('data_',num2str(data2draw(j)),'.mat'));
    mchoice=0;
    while (mchoice<5),
        mchoice=menu('Options','Record from Fluor','Record from Stages','Record from Power','Erase last record','Next file','Previous file','Quit');
        if ((mchoice==1)||(mchoice==2)||(mchoice==3)),
            figure(thisfig); subplot(3,1,mchoice);
            gg=get(gca,'Xlim');
            if (gg(1)<0),
                gg(1)=0;
            end;
            if (gg(2)>60),
                gg(2)=60;
            end;
            startP=daq_out(find(t0>gg(1),1)); stopP=daq_out(find(t0>gg(2),1));
            MSD3D(data2draw(j),gg(1),gg(2)); MSDfig = gcf; set(MSDfig,'Position',kk);
            nchoice=menu('Options','Input values for this event','Quit without recording this event');
            if (nchoice==1),
                prompt={'Apparent MSD(0.1s):','Uncertainty:'};
                name='Diffusion-coefficient-by-eye';
                numlines=1;
                defaultanswer={'0','0'};
                answerc=inputdlg(prompt,name,numlines,defaultanswer);
                diffco=str2num(answerc{1});
                diffunc=str2num(answerc{2});
                datalist=[datalist; data2draw(j) gg startP stopP diffco diffunc];
                ndat = ndat+1;
            end;
            datalist,
            kk = get(MSDfig,'Position'); close(MSDfig);
        end;
        if ((mchoice==4)&&(ndat>0)),
            datalist = datalist(1:ndat-1,:);
        end;        
        datalist,
    end;
    ll = get(thisfig,'Position'); close(thisfig);
    if (mchoice==6),
        j=j-1;
    elseif (mchoice==7),
        quitloop=1;
    else
        j=j+1;
    end;    
end;
end