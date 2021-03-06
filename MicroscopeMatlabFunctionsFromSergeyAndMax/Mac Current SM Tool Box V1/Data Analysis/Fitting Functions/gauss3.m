function y = gauss3(x,xdata)
%two peaks, fit to a gaussian distribution equation for use in least squares fitter
% Y = a1*exp(-((x-b1/c1)^2)+a2*exp(-((xdata-b2)/c2)^2)\n');
% y=y0 + (A/(w*sqrt(PI/2)))*exp(-2*((x-xc)/w)^2)
% in origin this works
% 250*exp(-(((x-3)^2)/5))+150*exp(-(((x-8)^2)/5))

% y = (x(1)*exp(-(((xdata-x(2)).^2)/((2*x(3))^2))))+(x(4)*exp(-(((xdata-x(5)).^2)/((2*x(6))^2))));

% y= (x(1)+x(2)^2+x(3)+x(4)+x(5)+x(6))*xdata.^2;
%[1cmplitude 1center 1stdev 2cmplitude 2center 2stdev]

y=(x(1)/(x(3)*sqrt(pi/2)))*exp(-2*(((xdata-x(2)).^2)/(x(3).^2)))+...
  (x(4)/(x(6)*sqrt(pi/2)))*exp(-2*(((xdata-x(5)).^2)/(x(6).^2)))+...
  (x(7)/(x(9)*sqrt(pi/2)))*exp(-2*(((xdata-x(8)).^2)/(x(9).^2)));

% y=(x(3)/(x(2)*sqrt(pi/2)))*exp(-2*(((xdata-x(3)).^2)/(x(2).^2)))+(x(6)/(x(5)*sqrt(pi/2)))*exp(-2*(((xdata-x(6)).^2)/(x(5).^2)));