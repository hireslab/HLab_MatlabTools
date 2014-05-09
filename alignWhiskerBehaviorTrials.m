function corr_offset = alignWhiskerBehaviorTrials(T, ythresh)
ythresh = 220
whiskerInds = find(cellfun(@(x)~isempty(x.whiskerTrial),T.trials))
goBar = cellfun(@(x)x.whiskerTrial.barPos(1,3)<ythresh,T.trials(whiskerInds))
cc = normxcorr2([goBar], T.trialTypes)
[cmax,imax] = max(cc)
corr_offset = imax-size(T.trialTypes,2)
figure(55);clf;imagesc(cc);
end

