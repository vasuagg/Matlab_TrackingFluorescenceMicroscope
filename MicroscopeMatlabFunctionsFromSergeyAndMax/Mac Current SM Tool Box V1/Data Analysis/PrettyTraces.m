


% Makes Traces look prety for export


%filename='110807 P4P6 146-149AllU Mg 2mM K 100mM 40ms Cascade47 1of19';
%clipboard('copy','filename');



xstart=0;
xend=250;


figure1=figure(1);

set(figure1,'PaperType','<custom>','PaperSize',[5 3.5],'Name','filename','PaperPosition',[0 0 5 3.5]);



subplot(2,1,1);
xlim([xstart xend]);
ylim([-1 25]);
ylabel('Intensity','FontSize',10);
%title(filename) 

subplot(2,1,2);
xlim([xstart xend]);
ylim([-0.2 1.2]);
ylabel('FRET','FontSize',10);
xlabel('Time [sec]','FontSize',10);



%print


