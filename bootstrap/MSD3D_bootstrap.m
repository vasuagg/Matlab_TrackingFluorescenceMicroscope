% function MSD3D_boostrap looks into data_filenum.mat from t1 to t2, and
% use boostrap to generate sets of samples in order to calculate the MSD
% std. All the results are put into dif structure, which contains elements
% like DX,stdDX, DT, and for other two axes too. 
function dif= MSD3D_bootstrap(filenum,t1,t2)
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;

if nargout==1
    plot_flag=0;
end

tstart = 0;
tstop = 3;%log10(1000); %log(T/1ms)
load(sprintf('data_%g', filenum));
ix = find(t0 >= t1 & t0 <= t2);
%ix = (SampRate*varargin{2}):(SampRate*varargin{3});
if ix(1) == 0,
    ix(1) = 1;
end;

x = x0(ix);
y = y0(ix);
z = z0(ix);

dt = 1e-3;
DeltaT = ceil(logspace(tstart,tstop,300));
DiffX = diff(x);
DiffY = diff(y);
DiffZ = diff(z);

% initialization of DX DY and DZ
DX = 0*DeltaT;
DY = DX;
DZ = DX;

% for tt = 1:length(DeltaT),
%     Dt = DeltaT(tt);
%     X_Dt = sum(reshape(DiffX(1:Dt*floor(numel(DiffX)/Dt)), Dt, floor(numel(DiffX)/Dt)), 1);
%     Y_Dt = sum(reshape(DiffY(1:Dt*floor(numel(DiffY)/Dt)), Dt, floor(numel(DiffY)/Dt)), 1);
%     Z_Dt = sum(reshape(DiffZ(1:Dt*floor(numel(DiffZ)/Dt)), Dt, floor(numel(DiffZ)/Dt)), 1);
%     DX(tt) = var(X_Dt)/(2*Dt*dt); %(mean(X_Dt.^2) - mean(X_Dt)^2)/(2*Dt*dt);
%     DY(tt) = var(Y_Dt)/(2*Dt*dt); %(mean(Y_Dt.^2) - mean(Y_Dt)^2)/(2*Dt*dt);
%     DZ(tt) = var(Z_Dt)/(2*Dt*dt); %(mean(Z_Dt.^2) - mean(Z_Dt)^2)/(2*Dt*dt);
% end;

DX=MSD(DiffX);
DY=MSD(DiffY);
DZ=MSD(DiffZ);
dT = DeltaT*dt;

% figure;hold all;
% plot(log10(dT),DX,log10(dT),DY,log10(dT),DZ);
bootss=1;
if bootss
    BN=5;
    msdx_set=bootstrp(BN,@MSD,DiffX);
    msdy_set=bootstrp(BN,@MSD,DiffY);
    msdz_set=bootstrp(BN,@MSD,DiffZ);
    % figure;
    % hold on;
    % plot(log10(dT),msd_set);
    % figure;
    % plot(log10(dT),mean(msd_set));

    % size(msdx_set)
     std_msdx=std(msdx_set);
     std_msdy=std(msdy_set);
     std_msdz=std(msdz_set);

    dif.stdDX=std_msdx;
    dif.stdDY=std_msdy;
    dif.stdDZ=std_msdz;
end
% size(std_msdx)
%plot_flag=1;
if plot_flag
 figure(826493);clf;
 hold all;
 shadedErrorBar_zk_simple(dT,DX,std_msdx,{'Color',darkcolor(1,:),'LineWidth',2});
 shadedErrorBar_zk_simple(dT,DY,std_msdy,{'Color',darkcolor(2,:),'LineWidth',2});
 shadedErrorBar_zk_simple(dT,DZ,std_msdz,{'Color',darkcolor(3,:),'LineWidth',2});
 legend('MSDx','MSDy','MSDz')
 title(sprintf('BN is %g',BN));
end
 
 
%errorbar(log10(dT),DX,std_msdx);
%shadedErrorBar_zk(t,g2{N(j),4},{'Color',darkcolor(j,:),'LineWidth',2});
dif.DX=DX;dif.DY=DY;dif.DZ=DZ;

dif.DT=dT;
end

%% use diffx to generate msdx
function msdx=MSD(difx)
dt=1e-3;
DeltaT = ceil(logspace(0,3,300));
msdx=0*DeltaT;
for ttt = 1:length(DeltaT),
    Dt = DeltaT(ttt);
    X_Dt = sum(reshape(difx(1:Dt*floor(numel(difx)/Dt)), Dt, floor(numel(difx)/Dt)), 1);   
    msdx(ttt) = var(X_Dt)/(2*Dt*dt); %(mean(X_Dt.^2) - mean(X_Dt)^2)/(2*Dt*dt);
end;
%dT = DeltaT*dt;
end
