function [ T, contacts, params] = loadSUData(cellNum, SU);

 SU_ConDir = ('/Volumes/Hires_Lab/Data/NoiseProject/S1_singleunit/ConTA/');
 SU_TDir =   ('/Volumes/Hires_Lab/Data/NoiseProject/S1_singleunit/TrialArrays/');
display(['Loading '  SU.trialArrayName{cellNum}])

load([SU_TDir SU.trialArrayName{cellNum}]);
load([SU_ConDir SU.contactsArrayName{cellNum}]);



