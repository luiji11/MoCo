function varargout = plGui(varargin)
% PLGUI MATLAB code for plGui.fig
%      PLGUI, by itself, creates a new PLGUI or raises the existing
%      singleton*.
%
%      H = PLGUI returns the handle to a new PLGUI or the handle to
%      the existing singleton*.
%
%      PLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLGUI.M with the given input arguments.
%
%      PLGUI('Property','Value',...) creates a new PLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plGui

% Last Modified by GUIDE v2.5 07-Apr-2018 14:33:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plGui_OpeningFcn, ...
                   'gui_OutputFcn',  @plGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before plGui is made visible.
function plGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plGui (see VARARGIN)

% Choose default command line output for plGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% IA. INITIALIZE AND GUI_Cmd_StartTask TASK
function GUI_Cmd_StartTask_Callback(hObject, eventdata, handles)
% hObject    handle to GUI_Cmd_StartTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global 
clc;
% Initialize
fprintf('*************\nINITIALIZING\n')
delete(instrfindall);
callWheel;
callArduino;
defineCommandCodes;
setupPeriods;
setupTrials;
setupSession;
initializeScreen;
initializeStimulus;
initializeRewardSettings;
setupDataLog;
updateGuiInfoAsked(); % Diplays ARD/WHL Connection Status in GUI

initializePlot(true)

fprintf('\nGO!!!\n*************\n')

% Begin Task
initializeGuiInfoScreen
startLooping();

exitTask();


%% IB. LOOP
function startLooping
    global SES PER
    while SES.inSession
        
        % COMMANDS FOR THE CURRENT PERIOD
        do = PER.per(PER.currentPeriod).cmdList; % period command list
        for k = 1:length(do)
            feval(do{k}); % execute commands
        end

        % STANDARD COMMANDS
        flipScreen();               % Update Screen
        readAndExecuteKeyCmd();     % read and execture keyboard command
        logData();                  % Log Data  (and update gui info panel, and plot) 
        startNextPeriod();             % start new period (if current period cloccked out)

    end    
    

%% PERIODS, TRIALS and SESSION ------------------------------------    
function setupPeriods()     %% TRIALS period setup
    global PER
    PER.currentPeriod = 1; % initialize for first trial
    PER.periodTimeStart = tic; 
    
    PER.per(1).duration = 0;
    PER.per(1).cmdList = {@startNewTrial @setStimHorPos};
    PER.per(1).nextPeriod = 2;

    PER.per(2).duration = .5;
    PER.per(2).cmdList = {@drawWaitDisplay};
    PER.per(2).nextPeriod = 3;

    PER.per(3).duration = .5;
    PER.per(3).cmdList = { @drawGrating @drawFixationCross};
    PER.per(3).nextPeriod = 4;

    PER.per(4).duration = 5;
    PER.per(4).cmdList = {@readWheelSpeed @executeWheelCommand @rewardIfTargetReached @drawGrating};
    PER.per(4).nextPeriod = 1;      
    
    
function startNextPeriod()     %% TRIALS update period
    global PER
    j = PER.currentPeriod;
    clockedOut =  toc(PER.periodTimeStart) > PER.per(j).duration; 
    if clockedOut
        PER.currentPeriod = PER.per(j).nextPeriod;  
        PER.periodTimeStart = tic;
    end  
    
    
function setupTrials 
    global TRL
    TRL.maxRewardsAllowed = 1;
    startNewTrial()    
    
    
function startNewTrial() 
    global TRL
    
    TRL.trialTimeStart = tic;  %% resets the trial clock
    TRL.numRewardsGiven = 0;    
    if isfield(TRL, 'currentTrial')
        TRL.currentTrial = TRL.currentTrial+1;   %% update trial Number
    else 
         TRL.currentTrial  = 0;  % INITIALIZE FIRST TRIAL
    end
    
    
function setupSession
    global SES
    
    % SESSION SETTINGS
    SES.inSession = true; % if true then continue looping (i.e. training)
    SES.numRewards = 0; % number of rewards given
    SES.numTrialsCompleted = 0; % number of trials completed
    SES.maxTrialsAllowed = 1000; % max number of trials allowed
    SES.trainingDuration = 60*60; % in seconds, maximum duration of the training
    SES.timeStart = tic; % start time of training
    
  


