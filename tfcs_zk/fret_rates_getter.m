% %% new analysis using the correct data format.
% cd('Y:\ZKData\2011\012911\CyHP_NewSample_1nM_30uWLaser_Casein');
% load 31-Oct-2011-3.mat;
% cs=g2;
% [tau3,csn]=fcs_cut(tau,fcs_N(tau,g2,1e-2),1e-6);
% cd('Y:\ZKData\2011\012911\CyHP_RealControl_1nM_30uWLaser_Casein');
% load 31-Oct-2011-2.mat;
% ct=g2;
% [tau3,g2c]=fcs_cut(tau,fcs_N(tau,g2,1e-2),1e-6);







function fret_rates_getter(sample,control)

for j=1:1:8
    if j~=7
        ctn{j,4}=g2c{j,4}(:,:);
        %temp{j,1}=mean(temp{j,4});
        ctn{j,1}=g2c{j,1};
        
        ctn{j,5}=g2c{j,5}(:,:);
        %temp{j,2}=mean(temp{j,5});
        ctn{j,2}=g2c{j,2};
        ctn{j,6}=g2c{j,6}(:,:);
        %temp{j,3}=mean(temp{j,6});
        ctn{j,3}=g2c{j,3};
        ctn{j,7}=strcat(g2c{j,7},',control');
    else
        
        ctn{j,4}=g2c{j,4}(:,:);
        %ctn{j,1}=mean(g2c{j,4});
        ctn{j,1}=g2c{j,1};
        
        ctn{j,5}=g2c{j,5}(:,:);
        %ctn{j,2}=mean(g2c{j,5});
        ctn{j,2}=g2c{j,2};
        
        ctn{j,6}=g2c{j,6}(:,:);
        %ctn{j,3}=mean(g2c{j,6});
        ctn{j,3}=g2c{j,3};
        
        ctn{j,7}=strcat(g2c{j,7},',control');
    end
        
end
%so now c_salt.com is combined control and sample at different salt, from
%1uS to 1S. 
clear c_salt;
t_normalize=10^-3.5;
for j=1:1:8
    c_salt(j).com=fcs_N(addfcs(ctn,csn,j,j),t_normalize);
end

%fit control.
for j=1:1:8
    c_salt(j).dif_fit=FCS_diffusion_fit(tau3,c_salt(j).com{1,5},1,pi*1^2/0.532,[0 0],'xyz');
end

%get dynamics data by chopping.
t_tide=10^-3;
%t_tide=10^-2.4;
for j=1:1:8
    thry=c_salt(j).dif_fit.thry;
 
    t_index=min(find(tau3>t_tide));
    tauc=tau3(1:t_index);
    for k=1:1:size(c_salt(j).com{2,4},1)
        %c_salt(j).ady(k,:)=c_salt(j).com{2,4}(k,1:t_index)./thry(1:t_index)-1;
        c_salt(j).ady(k,:)=c_salt(j).com{2,4}(k,1:t_index)./c_salt(j).com{1,2}(1:t_index)-1;
        c_salt(j).ddy(k,:)=c_salt(j).com{2,5}(k,1:t_index)./c_salt(j).com{1,2}(1:t_index)-1;
        c_salt(j).xdy(k,:)=c_salt(j).com{2,6}(k,1:t_index)./c_salt(j).com{1,2}(1:t_index)-1;
    end
%     
%     for k=1:1:size(c_salt(j).com{2,5},1)
%         %c_salt(j).ddy(k,:)=c_salt(j).com{2,5}(k,1:t_index)./thry(1:t_index)-1;
%         c_salt(j).ddy(k,:)=c_salt(j).com{2,5}(k,1:t_index)./c_salt(j).com{1,2}(1:t_index)-1;
%     end
end

%fit dynamics.
%figure;
clear fa fd;
for j=1:1:4
    %subplot(2,4,j);
    fa(j)=FCS_twostate_fit(tauc,c_salt(j+4).ady,[0 0]);
end
for j=1:1:4
   % subplot(2,4,j+4);
   fd(j)=FCS_twostate_fit(tauc,c_salt(j+4).ddy,[0 0]);
end

%solve the rates. 

