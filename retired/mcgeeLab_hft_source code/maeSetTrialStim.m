function nextTrialPosition = maeSetTrialStim(Method,trialAnswers, posIndx, wrongCountIndx)
% when 'Method' is set to 'NonPsuedo', this function re-positions the
% to-be-presented stimulus with respect to the outcome of the previous
% trial. E.g., if the last trial was a miss, the stimulus remains in the
% same position. If the last trial was correct, then the stimulus switches
% to the other side. If State is set to 'Psuedo', the position of the
% stimulus is determined psuedo randomly, in which no more than three
% trials in a row will have the stimulus in the same position.
% 
% Note that if there was no previous trial (e.g. the first trial), the
% stimulus is positioned on the left side (i.e. 1).
% 
% INPUT
%       state = 'nonPsuedo' or 'Psuedo'.         
%
%       trialAnswers: data matrix where you store your trial answers +
%       info. I have this store as my 'I.trial' matrix.
%
%       posIndx: column w/in 'trialAnswers' (i.e. your data matrix ) where
%       the previous trial's stimulus position is represented. I have this
%       stored in the 2nd column in my 'I.trial' data matrix.
%
%       wrongCountIndx: column w/in 'trialAnswers' the represents the
%       previous trial's outcome (e.g. hit or miss). Note that a hit is
%       considered to be a value of zero in this case, and a miss is
%       anything above 1. I do this b/c instead of checking whether the
%       trial was wrong or right, I simply count the number of times the
%       animal incorrectly licks (b/c Im contuously sampling). So if the #
%       of incorrect licks is zero, then I assume its a HIT trial.
% OUTPUT 
%       nextTrialPosition: either 1 or 2, left or right


evnt = maeLastEvent(trialAnswers,[posIndx wrongCountIndx]);

switch Method
    
    case 'NonPsuedo'
        if  (evnt(1) == 0)
             evnt(1) = 2; 
        end
        nextTrialPosition =  (evnt(2) == 0) * abs(evnt(1) - 3) +  evnt(1) * (evnt(2) > 0); 

    case 'Psuedo' % if animal fails, 
        nTrials = find(trialAnswers == 0,1)-1;
        nextTrialPosition = randi(2); % random selection (1 is L, 2 is R)
        if nTrials >= 3 % if at least three trials have passed
            lastThree = trialAnswers(nTrials-2:nTrials,3);
            if (lastThree(1) == lastThree(2)) && (lastThree(2) == lastThree(3))   
                nextTrialPosition =  (evnt(2) == 0) * abs(evnt(1) - 3) +  evnt(1) * (evnt(2) > 0);
            end
        end
        
    case 'McgeePlacePsuedoRand' % no more than three GOs or ~GOs in a row
        nTrials = find(trialAnswers == 0,1)-1;
        nextTrialPosition = randi(2) + 3; % random selection (4 is Go, 5 is ~Go)  

        if nTrials >= 3 % but if at least three trials have passed & and 3 in a row of same trials, switch it
            lastThree = trialAnswers(nTrials-2:nTrials,2);
            if (lastThree(1) == lastThree(2)) && (lastThree(2) == lastThree(3))                 
                nextTrialPosition =  evnt(1)  +  (evnt(1) == 5)*-1  + (evnt(1) == 4)*+1; % swtiches 4to5 & 5to4 | GOto~GO & ~GOtoGO       
            end
        end        
        
        
end





    