%% WHEEL     
function callWheel %% Initialize Wheel/Encoder
    global WHL
    fprintf('\nCALLING WHEEL...') % attempt to connect to encoder    
        WHL.lastPosition = 0; 
        WHL.paramater2Control = 'xpos'; % stimulus parameter wheel controls ('ori' for orientation, 'xpos' for x position)
        WHL.connected = true ; % if true then WHL is connected
    try 
        warning('off');
        fprintf('\t\n')        
        WHL.Mod = RotaryEncoderModule('COM15'); % encoder in port #15 
        WHL.Mod.zeroPosition; % zero the encoder
        readWheelSpeed(); % reads speed of wheel turn
        
        disp('      Connected :)')
        warning('on');

    catch
        WHL.connected = false ; % connection failed
        WHL.speed = nan;       % cannot compute speed of wheel turn   
        disp('      !!!CONNECTION FAILED :(');
        pause(.02)
    end
    disp('')
 
    function readWheelSpeed() % reads and updates the current speed of the wheel turn
        global WHL
        if WHL.connected
            p1                  = WHL.Mod.currentPosition; 
            WHL.speed           = p1 - WHL.lastPosition; 
            WHL.lastPosition    = p1;
        end
    
    function executeWheelCommand() %% Execute command using the speed of the wheel
    global WHL CMD 
    if WHL.connected &&  WHL.speed ~= 0
        switch WHL.paramater2Control  
            case 'xpos' % TRANSLATE STIMULUS 
                CMD.currentCmd = CMD.code.Whl_pushStim;
            case 'ori' % ROTATE STIMULUS
                 CMD.currentCmd = CMD.code.Whl_stimRotate;
        end    
    end

%% COMMANDS
function defineCommandCodes()
    global CMD
    CMD.code.pulseH20 = 'p';  
    CMD.code.pulseWidthIncrease = '[';
    CMD.code.pulseWidthDecrease = 'o';
    
    CMD.code.Gui_stimPushLeft = 'a';
    CMD.code.Gui_stimPushRight = 'd';
    CMD.code.Gui_stimRotLeft = 's';
    CMD.code.Gui_stimRotRight = 'w';
    
    CMD.code.Gui_stimSenseUp = 'i';
    CMD.code.Gui_stimSenseDwn = 'k';    

    CMD.code.Whl_pushStim = 't';
    CMD.code.Whl_stimRotate = 'r';
    
    CMD.code.exitTask = 'q';
    CMD.currentCmd = '';

function  executeCommand() %% Execute the current command
global CMD STM SES ARD WHL

if ~iscell(CMD.currentCmd) 
switch CMD.currentCmd     

    % COMMAND THE ARDUINO
    case CMD.code.pulseH20;             fwrite(ARD.mod, CMD.code.pulseH20);             disp('gui Gave Water');
%     case CMD.code.pulseWidthIncrease;   fwrite(ARD.mod, CMD.code.pulseWidthIncrease);   disp('gui INCREASED PW'); 
%     case CMD.code.pulseWidthDecrease;   fwrite(ARD.mod,  CMD.code.pulseWidthDecrease);  disp('gui DECREASED PW'); 

    % COMMAND THE STIMULUS
        % GUI COMMANDS
        case CMD.code.Gui_stimSenseUp;   STM.ctrlSensitivity = STM.ctrlSensitivity + 1;  updateGuiInfoAsked; disp('StimCntrl sensitivity increased'); 
        case CMD.code.Gui_stimSenseDwn; STM.ctrlSensitivity = STM.ctrlSensitivity - 1;  updateGuiInfoAsked; disp('StimCntrl sensitivity decreased');         
        
        case CMD.code.Gui_stimPushLeft;     STM.cx =  STM.cx -  5*STM.ctrlSensitivity;      disp('gui PUSHED STIM LEFT'); 
        case CMD.code.Gui_stimPushRight;    STM.cx =  STM.cx +  5*STM.ctrlSensitivity;      disp('gui PUSHED STIM RIGHT');
        case CMD.code.Gui_stimRotLeft;      STM.ori = STM.ori - 5*STM.ctrlSensitivity;     disp('gui ROTATED STIM LEFT');
        case CMD.code.Gui_stimRotRight;     STM.ori = STM.ori + 5*STM.ctrlSensitivity;     disp('gui ROTATED STIM RIGHT');     

            
        % WHEEL COMMANDS
        case CMD.code.Whl_pushStim;         STM.cx  =  STM.cx  + WHL.speed*STM.ctrlSensitivity;  disp('mouse PUSHED STIM');
        case CMD.code.Whl_stimRotate;       STM.ori =  STM.ori + WHL.speed*STM.ctrlSensitivity;  disp('mouse ROTATED STIM');

    % COMMAND THE SESSION
        case CMD.code.exitTask;         SES.inSession = false; 
