%   MSDFIT  fits theoretical curves to mean-squared deviation curves
%   extracted from tracking data.
%
%   [D_fit, n_fit, gammavec_fit, L] = msdfit(ndim, dt, dx, dy, dz);
%
%   See also msd3d, msdfit2
function fit = msdfit_zk_1(dt,dx,dy,dz,beta_i);



if nargin==4
    for j=1:1:3
        beta_i(j,1)=3.5;
        beta_i(j,2)=0.02;
        beta_i(j,3)=20*2*pi;
        
    end

end
g_z=@g_1;
%check=beta_i(4)^2-4*beta_i(3)*beta_i(4)
beta_estX = nlinfit(dt, dx, @g_1, beta_i(1,:));
beta_estY = nlinfit(dt, dy, @g_1, beta_i(2,:));
beta_estZ = nlinfit(dt, dz, @g_1, beta_i(3,:));

fit(1).D=beta_estX(1);fit(1).n=beta_estX(2);fit(1).gammaC=beta_estX(3);
%fit(1).L = sqrt(fit(1).D * (fit(1).gammaC+fit(1).gammaP) + fit(1).n^2.*fit(1).gammaC/2);

fit(2).D=beta_estY(1);fit(2).n=beta_estY(2);fit(2).gammaC=beta_estY(3);
%fit(2).L = sqrt(fit(2).D * (fit(2).gammaC+fit(2).gammaP) + fit(2).n^2.*fit(2).gammaC/2);

fit(3).D=beta_estZ(1);fit(3).n=beta_estZ(2);fit(3).gammaC=beta_estZ(3);
%fit(3).L = sqrt(fit(3).D * (fit(3).gammaC+fit(3).gammaP) + fit(1).n^2.*fit(3).gammaC/2);


figure; 
% 
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k');
% semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'k', dt, dy, 'g', dt, g_xy(beta_y, dt), 'k');
semilogx(dt, dx, 'b', dt, g_z(beta_estX, dt), '--b','LineWidth',2);
hold on;
semilogx(dt, dy, 'g', dt, g_z(beta_estY, dt), '--g','LineWidth',2);
semilogx(dt, dz, 'r', dt, g_z(beta_estZ, dt), '--r','LineWidth',2);

%semilogx(dt, dx, 'b', dt, g_xy(beta_x, dt), 'b', dt, dy, 'g', dt, g_xy(beta_y, dt), 'g', dt, dz, 'r', dt, g_z(beta_z, dt), 'r');

%fit.L = find_L(fit.D, fit.n, gammavec_fit);



return;

function y = g_1(beta, t);
D = beta(1);
n = beta(2);
gamma_c = beta(3);

y = D - D/gamma_c*(1-n^2*gamma_c^2/(2*D))*(1-exp(-gamma_c*t))./t;

return;

function y = g_2(beta, t);

D = beta(1);
n = beta(2);
gamma_c = beta(3);
gamma_p = beta(4);

nu = sqrt(gamma_p^2 - 4*gamma_c*gamma_p);

a=nu-gamma_p;
b=nu+gamma_p;

y=D-D./t.*(1/nu).*(exp(a*t/2)-exp(-b*t/2))-(D./t).*(1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)).* (0.5*exp(a*t/2)+0.5*exp(-b*t/2)+gamma_p*(1/nu)*0.5*(exp(a*t/2)-exp(-b*t/2))-1);
%  y = D - D./t .* (2./nu*sinh(nu*t/2).*exp(-gamma_p*t/2) + (1/gamma_p - 1/gamma_c + n^2*gamma_c/(2*D)) .* ...
%           (-1 + exp(-gamma_p*t/2).*(cosh(nu*t/2) + gamma_p/nu*sinh(nu*t/2))));
return;
