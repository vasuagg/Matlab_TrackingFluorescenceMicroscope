% [tags, t, x, y, z, NIDAQ_Out] = Capture3D(Timeout, SampRate, NIDAQ_Channels);
%   tags returns fluorescence photon time tags
%   t returns xyz sample times
%   x, y, z return stage position
%   Timeout in seconds, defaults to 10
%   SampRate in Hz, defaults to 1000
%   NIDAQ_Channels is a vector of additional channels (from 3 to 7) to read off 
%       the DAQ board.  Defaults to [].
%   NIDAQ_Out is the NIDAQ data recorded on the additional channels.
%
%   See also acquire, capture3d_mod, rttags, rttrace
%
% Version 1.1 Updated May 15, 2008 by KM
function [tags, t, x, y, z, NIDAQ_Out] = Capture3D(Timeout, SampRate, NIDAQ_Channels);

global LineState;
global ar

if ~length(find(LineState)),
    error('You should probably turn on a detector first.');
end;

chan0 = -1;
if LineState(1) | LineState(2),
    fprintf('Board 0: ');

    if LineState(1) & LineState(2),
        chan0 = 2;
        fprintf('Measuring fluorescence on both APDs.\n');
    else if LineState(1),
            chan0 = 0;
            fprintf('Measuring fluorescence on APD 0\n');
        else if LineState(2),
                chan0 = 1;
                fprintf('Measuring fluorescence on APD 1\n');
            end;
        end;
    end;
end;

chan1 = -1;
if LineState(3) | LineState(4),
    fprintf('Board 1: ');

    if LineState(3) & LineState(4),
        chan1 = 2;
        fprintf('Measuring fluorescence on both APDs.\n');
    else if LineState(3),
            chan1 = 0;
            fprintf('Measuring fluorescence on APD 0\n');
        else if LineState(4),
                chan1 = 1;
                fprintf('Measuring fluorescence on APD 1\n');
             end;
        end;
    end;
end;
    
if nargin < 3,
    NIDAQ_Channels = [];
end;

if find(diff(NIDAQ_Channels) < 0),
    error('NIDAQ_Channels input should be increasing');
end;

if nargin < 2,
    SampRate = 1000;
end;

if nargin == 0,
    Timeout = 10; % default
end;

Timeout = min([Timeout, 100]); % Default maximum, just to prevent accidentally long acquisitions

NIDAQ_Channels = NIDAQ_Channels(find(NIDAQ_Channels > 2 & NIDAQ_Channels < 8));
ReadChan = [0:2, NIDAQ_Channels];

ar = SetupAnalogRead(ReadChan, SampRate, Timeout);

%TriggerAnalogRead(ar); % 8/19/08 Trigger is now done by rttags().

if chan0 > -1 & chan1 > -1,
    numChan = 2 + (chan0 == 2) + (chan1 == 2)
    if numChan == 2,
        [time0, time1] = rttags_sync(2e7, Timeout, chan0, chan1);
        tags = {time0, time1};
    else if numChan == 3,
            [time0, time1, time2] = rttags_sync(2e7, Timeout, chan0, chan1);
            tags = {time0, time1, time2};
        else if numChan == 4,
                [time0, time1, time2, time3] = rttags_sync(2e7, Timeout, chan0, chan1);
                tags = {time0, time1, time2, time3};
            end;
        end;
    end;
end;

if chan0 > -1 & chan1 == -1,
    chan = chan0;
    if chan == 2,
        [tags0, tags1] = rttags(0, 2e7, Timeout, chan);
        tags = {tags0, tags1};
    else
        tags0 = rttags(0, 2e7, Timeout, chan);
        tags = {tags0};
    end;
end;

if chan0 == -1 & chan1 > -1,
    chan = chan1;
    if chan == 2,
        [tags0, tags1] = rttags(1, 2e7, Timeout, chan);
        tags = {tags0, tags1};
    else
        tags0 = rttags(1, 2e7, Timeout, chan);
        tags = {tags0};
    end;
end;

data = GetAnalogData(ar);

x = data(:, 1) * 10;
y = data(:, 2) * 10;
z = data(:, 3) * 4;
t = (0:(length(x)-1))./SampRate;

NIDAQ_Out = data(:, 4:end);

return;