end 
CMD.currentCmd = '';

            
end

function readAndExecuteKeyCmd()
        readKeyCmd();
        executeCommand();

function readKeyCmd() %% GUI read gui command
        global CMD
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown
            CMD.currentCmd = KbName(find(keyCode));
        end

%% SCREEN
    function initializeScreen() %%  SCREEN initialize
        global SCR
        fprintf('\n\nOPENING PTB SCREEN...')
        sca;
        SCR.framerate = 60;
        SCR.screenSize = get(0,'screensize');

        screedID = double(~isempty(strfind(cd, 'Luis'))); % 0 if luis's pc, 1 if in trachtenberg lab

        Screen('Preference', 'SkipSyncTests', 1);
        Screen('Preference', 'Verbosity', 0);      
        [SCR.windowPtr,SCR.dispSize] = Screen('OpenWindow', screedID, 127*[1 1 1], [SCR.screenSize(3)-400 0 SCR.screenSize(3) 400]);


        SCR.dispCx = mean(SCR.dispSize([1 3])); % center x of display (not the screen)
        SCR.dispCy = mean(SCR.dispSize([2 4])); % center y of display (not the screen)
        SCR.lastFlip = Screen('Flip', SCR.windowPtr);
        disp('      done!...')
    

    function flipScreen() 
        global SCR
        SCR.lastFlip    = Screen('Flip',SCR.windowPtr, SCR.lastFlip + (1/SCR.framerate/2));


%% DRAWING
    function drawGrating % DRAW GRATING
        global SCR STM
        STM.destinationRect = [(STM.cx-STM.width/2),(STM.cy-STM.height/2),(STM.cx+STM.width/2),(STM.cy+STM.height/2)];
        Screen('DrawTexture', SCR.windowPtr, STM.textureIdx, [],STM.destinationRect, STM.ori)


    function drawFixationCross % DRAW FIXATION CROSS
        global SCR 
        Screen('DrawLine', SCR.windowPtr, [255 0 0], SCR.dispCx-20, SCR.dispCy, SCR.dispCx+20, SCR.dispCy);
        Screen('DrawLine', SCR.windowPtr, [255 0 0], SCR.dispCx, SCR.dispCy-20, SCR.dispCx, SCR.dispCy+20);


    function drawWaitDisplay % WAITING DISPLAY
        global SCR 
        Screen('DrawLine', SCR.windowPtr, [0 0 0], SCR.dispCx-1000, SCR.dispCy, SCR.dispCx+1000, SCR.dispCy);
        Screen('DrawLine', SCR.windowPtr, [0 0 0], SCR.dispCx, SCR.dispCy-1000, SCR.dispCx, SCR.dispCy+1000);



%%  STIMULUS 
    function initializeStimulus()
        global STM SCR
        STM.width    = 300;      % width of the grating, in pixels
        STM.height   = 300;       % height of the grating, in pixels   
        STM.windowStyle = 'apperture'; % "apperture" or "gaussian" as a window
        STM.sigma  = 50;        % standard deviation of gaussian window, or radius of the aperture, in pixels
        STM.sptfreq   = 5;        % spatial freq in cycles per screen *height*
        STM.contrast = 1;       % proportion contrast, 0 to 1
        STM.ux     = STM.width/2;    %// horizontal position (center) of gaussian window (or aperture), in pixels
        STM.uy     = STM.height/2;   %// center vertical position of gaussian window or aperture, in pixels
        STM.ori = 0;          % orienation         
        STM.cx = SCR.dispCx;      %  center x position of the stimulus 
        STM.cy = SCR.dispCy;      %  center y position of the stimulus 

        STM.ctrlSensitivity = 1; % sensitivity 
        
        STM.phase = 0; 

        th = linspace(0,2*pi, STM.width);
        STM.matrix = 127*STM.contrast * ones(STM.width,1)* sin(th*STM.sptfreq);

        switch STM.windowStyle
            case 'apperture'
                [I, J] = meshgrid(1:STM.width, 1:STM.height);        
                dx = STM.ux - J(:);
                dy = STM.uy - I(:);
                STM.matrix = STM.matrix+127;
                STM.matrix(sqrt(dx.^2+dy.^2) > STM.sigma) = 127;
            case 'gaussian'
                H = fspecial('gaussian',[STM.height STM.width], STM.sigma);
                H = (H - min(H(:))) / (max(H(:))-min(H(:)));
                STM.matrix = 127+ STM.matrix.*H;
            otherwise
                error('Stimulus window style not known')
        end
        
        
        STM.textureIdx=Screen('MakeTexture', SCR.windowPtr, STM.matrix);

    function setStimHorPos
    global STM SCR
        STM.cx = SCR.dispCx + sign(randn)*20;
    
    


