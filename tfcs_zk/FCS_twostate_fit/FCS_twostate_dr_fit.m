%function fit=FCS_twostate_fit(tau,g2,plot_flag)
function fit=FCS_twostate_dr_fit(varargin)
%% initialize

lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
nargin
if nargin==3
    vector_flag=1;
    tau=varargin{1};
    avg_g2=varargin{2};
    std_g2=varargin{3};
else
    vector_flag=0;
    tau=varargin{1};
    avg_g2=varargin{2};
end


%amplitude of the exp guess
para_1_guess=max(mean(avg_g2));
%rates guess
para_2_guess=10^3;
%% for a vector
if vector_flag
 %set weights as 1/sigma^2.
 w=1./std_g2.^2;
 %weight the data. 
 wg2=w.^0.5.*avg_g2;
 %weight the model function
f2fit=@(para,tau) w.^0.5.*FCS_twostate(tau,para(1),para(2));
[para_fit,residues,J,sigma]=nlinfit(tau,wg2,f2fit,[para_1_guess,para_2_guess]);
%generate c.i. for the fitting parameters
ci=nlparci(para_fit,residues,'jacobian',J);
%output results
fit.amp=para_fit(1);fit.stdamp=ci(1,2)-para_fit(1);
fit.rate=para_fit(2);fit.stdrate=ci(2,2)-para_fit(2);
[hh,pp]=chi2gof(residues);
fit.h=hh;
fit.p=pp;
fit.thry=FCS_twostate(tau,fit.amp,fit.rate);
fit.tau=tau;

if ~hh
    disp('Accept Model!')
else
    disp('Reject Model!')
end

figure;
hold on;
plot(log10(tau),FCS_twostate(tau,para_fit(1),para_fit(2)),'r','LineWidth',2);
%shadedErrorBar_zk(tau,g2,{'Color',darkcolor(2,:),'LineWidth',2});hold on;
plot(log10(tau),avg_g2);
legend('two-state fit','data');Box on;  
%axis([tau(1) tau(end) min(min(ave_g2),1) max(ave_g2)])
xlabel('Tau [S]', 'FontSize', 10);
ylabel('Correlation [A.U.]', 'FontSize', 10);
axis tight;
end
%%
if ~vector_flag
    
    f2fit=@(para,tau) FCS_twostate(tau,para(1),para(2));
    [para_fit,r]=nlinfit(tau,avg_g2,f2fit,[para_1_guess,para_2_guess]);
    fit.parafit=para_fit;
    fit.r=r;
    fit.tau=tau;
    fit.thry=FCS_twostate(tau,para_fit(1),para_fit(2));
    figure;
    %subplot(2,1,1)
    plot(log10(tau),avg_g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
    hold on;
    plot(log10(tau),FCS_twostate(tau,para_fit(1),para_fit(2)),'LineWidth',2);
    %title(cd);
    %subplot(2,1,2)
    %semilogx(tau,r)
end

end

function g2tau=FCS_twostate(t,A,kk)

g2tau=A.*exp(-kk.*t);

end