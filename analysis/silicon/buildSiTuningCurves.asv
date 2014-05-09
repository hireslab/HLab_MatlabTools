buildSiTuningCurves

SU_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
SU_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\')

for i=1:148%:length(SU.cellName);
  
    % Open next array if current array does not match name in summary
    if ~strcmp( S.trialArrayName{i}(5:17), T.sessionName(4:16))
        display(['Loading '  S.trialArrayName{i}])
        load([Si_TDir S.trialArrayName{i}])
        load([Si_ConDir S.contactsArrayName{i}]);
    end
    
    % Find cluster index for this cell and session
     clustInd = find(T.cellNum == S.clust{i} & T.shankNum==S.shank{i})

     % No contact trials
        
     % All trials pre-lick