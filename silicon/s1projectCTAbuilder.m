Whisker.makeClusterTrialArray('140536','110822')
Whisker.makeClusterTrialArray('140536','110823')
Whisker.makeClusterTrialArray('140536','110824')
Whisker.makeClusterTrialArray('140536','110825')
Whisker.makeClusterTrialArray('140536','110826')
Whisker.makeClusterTrialArray('144441','110809')
Whisker.makeClusterTrialArray('144441','110810')
Whisker.makeClusterTrialArray('144441','110815')
Whisker.makeClusterTrialArray('144441','110816')
Whisker.makeClusterTrialArray('144442','110810')
Whisker.makeClusterTrialArray('144442','110812')
Whisker.makeClusterTrialArray('144442','110813')
Whisker.makeClusterTrialArray('144442','110814')
Whisker.makeClusterTrialArray('144443','110811')
Whisker.makeClusterTrialArray('144443','110812')
Whisker.makeClusterTrialArray('144443','110813')
Whisker.makeClusterTrialArray('144443','110814')
Whisker.makeClusterTrialArray('144443','110815')
Whisker.makeClusterTrialArray('144443','110816')
Whisker.makeClusterTrialArray('144443','110818')
Whisker.makeClusterTrialArray('144444','110823')
Whisker.makeClusterTrialArray('144444','110824')

%%
whiskerTIN                          = find(T.whiskerTrialInds);

for k = whiskerTIN
    spikes{k}.count = reshape(contacts{k}.spikeCount{1}(repmat(contacts{k}.spikeUseFlag{1}==1,size(contacts{k}.spikeCount{1},1),1)),...
    size(contacts{k}.spikeCount{1},1),sum(contacts{k}.spikeUseFlag{1}==1)); 
    spikes{k}.cells = find(contacts{k}.spikeUseFlag{1}==1);
    spikes{k}.meanRate = spikes{k}.count ./ repmat(contacts{k}.contactLength{1})
end


    
contacts{k}.contactLength{1}