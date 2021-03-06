function fit=FCS_threestate_fit(tau,g2,plot_flag)
lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;

    
f2fit=@(para,tau) FCS_threestate(tau,para(1),para(2),para(3),para(4));

%amplitude of the exp guess
para_1_guess=0.1;
%rates guess
para_2_guess=1000;
para_3_guess=0.1;
para_4_guess=5000;

if size(g2,1)~=1
     %get the average value and weights
    [tau,ave_g2,std_g2,h]=draw_fcs(tau,g2,1,0);
     %set weights as 1/sigma^2.
     w=1./std_g2.^2;
     %weight the data. 
     wg2=w.^0.5.*ave_g2;
     %weight the model function
     f2fit=@(para,tau) w.^0.5.*FCS_threestate(tau,para(1),para(2),para(3),para(4));
     %fitting    
%      figure;plot(log10(tau),wg2);

    [para_fit,r,J,sigma]=nlinfit(tau,wg2,f2fit,[para_1_guess,para_2_guess,para_3_guess,para_4_guess]);
    %generate c.i. for the fitting parameters
    ci=nlparci(para_fit,r,'jacobian',J);
    %output results
    fit.amp1=para_fit(1);fit.stdamp1=ci(1,2)-para_fit(1);
    fit.k1=para_fit(2);fit.stdk1=ci(2,2)-para_fit(2);
    fit.amp2=para_fit(3);fit.stdamp2=ci(3,2)-para_fit(3);
    fit.k2=para_fit(4);fit.stdk2=ci(4,2)-para_fit(4);
    fit.tau=tau;
    fit.g2=g2;
    fit.thry=FCS_threestate(tau,para_fit(1),para_fit(2),para_fit(3),para_fit(4));
    residues=r;
    fit.r=r;
    
    [hh,pp]=chi2gof(residues);
    fit.h=hh;
    fit.p=pp;
     if ~hh
        disp('Accept Model!')
    else
        disp('Reject Model!')
    end
    
    
    if plot_flag
    figure;hold on;
    
    subplot(4,1,4);
    plot(log10(tau),residues,'*r');
    %axis([tau(1) tau(end) min(residues) max(residues)])
    xlabel('Tau [S]', 'FontSize', 14);
    ylabel('Weighted Residue [A.U.]', 'FontSize', 14);
    
    
    subplot(4,1,1:3)
    shadedErrorBar_zk(tau,g2,{'Color',darkcolor(2,:),'LineWidth',2});hold on;
    plot(log10(tau),FCS_threestate(tau,para_fit(1),para_fit(2),para_fit(3),para_fit(4)),'r','LineWidth',2);
    legend('data','three-state fit');Box on;  
    %axis([tau(1) tau(end) min(min(ave_g2),1) max(ave_g2)])
    xlabel('Tau [S]', 'FontSize', 14);
    ylabel('Correlation [A.U.]', 'FontSize', 14);
        
        
        
        
        
        
        
    end
    
else
    [para_fit,r,J,sigma]=nlinfit(tau,g2,f2fit,[para_1_guess,para_2_guess,para_3_guess,para_4_guess]);
    %ci=nlparci(para_fit,r,'covar',sigma);
    ci=nlparci(para_fit,r,'jacobian',J);
    size(J);
    figure;
    subplot(5,1,1:4)
    semilogx(tau,g2,'-or','MarkerSize',4,'MarkerFaceColor','r');
    hold on;
    semilogx(tau,FCS_threestate(tau,para_fit(1),para_fit(2),para_fit(3),para_fit(4)),'LineWidth',2);
    %title(cd);
    subplot(5,1,5)
    semilogx(tau,r)
end

end

function g2tau=FCS_threestate(t,A1,kk1,A2,kk2)

g2tau=A1.*exp(-kk1.*t)+A2.*exp(-kk2.*t);

end