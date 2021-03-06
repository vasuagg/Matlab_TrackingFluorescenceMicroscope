function [DCOEFF,NEFF]=fcs_singleparticle_Dfit(tau,g,omega,xi,td0,plotTag)
if not(nargin==5 || nargin==6)
    error('Syntax error : invalid number of arguments. Type "help fcs_beamfit" for usage.');
else
    f2fit=@(beta,t) g2(t,beta(1),beta(2),xi);
    a0=g(1);
    beta0=[a0,td0];
    BETA=nlinfit(tau,g,f2fit,beta0,statset('MaxIter',200));
    DCOEFF=omega^2/(4*BETA(2));
    NEFF=1/BETA(1);
    if (nargin==6 & plotTag)
        figure, semilogx(tau,g,tau,f2fit(BETA,tau));
    end
end
end

function y=g2(t,A,td,xi)
y=A*((1+t/td).^(-1)).*((1+(xi^2)*t/td).^(-1/2));
end
 