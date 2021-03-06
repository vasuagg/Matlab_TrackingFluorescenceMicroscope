% g = corr_Laurence(t, u, tau_mn, tau_mx)
%   Returns the correlation of discrete time vectors t and u evaluated at
%   the points given in tau_mn and tau_mx (left and right bin edges).
%
% g = corr_Laurence(t, u, tau_mn)
%   Uses elements of tau_mn to define both left and right edges.

function [g,g_std] = FCS_compute(t,u,tau_mn,tau_mx);
% tau_mn, tau_mx same size vectors of left edge and right-edge for bins:
% calls corr_Laurence_sub

if nargin<4;
    tau_mx = tau_mn([2:end end]);
end;

t0 = min([min(t) min(u)]);
t = t-t0;
u = u-t0;
g=0*tau_mn;
g_std=0*tau_mn;

[g,g_std]= FCS_core(t,u,tau_mn,tau_mx);

%0*tau_mn;

%for kk = 1:length(tau_mn);
 %   g(kk) = corr_Laurence_sub(t,u,tau_mn(kk),tau_mx(kk));% mexed
%end;