%diffusion coefficient of Qdots in um^2/s
D=5;
%laser xy dimension in um
w_xy=0.65;
%laser z dimension in um
%w_z=2;
w_z=pi*w_xy^2/0.532;


%number of Qdots in laser focal volume. 
N=1;

tau_xy=w_xy^2/(4*D);
tau_z=w_z^2/(4*D);



t=logspace(-6,0,120);




%these A1 A2 B1 B2 here are to take care of integration done in the g2tau
%from Laurance Method.
for j=1:1:(length(t)-1)
    to=t(j+1)-t(j);
    
    logA1=log((tau_z-tau_xy)^0.5+(tau_z+t(j))^0.5);
    logA2=log((tau_z-tau_xy)^0.5-(tau_z+to+t(j))^0.5);
    
    logB1=log((tau_z-tau_xy)^0.5-(tau_z+t(j))^0.5);
    logB2=log((tau_z-tau_xy)^0.5+(tau_z+to+t(j))^0.5);
    
    g2t_normalized(j)=(1/N)*(tau_xy/to)*(tau_z/(tau_z-tau_xy))^0.5*(logA1+logA2-logB1-logB2);
end

g2t_normalized(length(t))=g2t_normalized(length(t)-1);

g2t=(1/N)*(1./(1+t/tau_xy)).*(1./(1+t/tau_z).^0.5);

    
 figure(1);clf;hold all;   
for j=1:1:1    
    ThreeStateGG=ThreeState_DD2(t,10^3,10^3,10^4,10^2,100,50,0);

    %total_g2=(g2t+1).*TwoStateGG-1;
    total_g2=(g2t).*TwoStateGG;
     % total_g2=TwoStateGG-1;
    semilogx(t,g2t,'k')
     semilogx(t,total_g2,'r')
    
end

set(gca,'Xscale','log')

% figure(2);clf;
% semilogx(t,g2t,'ok')
% set(gca,'Xscale','log')
% hold all;
% for j=1:2:10    
%     TwoStateGG=TwoState_DD2(t,j*10^3,1*10^2,10);
% 
%     %total_g2=(g2t+1).*TwoStateGG-1;
%     total_g2=(g2t).*TwoStateGG;
%      %total_g2=TwoStateGG-1;
%     semilogx(t,total_g2)
% end
% 
% set(gca,'Xscale','log')
% 


%semilogx(t,g2t_normalized,'r')

% T=triangularwave(20*10^3,t);
% 
% 
% total_g2=g2t.*T;
% 
% subplot(1,2,2);
% 
% semilogx(t,total_g2)
% 


