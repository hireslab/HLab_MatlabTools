d = dir('Z:\users\Andrew\Whisker Project\Silicon\DiscrimAnalysisArrays\*.mat');

%SU_L4nums = find(cellfun(@(x)x(3),SU.recordingLocation) > -.588 &  cellfun(@(x)x(3),SU.recordingLocation) < -.418)
Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588));

sind = 0
for snum = [1 2 11 16 27 33 43 52 60 66 67 76 93 98 105 111 127 129 137 139 141 143 ];
 sind = sind+1
     [CA, T, contacts, DA, clustInd, params] = loadSiData(snum, S)

    figure(1);clf

conInd= {};
whiskInd = {};
whiskPoleInd = {};
whiskTheta = {};
whiskPoleTheta = {};
contactTrigTheta = {};
tinds = find(cellfun(@(x)~isempty(x),DA.theta))'
if max(tinds) > length(DA.contactTimesInSamplingPeriod);
    for j = length(DA.contactTimesInSamplingPeriod)+1: max(tinds);
    DA.contactTimesInSamplingPeriod{j}=[];
    end
end
DA.hitInd = find(T.hitTrialInds);
DA.missInd = find(T.missTrialInds);
DA.FAInd = find(T.falseAlarmTrialInds);
DA.CRInd  = find(T.correctRejectionTrialInds);

for i = tinds;
     [~,conInd{i},~] = intersect(DA.samplingPeriodinMs{i},DA.contactTimesInSamplingPeriod{i});
     [~,whiskPoleInd{i},~] = intersect(DA.samplingPeriod{i},DA.whiskSamplingPeriod{i}(DA.whiskSamplingPeriod{i}>.7));
     [~,whiskInd{i},~] = intersect(DA.samplingPeriod{i},DA.whiskSamplingPeriod{i});
     contactTrigTheta{i} = DA.theta{i}(conInd{i});
    whiskTheta{i} = DA.theta{i}(whiskInd{i});
    whiskPoleTheta{i} = DA.theta{i}(whiskPoleInd{i});
end
edges = -40:1:60;
histConTheta = histc([contactTrigTheta{:}],edges);
histSampleTheta = histc([DA.theta{:}],edges);
histWhiskTheta = histc([whiskTheta{:}],edges);

histConThetaGo = histc([contactTrigTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histConThetaNogo = histc([contactTrigTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);

histWhiskThetaGo = histc([whiskTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histWhiskThetaNogo = histc([whiskTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);
histWhiskPoleThetaGo = histc([whiskPoleTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histWhiskPoleThetaNogo = histc([whiskPoleTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);


find(histConThetaGo,1,'first'):find(histConThetaGo,1,'last')
find(histConThetaNogo,1,'first'):find(histConThetaNogo,1,'last')

SiOccupyNorm(sind,1) = sum(histConThetaGo / sum(histConThetaGo) .* histWhiskTheta / sum(histWhiskTheta))
SiOccupyNorm(sind,2) =sum(histConThetaNogo / sum(histConThetaNogo) .* histWhiskTheta / sum(histWhiskTheta))
SiOccupy(sind,1) = sum(histWhiskTheta(find(histConThetaGo,1,'first'):find(histConThetaGo,1,'last')) / sum(histWhiskTheta))
SiOccupy(sind,2) = sum(histWhiskTheta(find(histConThetaNogo,1,'first'):find(histConThetaNogo,1,'last')) / sum(histWhiskTheta))
end

