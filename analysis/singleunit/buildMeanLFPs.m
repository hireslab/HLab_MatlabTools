baseDir = 'Z:\users\Andrew\Whisker Project\SingleUnit\'

for k = 1:53
   load([baseDir, 'ConTA\' SU.contactsArrayName{k}])
   load([baseDir, 'SweepArrays\' SU.sweepArrayName{k}])
   load([baseDir, 'TrialArrays\' SU.trialArrayName{k}])
  
    try
    meanLFP{k} = buildAllContactAlignedLFP(T, contacts, s);
    end
    k
    
end