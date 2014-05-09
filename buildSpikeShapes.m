clear spkShape

for j = 36
    
    load(['Z:\Users\Andrew\Whisker Project\SingleUnit\SweepArrays\' SU.sweepArrayName{j}]);
    waves = s.get_spike_waveforms
    max(waves{1}.spikeWaveforms{2})
    peak = {};
    valley = {};
    %spkShape{j}= zeros(30,min(110,length(s))-11);
    for i = 11:min(110,length(s))
        [~,peak{i}] = max(waves{i}.spikeWaveforms{2});
        [~,valley{i}] = min(waves{i}.spikeWaveforms{2}(15:end,:));
        valley{i}(:) = valley{i}(:)+14;
        spkRate{i} = length(waves{i}.spikeWaveforms{1})/s.sweeps{i}.sweepLengthInSamples*10000;
        if ~isempty(waves{i}.spikeWaveforms{2})
            spkShape{j}(:,i) = mean(waves{i}.spikeWaveforms{2},2);
        end
    end
    
    spkWidthTime{j} = smooth([valley{:}]-[peak{:}],1000)/10;
    spkWidthMean{j} = mean([valley{:}]-[peak{:}])/10;
    spkWidthRate{j} = mean([spkRate{:}]);
end

%%
figure(1);clf;hold on
clear sps

for i = 1:52
    sps{i} = mean(spkShape{i},2);
    nspks{i} =(sps{i}-sps{i}(1))/(max(sps{i}-sps{i}(1)));
    plot(nspks{i});
    
end


%%
tmp = [nspks{:}];
sharpIdx = find(tmp(24,:)>-.05&tmp(24,:)<.2 & tmp(19,:)<-.4);

figure(1);clf;hold on

for i = setdiff([1:35 37:52],sharpIdx)

    plot(nspks{i},'k');
    
end

for i = sharpIdx
        plot(nspks{i},'r');
end
