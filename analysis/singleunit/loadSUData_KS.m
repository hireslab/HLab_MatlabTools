function [CA, T, DA, contacts, params] = loadSUData_KS(cellNum, SU);

SU_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\');
SU_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\');
SU_CADir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\CellAnalysisArrays\');
SU_DADir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\DiscrimAnalysisArrays\');

display(['Loading '  SU.trialArrayName{cellNum}])
load([SU_CADir SU.trialArrayName{cellNum}(13:end)]);
load([SU_DADir 'DA_' num2str(cellNum) '_' SU.trialArrayName{cellNum}(13:end)]);
load([SU_TDir SU.trialArrayName{cellNum}]);
load([SU_ConDir SU.contactsArrayName{cellNum}]);



