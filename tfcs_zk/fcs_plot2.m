%function fcs_ADX looks into t g2 and plot fcs curves. 
%if 'sample' is the plot condition, then it will plot a figure for each
%sample with acceptor, donor and cross fcs curves. 
%if 'compare' is the plot condition, it will plot raw and normalized fcs
%curves across different samples specified by the vector N. 
function fcs_plot2(list,g2,N)

lightcolor=[204,204,255;204,255,204;255,204,204;204,255,255;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;
darkcolor=[0 0 1;0 1 0;1 0 0;0 1 1;1 0 1;1 1 0;0 0 0];
lightcolor=[204,204,255;204,255,204;255,204,204;153,255,204;255,204,255;255,255,204;204,204,204];
lightcolor=lightcolor/255;



if nargin==2
    N=1:1:size(g2,1);
    plot_type='compare';
end


if nargin==3
    plot_type='compare';
end




    figure;
    title('Acceptor');
    hold all;

    
    for j=1:1:length(N)
        if j<8
            shadedErrorBar_zk(t,g2{N(j),4},{'Color',darkcolor(j,:),'LineWidth',2});
        elseif j<15
            shadedErrorBar_zk(t,g2{N(j),4},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',2});
            %ciplot_zk(t,g2{N(j),4},j-7,'--');
        else
            shadedErrorBar_zk(t,g2{N(j),4},{'Color',darkcolor(j-14,:),'LineStyle','-.','LineWidth',2});
        end
        
        %set(gca,'Xscale','log');
        my_L{j}=g2{N(j),7};
        xlabel('Tau [S]', 'FontSize', 14);
        ylabel('Correlation [A.U.]', 'FontSize', 14);
    end

    box on;legend(my_L);grid on;
    %fcs_normalizer(-1,1,t_tide,-1,my_L)

    figure;title('Donor');
    hold all;
    for j=1:1:length(N)
        if j<8
            %semilogx(t,g2{N(j),2});
            %ciplot_zk(t,g2{N(j),5},j);
            shadedErrorBar_zk(t,g2{N(j),5},{'Color',darkcolor(j,:),'LineWidth',2});

            
       elseif j<15
            shadedErrorBar_zk(t,g2{N(j),5},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',2});
            %ciplot_zk(t,g2{N(j),4},j-7,'--');
        else
            shadedErrorBar_zk(t,g2{N(j),5},{'Color',darkcolor(j-14,:),'LineStyle','-.','LineWidth',2});
        end

        
        xlabel('Tau [S]', 'FontSize', 14);
        ylabel('Correlation [A.U.]', 'FontSize', 14);
        my_L{j}=g2{N(j),7};
    end
    
    box on;legend(my_L);grid on;
    %fcs_normalizer(-1,1,t_tide,-1,my_L)
    
    
    figure;
    title('cross');
    hold all;
    for j=1:1:length(N)
        if j<8
            %semilogx(t,g2{N(j),2});
            %ciplot_zk(t,g2{N(j),6},j);
            shadedErrorBar_zk(t,g2{N(j),6},{'Color',darkcolor(j,:),'LineWidth',2});

        elseif j<15
            shadedErrorBar_zk(t,g2{N(j),6},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',2});
            %ciplot_zk(t,g2{N(j),4},j-7,'--');
        else
            shadedErrorBar_zk(t,g2{N(j),6},{'Color',darkcolor(j-14,:),'LineStyle','-.','LineWidth',2});
        end

       
        xlabel('Tau [S]', 'FontSize', 14);
        ylabel('Correlation [A.U.]', 'FontSize', 14);
        my_L{j}=g2{N(j),7};
    end
    box on;legend(my_L);grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%
if size(g2,2)>10  
    figure;
    title('tracking');
    hold all;
    for j=1:1:length(N)
        if j<8
            %semilogx(t,g2{N(j),2});
            %ciplot_zk(t,g2{N(j),6},j);
            shadedErrorBar_zk(t,g2{N(j),9},{'Color',darkcolor(j,:),'LineWidth',2});

        else
            %semilogx(t,g2{N(j),2},'--');
            %ciplot_zk(t,g2{N(j),6},j-7,'--')
            shadedErrorBar_zk(t,g2{N(j),9},{'Color',darkcolor(j-7,:),'LineStyle','--','LineWidth',2});

        end
        xlabel('Tau [S]', 'FontSize', 14);
        ylabel('Correlation [A.U.]', 'FontSize', 14);
        my_L{j}=g2{N(j),7};
    end
    box on;legend(my_L);
end
    