function trialInds = getTrialsOfContactType(contacts, trialContactType);

trialInds = [];
whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));

if sum(trialContactType == 0)
for i = 1:length(trialContactType)
    trialInds = cat(2,trialInds,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == trialContactType(i)));
end

else
for i = 1:length(trialContactType)
    trialInds = cat(2,trialInds,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == trialContactType(i) & ...
        cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
end
end