%% LOG 
function setupDataLog()
    global LOG 
    fprintf('\nINITIALIZING DATA LOG...\n')
    nameDataLogFile();    
    createDataStructure()
    LOG.rate = 10;            
    LOG.lastLogTime = tic;
    LOG.timeSinceLastLog = toc(LOG.lastLogTime);    
    fprintf('\n   Done!')

function nameDataLogFile
    global LOG
    fprintf('\n  *Naming Log File...')
    
    G = guidata(plGui);   
    LOG.mouseId     = G.GUI_Log_Mouse.String;
    LOG.dataPath    = [cd '\' LOG.mouseId];    
    LOG.sessionId   = sprintf('%.03d', str2double(G.GUI_Log_Session.String));     
    LOG.fileName    = sprintf('%s_%s', LOG.mouseId, LOG.sessionId );
    LOG.fileNameFull = [LOG.dataPath '\'  LOG.fileName];
    
    if ~exist(LOG.dataPath, 'dir')
        mkdir(LOG.dataPath)
        fprintf('\n\t\t***Created new folder for log file: %s', LOG.mouseId)
    end
    
    if exist([LOG.fileNameFull, '.mat'],'file') == 2  
        fprintf('\t\t!!!Session %s already taken for Mouse %s', LOG.sessionId, LOG.mouseId)
        flist = dir( LOG.dataPath);
        flist = {(flist.name)};
        flist_match = flist( cellfun(@(s) ~isempty(s), regexp(flist, [LOG.mouseId '_\d\d\d.mat']) ) );
        sessionNumsUsed = cellfun(@(s, idx) str2double(s(idx+1:idx+3)), flist_match, regexp(flist_match, '_\d\d\d'));
        LOG.sessionId   = sprintf('%.03d', max(sessionNumsUsed)+1);  
        LOG.fileName = sprintf('%s_%s', LOG.mouseId, LOG.sessionId );
        LOG.fileNameFull = [LOG.dataPath '\'  LOG.fileName];  
        fprintf('\n\t\t\t!!!changed session no. to %s', LOG.sessionId)
        G.GUI_Log_Session.String = str2double(LOG.sessionId);
        
    end
        fprintf('\n\t\t\tPath: %s', LOG.dataPath)    
        fprintf('\n\t\t\tFolder Name: %s', LOG.mouseId)
        fprintf('\n\t\t\tFile Name: %s\t', LOG.fileName) 
        
function logData() %% LOG fast data
    global TRL LOG STM SES WHL 
    LOG.timeSinceLastLog = toc(LOG.lastLogTime);

    if LOG.timeSinceLastLog > (1/LOG.rate)  
        t = TRL.currentTrial ;  
        if t > length(LOG.data) 
            createDataStructure();
        end
        LOG.data(t).timeStamp   = [LOG.data(t).timeStamp toc(SES.timeStart)];
        LOG.data(t).stimCx      = [LOG.data(t).stimCx   STM.cx];
        LOG.data(t).stimOri     = [LOG.data(t).stimOri  STM.ori];
        LOG.data(t).wheelSpeed  = [LOG.data(t).wheelSpeed WHL.speed];
        LOG.lastLogTime = tic;    

        updateGuiInfoDisplayFast();       % Update GUI Info Panel/ At the same rate that you log
        updatePlot();               % update plot

    end
        
function createDataStructure %% LOG create or allocate Memory for Data Log
    global LOG 
        appendSize = 10;
         if isfield(LOG, 'data')
            x(appendSize).timeStamp  = [];
            x(appendSize).stimCx     = [];
            x(appendSize).stimOri    = []; 
            x(appendSize).wheelSpeed = [];
            LOG.data = [LOG.data x];
            disp('*Allocated memory to data log')
         else
            LOG.data(appendSize).timeStamp  = [];
            LOG.data(appendSize).stimCx     = [];
            LOG.data(appendSize).stimOri    = []; 
            LOG.data(appendSize).wheelSpeed = [];
            fprintf('\n\t  *Initialized data structure')
            
         end


%% ARDUINO 
function callArduino
    global ARD
    ARD.connected = true;    
    
    try
        disp('CALLING ARDUINO...')        
        ARD.mod = serial('COM17');
        ARD.mod.BaudRate = 9600;
        fopen(ARD.mod);
        disp('      Connected :)')
        ARD.valve.pulseWidth = .045;
        

    catch
        ARD.connected = false;    
        disp('      ***Connection Failed :(')
        pause(.5)
    end



%% PLOT
function initializePlot(plotOn)
global PLT SCR
    
    if plotOn
        G = guidata(plGui);    
        PLT.fig = G.figure1;
        axes(G.axes1);
        box off
        PLT.plt = plot(nan,nan, '-o'); 
        xlim(SCR.dispSize([1 3]));
        PLT.updateRate = 5;
        PLT.lastUpdate = tic;
        PLT.plotOn = true;

    else
        PLT.plotOn = false;
        
    end
        

function updatePlot()
    global PLT TRL LOG
    if PLT.plotOn && toc(PLT.lastUpdate) > 1/PLT.updateRate && TRL.currentTrial>1 
            PLT.plt.XData = LOG.data(TRL.currentTrial).stimCx(end);
            PLT.plt.YData = LOG.data(TRL.currentTrial).timeStamp(end);
                        
            ylim([mean(PLT.plt.YData)-5 mean(PLT.plt.YData)+5])
            PLT.lastUpdate = tic;  

    end


%% EXIT TASK
function exitTask()
        global LOG
        G = guidata(plGui);
        
        G.GUI_Cmd_StartTask.String = 'START';
        G.GUI_Cmd_StartTask.Enable = 'on';
        G.GUI_Cmd_AbortTask.Enable = 'off';
        G.GUI_Whl_connected.ForegroundColor  = 'k'; G.GUI_Whl_connected.String  = 'Wheel';
        G.GUI_Ard_connected.ForegroundColor  = 'k'; G.GUI_Ard_connected.String  = 'Arduino';   
        G.GUI_Log_Mouse.Enable = 'on';
        G.GUI_Log_Session.Enable = 'on';
        
        sca;
        fprintf('\n\n')       
        disp('Screen Closed')         

        save(LOG.fileNameFull, 'LOG');
        disp('Data Log Saved') 
        disp('TASK ENDED!!!') 

        

        
%% GUI     
function GUI_Cmd_PulseH20_Callback(hObject, eventdata, handles) % --- Executes on button press in pulseH20.
    global CMD ARD
    if ARD.connected == true    
        CMD.currentCmd = CMD.code.pulseH20;
    else
        disp('Cant reward | Arduino Not Connected');
    end

function GUI_Cmd_AbortTask_Callback(hObject, eventdata, handles)    % --- Executes on button press in guiAbort.
    global CMD
    CMD.currentCmd = CMD.code.exitTask;
    
function GUI_Cmd_StimMoveLeft_Callback(hObject, eventdata, handles) % --- Executes on button press in stimTranslateLeft.
    global CMD
    CMD.currentCmd = CMD.code.Gui_stimPushLeft;

function GUI_Cmd_StimMoveRight_Callback(hObject, eventdata, handles)% --- Executes on button press in stimTranlateRight.
    global CMD
    CMD.currentCmd =CMD.code.Gui_stimPushRight;  
              
function GUI_Cmd_StimRotateCC_Callback(hObject, eventdata, handles)% --- Executes on button press in stimRotateCC.
    global CMD
    CMD.currentCmd = CMD.code.Gui_stimRotLeft;    
         
function GUI_Cmd_StimRotateC_Callback(hObject, eventdata, handles)% --- Executes on button press in stimRotateC.
    global CMD
    CMD.currentCmd = CMD.code.Gui_stimRotRight;     

function GUI_Cmd_stimsense_up_Callback(hObject, eventdata, handles) % --- Executes on button press in GUI_Cmd_stimsense_up.
% hObject    handle to GUI_Cmd_stimsense_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global CMD
    CMD.currentCmd = CMD.code.Gui_stimSenseUp;  
    

function GUI_Cmd_stimsense_dwn_Callback(hObject, eventdata, handles)% --- Executes on button press in GUI_Cmd_stimsense_dwn.
% hObject    handle to GUI_Cmd_stimsense_dwn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global CMD
    CMD.currentCmd = CMD.code.Gui_stimSenseDwn;     
    
    
function initializeGuiInfoScreen
    G = guidata(plGui);
    G.GUI_Cmd_StartTask.String = 'in training...';
    G.GUI_Cmd_StartTask.Enable = 'off';
    G.GUI_Cmd_AbortTask.Enable = 'on';
    G.GUI_Log_Mouse.Enable = 'off';
    G.GUI_Log_Session.Enable = 'off';
    

function  updateGuiInfoDisplayFast
    global TRL PER SES
    G = guidata(plGui);
    
    G.GUI_Trl_CurrentPeriod.String        = sprintf('Current Period: %d', PER.currentPeriod); 
    G.GUI_Trl_PeriodTimeElapsed.String   = sprintf('Time Elapsed: %.1fs', toc(PER.periodTimeStart));
   
    G.GUI_Trl_CurrentTrialNo.String         = sprintf('Current Trial: %d/%d', TRL.currentTrial, SES.maxTrialsAllowed);    
    G.GUI_Trl_TrialTimeElapsed.String    = sprintf('Time Elapsed: %.1fs', toc(TRL.trialTimeStart));

    G.GUI_Ses_TimeElapsed.String         = sprintf('Time Elapsed: %.0fs/%.0fs ', toc(SES.timeStart), SES.trainingDuration);
    


    
    function updateGuiInfoAsked    
        global WHL ARD STM
        G = guidata(plGui);
        G.GUI_Cmd_StimSense_state.String = num2str(STM.ctrlSensitivity);
        
        if WHL.connected;   G.GUI_Whl_connected.ForegroundColor  = [0 1 0]; G.GUI_Whl_connected.String  = 'Wheel ON'; 
        else                G.GUI_Whl_connected.ForegroundColor  = [1 0 0]; G.GUI_Whl_connected.String  = 'Wheel OFF'; 
        end

        if ARD.connected;   G.GUI_Ard_connected.ForegroundColor  = [0 1 0]; G.GUI_Ard_connected.String  = 'Arduino ON';
        else                G.GUI_Ard_connected.ForegroundColor  = [1 0 0]; G.GUI_Ard_connected.String  = 'Arduino OFF';   
        end        
    
    
    
function GUI_Log_Mouse_Callback(hObject, eventdata, handles)
% hObject    handle to GUI_Log_Mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of GUI_Log_Mouse as text
%        str2double(get(hObject,'String')) returns contents of GUI_Log_Mouse as a double
    nameDataLogFile();



%% REWARD
function initializeRewardSettings
        global REW 
        REW.errorAllowed = 10;

    function rewardIfTargetReached
        global REW TRL CMD ARD STM SCR
        REW.distanceFromTarget = abs(SCR.dispCx-STM.cx);
        if (TRL.numRewardsGiven <TRL.maxRewardsAllowed) && (REW.distanceFromTarget<= REW.errorAllowed)
            if ARD.connected == true    
                CMD.currentCmd = CMD.code.pulseH20;
            else
                disp('Cant reward | Arduino Not Connected');
            end 
            TRL.numRewardsGiven = TRL.numRewardsGiven +1;
        end
        

        

            

        
        
        
               
    
    







%=========================================================================
%% RETIRED
%=========================================================================


% --- Executes during object creation, after setting all properties.
function GUI_Whl_connected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui_whl_connected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over gui_whl_connected.
function GUI_Whl_connected_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gui_whl_connected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function GUI_Log_DataPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GUI_Log_DataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.


function GUI_Log_Mouse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GUI_Log_Mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end    

function GUI_Log_Session_Callback(hObject, eventdata, handles)
% hObject    handle to GUI_Log_Session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GUI_Log_Session as text
%        str2double(get(hObject,'String')) returns contents of GUI_Log_Session as a double


% --- Executes during object creation, after setting all properties.
function GUI_Log_Session_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GUI_Log_Session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in GUI_Log_DataPath.
function GUI_Log_DataPath_Callback(hObject, eventdata, handles)
% hObject    handle to GUI_Log_DataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
