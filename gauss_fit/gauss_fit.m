% GAUSS_FIT  Gaussian fitting
%   [beta, Gaussian] = gauss_fit(x, y) Fits the Gaussian function
%     G(x) = a + b exp( -2 (x-c)^2/d^2)
%   to the (x,y) data provided. Returns beta = [a b c d]. 
%
%   [...] = gauss_fit(x, y, guess) Uses 'guess' as the initial point in the
%   nonlinear fitting routine.  It must be reasonably close to correct in 
%   order to guarantee convergence. Note that guess is generally not required, 
%   but it may be used if the optimal fit is not found automatically.
%
%   [...] = gauss_fit(x,y,guess,plot_fit) Plots the fit to the data if
%   plot_fit == true.
%[beta, Gaussian]= gauss_fit(x, y, guess, plot_fit);
function beta= gauss_fit(x, y, guess, plot_fit);
% Number of steps to use gradient method before switching to Newton method.
% This seems to do a good job of refining the guess to ensure Newton
% convergence.  For some reason, Newton's method alone seems to converge to
% local minima more frequently.
num_gradient_steps = 15;

% Maximum total number of iterations.  50 is probably far more than
% should ever be needed!
MAX_ITER = 50;

if nargin < 2,
    error('At least two arguments required.');
end;

dx=x(2)-x(1);

if nargin == 2,
    guess = [];
end;

if numel(guess) == 0,
    guess = zeros(1,4);
    guess(1) = min(y);
    guess(2) = max(y)-min(y);
    [v,max_ind] = max(y);
    guess(3) = x(max_ind);
    guess(4) = (max(find(y > 0.5*guess(2) + guess(1))) - min(find(y > 0.5*guess(2) + guess(1))))*dx;
    plot_fit = true;
end;

if nargin == 2,
    plot_fit = true;
end;
    
line_search_alpha = 0.2;
line_search_beta = 0.5;
epsilon_stop = 1e-15;

G = inline('beta(1) + beta(2) * exp(-2*(x-beta(3)).^2/beta(4)^2)', 'x', 'beta');

% We perform the fit by minimizing the function 
%   f(beta) = 1/2 int_x (G(x, beta) - y)^2 
% beginning with a simple gradient method, and switching to a Newton method
% after num_gradient_steps.

x = reshape(x, 1, numel(x));
y = reshape(y, 1, numel(y));
guess = reshape(guess, numel(guess), 1);

beta = guess;

grad_f = 1;
newton_decr = 1;
num_iter = 0;
while norm(grad_f) > 1e-10 & newton_decr > 2*epsilon_stop & num_iter < MAX_ITER; 
    a = beta(1);
    b = beta(2);
    c = beta(3);
    d = beta(4);
    
    residual = G(x, beta) - y;
    
    dGda = ones(size(x));
    dGdb = exp(-2*(x-c).^2/d^2);
    dGdc = b*4*(x-c)/d^2 .* dGdb;
    dGdd = b*4*(x-c).^2/d^3 .* dGdb;
    
    grad_G = [dGda; dGdb; dGdc; dGdd];
        
    grad_f = dx*grad_G * residual';
    
    if num_iter > num_gradient_steps,
        Hess = dx*grad_G * grad_G';
    
        Hess(2,3) = Hess(2,3) + sum(4*(x-c)/d^2 .* dGdb .* residual)*dx;
        Hess(2,4) = Hess(2,4) + sum(4*(x-c).^2/d^3 .* dGdb .* residual)*dx;
        Hess(3,3) = Hess(3,3) + sum((16*b*(x-c).^2/d^4 - 4*b/d^2).*dGdb .* residual)*dx;
        Hess(3,4) = Hess(3,4) + sum((16*b*(x-c).^3/d^5 - 8*b*(x-c)/d^3).*dGdb .* residual)*dx;
        Hess(4,4) = Hess(4,4) + sum((16*b*(x-c).^4/d^6 - 12*b*(x-c).^2/d^4).*dGdb .* residual)*dx;

        Hess = triu(Hess) + triu(Hess)' - diag(diag(Hess));

        step_dir = -Hess\grad_f;
        newton_decr = -grad_f'*step_dir;
    else
        step_dir = -grad_f;
    end;
    
    t = 1;
    while dx*sum((G(x, beta + t * step_dir) - y).^2) > dx*sum((G(x, beta) -y).^2) + line_search_alpha * t * grad_f'*step_dir,
        t = t * line_search_beta;
    end;
    beta = beta + t * step_dir;
    num_iter = num_iter + 1;
end;

if num_iter >= MAX_ITER,
    fprintf('Maximum number of iterations reached.\n');
else
    fprintf('Converged in %d iterations.\n', num_iter);
end;

Gaussian = G;
fprintf('Residual: %g\n', dx*sum((G(x, beta)-y).^2));

 if 1,
     figure;
     plot(x, y, 'o', x, G(x, beta));
     legend('data', 'Gaussian fit');
 end;

return;