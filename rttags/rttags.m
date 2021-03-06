% RTTRACE  Reads time tags from GT658 using mex interface
%   time0 = rttags(ixBoard, numTimeTags, timeOut) reads 
%   up to (numTimeTags) arrival times or up to (timeOut) seconds of data from 
%   GT658 board (ixBoard).
%
%   time0 = rttags(ixBoard, numTimeTags, timeOut, ixChannel)
%   Reads from GT658 channel (ixChannel)
%
%   [time0, time1] = rttags(ixBoard, numTimeTags, timeOut)
%   reads from both channels of GT658.
%
%   See also rttrace, capture3d, acquire
function [time0, time1] = rttags(ixBoard, numTimeTags, timeOut, ixChannel);
global LineState;
global IntState;
% We need the board index, number of time tags, and timeOut
if nargin < 3,
    error('At least three inputs required');
end
% Default is channel A when only one channel is being recorded from
if nargout == 1 & nargin < 4, %only one output, but less than 4 input. just make sure things are alright. 
    ixChannel  = 0;
end;

% Override any value for ixChannel if both channels outputs are requested
if nargout == 2,
    ixChannel = 2;
end;

% % fprintf('Reading up to %d tags (for up to %gs) from GT658 board %d, ', numTimeTags, timeOut, ixBoard);
% % if ixChannel < 2,
% %     fprintf('channel %c.\n', 'A' + ixChannel);
% % else
% %     fprintf('both channels.\n');
% % end;

% Must prepare a digital output structure for timed_read_mex to use to
% trigger the GuideTech boards.
dio = digitalio('nidaq', 'Dev1');
hline = addline(dio, [0:4,7], 'Out'); % Line 7 is the trigger out line
PreTrigLineState = [LineState, IntState, 0];
putvalue(dio, PreTrigLineState);
TrigLineState = [LineState, IntState, 1];

% Finally, read the times from the GT658
if ixChannel ~= 2,
    time0 = timed_read_mex(ixBoard, ixChannel, numTimeTags, timeOut, dio, TrigLineState);
else
    [time0, time1] = timed_read_mex(ixBoard, ixChannel, numTimeTags, timeOut, dio, TrigLineState);
end;

putvalue(dio, PreTrigLineState);

fprintf('Time tags read:\n ');
%fprintf('Board %d: ',ixBoard);
if(ixChannel < 2)
    fprintf('channel %c: %d\n', 'A' + ixChannel, length(time0));
else
    fprintf('\tchannel A: %d\n\tchannel B: %d\n', length(time0), length(time1));
end;
if(ixChannel < 2)
    if length(time0) > 0,
        fprintf('%g kHz on channel %c (uncorrected)\n', length(time0) / time0(end) / 1000, 'A' + ixChannel);
    else
        fprintf('0 kHz on channel %d\n', ixChannel);
    end;
else
    if length(time0) > 0,
        fprintf('%g kHz on channel A (uncorrected)\n', length(time0) / time0(end) / 1000);
    else
        fprintf('0 kHz on channel A\n');
    end;
    
    if length(time1) > 0,
        fprintf('%g kHz on channel B (uncorrected)\n', length(time1) / time1(end) / 1000);
    else 
        fprintf('0 kHz on channel B\n');
    end;
end;

%fprintf('\n');
return;
        