% [Gamma, Xs] = sim2fcs(t, Xcm, Xprobe, gam, n, w);
% 
function [Gamma, Xs] = sim2fcs(t, Xcm, Xprobe, gam, n, w, sig0);

dt = t(2)-t(1);

N = (n*ones(size(t)))*sqrt(dt).*randn(size(Xcm, 1), size(t, 2));

Xs = zeros(size(Xcm));

Xs(:, 1) = Xcm(:, 1) + sig0 .* randn(3, 1);

for u = 1:length(t),
    tt = t(u) - t(1:u);
    Xs(:, u) = Xs(:, 1) .* exp(-gam*t(u)) + dt*gam.*sum(exp(-gam*tt).*(N(:, 1:u) + Xcm(:, 1:u)), 2);
end;

Gamma = 0;
for j = 1:length(Xprobe),
    Gamma = Gamma + exp(-2*sum((Xs-Xprobe{j}).^2./(w.^2*ones(1, size(Xs, 2))), 1));
end;

return;