%this note calculates the fraction of A that bonds to B to form C: 
% A+B-> <- C

%we assume the concentration of the molecules are the same
%the on rate is from one measurement of the QD655 bonds to QD585 withgotoday
%coating ratio of 1, meaning on average one DNA per QD. 
A=10*10^-9;
%on NoteBook3 Page 123.
kon=7*10^4; %M^-1 s^-1


koff=linspace(0,.1,100000); %^s-1





bonded_fraction=(koff+2*kon*A-((koff+2*kon*A).^2-4*kon^2*A^2).^0.5)./(2*kon*A);

%bonded_fraction=(G+R+koff./kon-((R+G+koff./kon).^2-4*R*G).^0.5)/(2*R);



plot(koff,bonded_fraction)