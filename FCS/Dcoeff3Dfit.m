% DCOEFF3DFIT   Fits occupancy and concentration parameters to an input FCS
%               curve.  Fits to the 3-D FCS model.
%    [D, C] = DCOEFF3DFIT( TAU, G, Wxy, Omega ) returns the diffusion
%    coefficient D (in um^2 / ms) and concentration (in units of 
%    occupancy ) fits to the input FCS curve G with corresponding 
%    correlation times T.  The input parameter Wxy is the laser beam 
%    waist (in um) in the transverse direction. The parameter Omega is 
%    the ratio Wz / Wxy, between the axial and transverse beam waists.
%
%    [D, C] = DCOEFF3DFIT( TAU, G, Wxy, Omega, Thresh ) returns the same 
%    fits, but the parameter Thresh specifies an upper limit on the 
%    correlation times to include in the nonlinear fit.
%
%    [D, C] = DCOEFF3DFIT( TAU, G, Wxy, Omega, Thresh, Plot ) plots the real 
%    data and the fit result if Plot == true.
function [D, C] = Dcoeff3Dfit( TAU, G, Wxy, Omega, Thresh, Plot ),

if nargin < 4 | nargin > 6,
    error( 'Between 4 and 6 input arguments required.' );
end;

if nargin >= 5,
    fit_range = find( TAU < Thresh );
    TAU_fit = TAU( fit_range );
    G_fit = G( fit_range );
else
    TAU_fit = TAU;
    G_fit = G;
end;

% Choice of beta0 affects convergence of fit.  If the fit complains about
% ill-conditioning, adjust this parameter.
beta0 = [1e-2 1e-2];

% The easiest way I know of to send a variable to the inline function that
% we use for fitting is to pass is as an element of T.  We create the
% augmented vector T_fit_aug in order to pass the parameter Omega to the 3D
% FCS model, and the augmented vector G_fit_aug in order to complete the
% fit. The first element of the inline function's return value is Omega,
% such that the fit to that element is always exact and the fitting routine
% is not affected.
TAU_fit_aug = [ Omega TAU_fit ];
G_fit_aug = [ Omega G_fit ];

% Perform the fit
beta = nlinfit( TAU_fit_aug, G_fit_aug, ...
    inline( '[ t(1); 1 / beta(1) * (1 + t(2:end) / beta(2)).^-1 .* (1 + t(2:end) / (t(1)^2 * beta(2))) .^-0.5 ]', 'beta', 't' ),...
    beta0 );

% beta(2) as we have defined it is the diffusion time \tau_D, which is
% given by \tau_D = Wxy^2 / ( 4 D ).
D = Wxy^2 / (4 * beta(2)) * 1e-3;

% beta(1) is simply 1 / N, the inverse of the mean occupancy.
C = 1 / beta(1);


if nargin == 6,
    if Plot,
        Dcoeff3DPlotFit( TAU, G, Wxy, Omega, D, C );
    end;
end;
return;