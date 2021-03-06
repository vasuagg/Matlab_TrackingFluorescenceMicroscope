% COMPUTEFCS    Computes the FCS curve corresponding to the input data.
%    [G, TAU] = COMPUTEFCS( I, dt ) returns the FCS-style autocorrelation
%    G of the input intensity vector I, where the time-spacing of I is dt,
%    and the corresponding correlation time vector TAU.
%
%    [G, TAU] = COMPUTEFCS( I, dt ,taumax) returns the same autocorrelation
%    calculated for lags <= taumax. N.B. this doesn't strongly affect the
%    calculation time -- length(I) dominates that.

function [g, tau] = computeFCS( I, dt ,tmax),

if( (nargin ~= 2) & (nargin ~= 3) ),
    error( '2 or 3 Input arguments required!' );
end;

if nargin == 2;
    maxlags = length(I);
elseif nargin == 3;
    maxlags = floor(tmax/dt);
end;

% KEVIN - I CHANGED THE NORMALIZATION BELOW!
g_temp = xcorr( I -mean(I), maxlags, 'unbiased' )/mean(I)^2;
%g_temp = xcorr( I -mean(I), 'coeff' )/mean(I)^2;

g = g_temp( (ceil(end/2)+1) : end ); 
tau = (1:(length(g)))*dt;

return;



