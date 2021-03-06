function initParameters()
global SAMPLE_DESC;
global DAQ_PARAMS;
global LOCKIN_PARAMS;
global CHANNELS_DESC;
global PREFERENCES;

SAMPLE_DESC=struct('Desc','','Od','0',...
    'V1',0,'V1desc','','V2',0,'V2desc','','V3',0,'V3desc','',...
    'Comments','');
DAQ_PARAMS=struct('SampRate',1000,'DaqChannels',[1 1 1 0 0 0 0 0],'Integrate',0);
LOCKIN_PARAMS=GetLockInSettings();
CHANNELS_DESC=struct('Apd0','APD0','Apd1','APD1','Apd2','APD2','Apd3','APD3',...
    'Daq0','x','Daq1','y','Daq2','z','Daq3','DAQ3',...
    'Daq4','DAQ4','Daq5','DAQ5','Daq6','DAQ6','Daq7','DAQ7');
PREFERENCES=struct('PromptOD',1);
