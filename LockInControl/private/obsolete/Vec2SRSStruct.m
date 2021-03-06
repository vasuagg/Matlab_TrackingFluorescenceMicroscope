function SRSStruct = Vec2SRSStruct(axy, az)

% Vectors returned from srsctrl mex files have the following format: 
% a = [ instrument id tag; 0 -> SR810, 1 -> SR830, 2 -> SR850;
%       reference frequency in Hz; 
%       reference phase in degrees;
%       Gain index (need lookup table to convert to human-readable form)
%       Time Constant index (need lookup table)
%       Slope index (0 -> 6db/octave, 1 -> 12dB/octave, ...)
%       Reserve mode index (need lookup table, depends on instrument type)
%       Reserve index (manual reserve, SR850 only)
%       X offset (in percent of 10V output range)
%       Y offset (same)


SRSStruct = struct('FreqXY', axy(2),...
                   'FreqZ', az(2),...
                   'PhaseXY', axy(3),...
                   'PhaseZ', az(3),...
                   'GainXY', axy(4),...
                   'GainZ', az(4),...
                   'TcXY', axy(5),...
                   'TcZ', az(5),...
                   'SlopeXY', axy(6),...
                   'SlopeZ', az(6),...
                   'ReserveModeXY', axy(7),...
                   'ReserveModeZ', az(7),...
                   'ReserveXY', axy(8),...
                   'OffsetX', axy(9),...
                   'OffsetY', axy(10),...
                   'OffsetZ', az(9));
               
return;