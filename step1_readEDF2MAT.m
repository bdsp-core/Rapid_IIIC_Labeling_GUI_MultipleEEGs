%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Goal: read EDF format to MAT using EEGLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; close all; clear;

%% Start EEGLAB toolbox for reading EDF 
% run('.\tools\eeglab\eeglab.m');
% clc; close; 

%% Get list of files 
dataDir = '.\Data\EDF\';
files = struct2cell(dir([dataDir, '\*.edf']))';
files = files(:, 1);

%% Define output folder 
trtDir = '.\Data\MAT\';
if exist(trtDir, 'dir')~=7
    mkdir(trtDir)
end
    
%% Main loop for each EDF
for i = 1:length(files)  
    fileNameo = files{i};

    %% EEG structure 
    EEG  = pop_biosig([dataDir, fileNameo]);
    data = double(-1*EEG.data);      % data array (fix -1 polarity issure) %
    Fs = EEG.srate;          % sampling rate %
    startTime = EEG.etc.T0;  % EEG start time numbers vector %
    channels = struct2cell(EEG.chanlocs)'; % EEG channel names in order %
    channels = channels(:, 1);
    
    %% Export
    save([trtDir, strrep(fileNameo, '.edf', '.mat')], 'data', 'channels', 'Fs', 'startTime', '-v7.3')  
end
