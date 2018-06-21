function [keyCmd, timestamp] = readKey
        keyCmd = [];
        timestamp = [];
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown
            timestamp = tic;
            keyCmd = KbName(find(keyCode));
        end
        
        if iscell(keyCmd)
           keyCmd = keyCmd{1}; % if user presses 2 buttons, only return 1 (errors pop up otherwise)
        end
      
end

