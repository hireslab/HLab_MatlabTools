function meanLFP = buildContactAlignedLFP(T, contacts, s);
trialCondition = intersect(T.hitTrialNums, T.whiskerTrialNums);
[~,~,s_ind] = intersect(trialCondition, s.trialNums);
[~,~,c_ind] = intersect(trialCondition, T.trialNums);
[~,~,w_ind] = intersect(trialCondition, T.trialNums);


%%
figure(1);clf; hold on
preContactSamples = 2000
contactAlignedLFP = nan(length(s_ind),preContactSamples+s.sweeps{s_ind(1)}.sweepLengthInSamples);
for i = 1:length(s_ind);
    
    if ~isfield(contacts{c_ind(i)},'contactInds')
    elseif ~isempty(contacts{c_ind(i)}.contactInds{1})
        curSweep = s.sweeps{s_ind(i)};
        firstContactTime(i) = T.trials{w_ind(i)}.whiskerTrial.time{1}(contacts{c_ind(i)}.contactInds{1}(1));
        curAlignedLFP = curSweep.LFP((round(firstContactTime(i)*curSweep.sampleRate)- preContactSamples) : end); 
        contactAlignedLFP(i,1:length(curAlignedLFP)) = curAlignedLFP;
 %       plot((1:curSweep.sweepLengthInSamples)/curSweep.sampleRate-firstContactTime(i), curSweep.LFP)
        
    end
end
%plot(((1:size(contactAlignedLFP,2))-preContactSamples)/s.sweeps{s_ind(1)}.sampleRate, nanmean(contactAlignedLFP,1),...
 %   'r','LineWidth', 2)



meanLFP = nanmean(contactAlignedLFP,1);