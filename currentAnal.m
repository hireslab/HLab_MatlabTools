% select contact class
cType = 1

tInds = find(cellfun(@(x)x.trialContactType,contacts)==cType);
padSize = max(cellfun(@(x)length(x.meanM0adj{1}),contacts(tInds)))
allMeanM0adj = cell(1,padSize);



% calculat contact sorted mean M0adj
for k=tInds
 if ~isempty(contacts{k}.meanM0adj{1});

   for i=1:length(contacts{k}.meanM0adj{1})
       allMeanM0adj{i} = cat(1,allMeanM0adj{i},contacts{k}.meanM0adj{1}(i));
   end
 end
end

figure(20);hold on
for i = 1:length(allMeanM0adj)
    plot(i,nanmean(allMeanM0adj{i}),'')
end

%%
% Plot mean contact M0s
figure(19);cla;hold on
for k=tInds
    plot(1:length(contacts{k}.meanM0{1}),contacts{k}.meanM0{1},'r.');
    plot(1:length(contacts{k}.meanM0adj{1}),contacts{k}.meanM0adj{1},'b.');


end



% Find spikes associated with each contact
 
% disp('Finding spikes associated with each contact')

% for k = whiskerTIN
%     contacts{k}.spikeUseFlag{1} = cellfun(@(x)x.useFlag,array.trials{k}.shanksTrial.clustData);
%     if isempty(contacts{k}.segmentInds{1}) == 0
%         for i=1:length(contacts{k}.segmentInds{1}(:,1));
%             lim = time{k}(contacts{k}.segmentInds{1}(i,:)) + params.spikeSynapticOffset;
%             contacts{k}.spikeCount{1}(i,:) = cellfun(@(x)...
%             sum(double(x.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset > lim(1)...
%               & double(x.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset < lim(2)),...
%               array.trials{k}.shanksTrial.clustData);
%         end
%     else
%         contacts{k}.spikeCount={[]};
%     end
% end
