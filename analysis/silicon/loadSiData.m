function [CA, T, contacts, DA, clustInd, params] = loadSiData(cellNum, S);

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\');
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\');
Si_CADir = ('Z:\Users\Andrew\Whisker Project\Silicon\CellAnalysisArrays\');
Si_DADir = ('Z:\Users\Andrew\Whisker Project\Silicon\DiscrimAnalysisArrays\');

display(['Loading '  S.trialArrayName{cellNum}])
load([Si_TDir S.trialArrayName{cellNum}]);
load([Si_ConDir S.contactsArrayName{cellNum}]);
load([Si_CADir S.filename{cellNum}]);
load([Si_DADir 'DA_' num2str(cellNum) '_' S.filename{cellNum}]);
clustInd = find(T.cellNum == S.clust{cellNum} & T.shankNum==S.shank{cellNum});

