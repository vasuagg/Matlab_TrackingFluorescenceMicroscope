%   ACQUIRE  acquires 3d tracking data and saves it in the current
%   directory.
%
%   Acquire(file_start, file_end, run_time) acquires (file_end -
%   file_start) segments of data, each of duration run_time.  Data is saved
%   to files named as 'data_filenum' where filenum is a number between
%   file_start and file_end.
%
%   Acquire(file_start, file_end, run_time, NIDAQ_Channels) records from
%   the list of analog channels specified in NIDAQ_Channels (between 3 and 7) 
%   on the DAQ board.  Saves data to the variable NIDAQ_Out in the data
%   files.
%   
%   Acquire(file_start, file_end, run_time, NIDAQ_Channels, NIDAQ_Desc,
%   tags_Desc) allows descriptive data to be saved to data files for the
%   additional NIDAQ inputs as well as the different fluorescence
%   measurements.  NIDAQ_Desc and tags_Desc must be cell arrays containing
%   strings.
%
%   See also capture3d, rttags, rttrace, drawplots3d
%
% Version 1.1 Updated May 15, 2008 by KM

% now added the ability to count when the acquie data begins 
%Version 1.2 Updated Jan 11, 2009 by ZK

function Acquire(file_start, file_end, run_time, NIDAQ_Channels, NIDAQ_Desc, tags_Desc)

if nargin < 3,
    error('You must specifiy at least: file_start, file_end, run_time');
end;

if nargin < 4,
    tags_Desc = [];
end;

if nargin < 5,
    NIDAQ_Channels = [];
end;

if nargin < 6,
    NIDAQ_Desc = {};
end;

if nargin < 7,
    tags_Desc = {};
end;

for u=file_start:file_end, % Prevent file overwrites
    if exist(strcat('./data_', num2str(u), '.mat'), 'file'),
        error(strcat('File `data_', num2str(u), '.mat already exists.'));
    end;
end    
    
for u = file_start:file_end, 
    fprintf('Beginning acquisition %g...\n', u-file_start + 1);
    if length(NIDAQ_Desc) ~= length(NIDAQ_Channels),
        warning('Number of NIDAQ channels does not match number of NIDAQ descriptions');
    end;

    %record system clock before the acquire command:
    begin_clock=fix(clock)
    
    [tags, t0, x0, y0, z0, NIDAQ_Out] = Capture3D(run_time, 1e3, NIDAQ_Channels);
    
    if length(tags) ~= length(tags_Desc),
        warning('Number of fluorescence traces does not match number of fluorescence descriptions');
    end;
    
    fprintf('Acquisition complete.  Saving to file data_%g.mat.\n', u);
   
    save(sprintf('data_%g', u), 'tags', 'x0', 'y0', 'z0', 't0', 'tags_Desc', 'NIDAQ_Out', 'NIDAQ_Desc','begin_clock');
    

end;

 