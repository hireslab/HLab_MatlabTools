function meanLFP = buildAllContactAlignedLFP(T, contacts, s);
trialCondition = T.whiskerTrialNums
[~,~,s_ind] = intersect(trialCondition, s.trialNums);
[~,~,c_ind] = intersect(trialCondition, T.trialNums);
[~,~,w_ind] = intersect(trialCondition, T.trialNums);


%%
%figure(1);clf; hold on
preContactSamples = 2000
postContactSamples = 2000
contactAlignedLFP = nan(length(s_ind),preContactSamples+postContactSamples+1);
for i = 1:length(s_ind);
    
    if ~isfield(contacts{c_ind(i)},'contactInds')
    elseif ~isempty(contacts{c_ind(i)}.segmentInds{1})
        curSweep = s.sweeps{s_ind(i)};
        contactTimes = T.trials{w_ind(i)}.whiskerTrial.time{1}(contacts{c_ind(i)}.segmentInds{1}(:,1));
        
        for j = 1:length(contactTimes)
            curAlignedLFP(j,:) = curSweep.LFP((round(contactTimes(j)*curSweep.sampleRate)- preContactSamples) : (round(contactTimes(j)*curSweep.sampleRate)+ postContactSamples)); 
        end
            contactAlignedLFP(i,1:size(curAlignedLFP,2)) = mean(curAlignedLFP,1);
 %       plot((1:curSweep.sweepLengthInSamples)/curSweep.sampleRate-firstContactTime(i), curSweep.LFP)
        
    end
end
%plot(((1:size(contactAlignedLFP,2))-preContactSamples)/s.sweeps{s_ind(1)}.sampleRate, nanmean(contactAlignedLFP,1),...
 %   'r','LineWidth', 2)



meanLFP = nanmean(contactAlignedLFP,1);