for j=1:1:4
    syms A1pi1
    jj=j+4;
    %these are the initial constants for me to solve the rates. 
    AA=fa(j).amp;
    FRET=co129.oldFRET(jj);
    %FRET=[0.40 0.45 0.42 0.43 0.50 0.60 0.70 0.80];
    kt(j)=(fa(j).rate+fd(j).rate)/2;
    stdkt(j)=(0.25*fa(j).stdrate^2+0.25*fd(j).stdrate^2)^0.5;
    %kt(j)=fa(j).rate;
    %stdkt(j)=fa(j).stdrate;
    D0=2.5;
    s(j)=solve(sprintf('%f-((1-pi1)/pi1)*(1-(%f-A1)/A1)^2/(1+(1-pi1)*(%f-A1)/pi1/A1)^2',AA,D0,D0), ...
    sprintf('%f-(pi1*A1+(1-pi1)*(%f-A1))/(%f)',FRET,D0,D0), ...
    'pi1','A1');

    Aopen(j)=s(j).A1(2);
    p1(j)=s(j).pi1(2);
    p2(j)=1-s(j).pi1(2);
    
    rate12(j)=kt(j)*p2(j);
    std_rate12(j)=stdkt(j)*p2(j);
    rate21(j)=kt(j)*p1(j);
    std_rate21(j)=stdkt(j)*p1(j);
end



%% plotting.

% for j=1:1:3
%     subplot(2,3,j);hold all;
%     error_zk(tau3,c_salt(plot_N(j)).com{1,5},'b');
%     plot(log10(tau3),c_salt(plot_N(j)).dif_fit.thry,'b','LineWidth',2);
%     error_zk(tau3,c_salt(plot_N(j)).com{2,4},'g');
%     error_zk(tau3,c_salt(plot_N(j)).com{2,5},'r');
%     jj=plot_N(j)-4;
%     
%     if jj>0
%         adythry=fa(jj).amp.*exp(-fa(jj).rate.*tau3);
%         ddythry=fd(jj).amp.*exp(-fd(jj).rate.*tau3);
%         %plot(log10(tau3),c_salt(plot_N(j)).com{1,2}.*(adythry+1),'g','LineWidth',2);
%         %plot(log10(tau3),c_salt(plot_N(j)).com{1,2}.*(ddythry+1),'r','LineWidth',2);
%         plot(log10(tau3),c_salt(plot_N(j)).dif_fit.thry.*(adythry+1),'g','LineWidth',2);
%         plot(log10(tau3),c_salt(plot_N(j)).dif_fit.thry.*(ddythry+1),'r','LineWidth',2);
%     end
%     
% end
plot_N=[5,7,8];
for j=1:1:3
    jj=plot_N(j)-4;
    figure(j);clf;
    error_zk(fa(jj).tau,fa(jj).g2,'r');
    hold all;
    error_zk(fd(jj).tau,fd(jj).g2,'b');
    plot(log10(tauc),fa(jj).thry,'r','LineWidth',2);
    plot(log10(tauc),fd(jj).thry,'b','LineWidth',2);
    legend('HP3-Acceptor','HP3-Donor')
    axis([-6 -3 -0.05 0.35])
    xlabel('Log(tau)[S]','FontSize',14);
    ylabel('Correlation [AU.]','FontSize',14);
end

% 
% subplot(2,3,4);
% errorbar(log10([50 150 250 500]),[fa.rate],[fa.stdrate],'--or');
% hold on;
% errorbar(log10([50 150 250 500]),[fd.rate],[fd.stdrate],'--ob')
% subplot(2,3,5);
% errorbar(log10([50 150 250 500]),[fa.amp],[fa.stdamp],'--or');
% hold on;
% errorbar(log10([50 150 250 500]),[fd.amp],[fd.stdamp],'--ob');
figure(4);clf
bar(log10([25 50 150 250 500]),[1 0;p1(1) p2(1);p1(2) p2(2);p1(3) p2(3);p1(4) p2(4)],'stack');
axis([1.5 3 0 1])
xlabel('Log([NaCl]) (mM)','FontSize',14);
ylabel('State Population Fraction','FontSize',14);



figure(5);clf;
errorbar(log10(salt(1:1:8)),co129.oldFRET,co129.oldstdFRET,'--or','MarkerFaceColor','r','MarkerSize',6);
xlabel('Log([NaCl]) (mM)','FontSize',14);
axis([0 3 0 1]);
axis auto-y
ylabel('FRET Effiency','FontSize',14)



figure(6);clf;
errorbar(log10([50 150 250 500]),rate12,std_rate12,'--or','MarkerFaceColor','r','MarkerSize',6);
hold on;
errorbar(log10([50 150 250 500]),rate21,std_rate21,'--ob','MarkerFaceColor','b','MarkerSize',6);
legend('closing rate','opening rate');
xlabel('Log([NaCl]) (mM)','FontSize',14);
ylabel('Rate Constants(S^{-1})','FontSize',14)
axis([1.5 3 1000 5500]);
axis auto-y;
