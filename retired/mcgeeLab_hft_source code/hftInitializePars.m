function [I, T, K] = hftInitializePars
%% Initialization of session parameters

% Stuff about Sampling 
K.sampHz        = 15;   % Sampling rate (in Hz) of animal's licking behavior. 15 is a descent rate
K.k             = 1;    % Initialize sampling counter

% Other Experiment Parameters 
T.sessDur       = 45 * 60;  % max duration of session (in seconds)
I.nStimIntVals  = 25;       % total number of Spt Hz values you want
I.sfIntValues   = linspace(.05,1.2, I.nStimIntVals); % Spt hz values that will be used during session, equally spaced (for now)

% Estimate the # of times you'll be sampling the licking behavior. this is
% used to preallocate memory into your event matrices. Its ok if its an
% underestimate.
estNumSamples   = round(K.sampHz*(T.sessDur)/10); 

% EVENT MATRICES The matrices below will be used to save all the relevent
% events during the session: Licking, stimulus, rewards, and performance
% events will be stored here. Some sessions dont make use of all of these
% event matrices, they're just here just in case.
%
% IMPORTANT NOTE.. In these matrices, the first column is reserved for a
% frame number of an event. If there is a second column, then it is
% reserved for the event that pertains to that frame number.

I.lick          = zeros(estNumSamples, 2);              % Did the animal lick the first or second port? This info will be saved here
I.sOn           = zeros(round(size(I.lick,1)/5),1);     % When did the stimulus turn on? This info is saved here
I.sOff          = I.sOn;                                % When did the stimulus turn off? This info will be saved here
I.sPos          = I.sOn;                                % Where was the stimulus, left or right? This infor is saved here. 
I.sVal          = I.sOn;                                % What was the spatial HZ stimulus. This info is saved here
I.water         = [I.sOn I.sOn];                                % Was water dispensed to the first or second port? This info is saved here        
I.perf          = I.sOn;                                % Was it a correct or incorrect response? This info will be saved here



