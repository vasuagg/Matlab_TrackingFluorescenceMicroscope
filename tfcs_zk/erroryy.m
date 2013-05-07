function erroryy(x,y1,stdy1,y2,stdy2)

fig=figure;
[AX,H1,H2]=plotyy(x,y1,x,y2);

set(fig,'CurrentAxes',AX(1));
hold on;
errorbar(x,y1,stdy1,'--bo');
set(fig,'CurrentAxes',AX(2));
hold on;
errorbar(x,y2,stdy2,'--ro');