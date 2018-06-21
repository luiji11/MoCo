
Dfast = load('logfast.txt', '-ascii');

Dslow = textscan(fopen('logslow.txt'), '%d %d %d %d %d %s');


t.startTime = Dslow{1};
t.duration = Dslow{2};
t.trialNo = Dslow{3};
t.stimStartPos = Dslow{4};
t.stimOri = Dslow{5};
t.correct = Dslow{6};



