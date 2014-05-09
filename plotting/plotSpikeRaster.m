function plotSpikeRaster(spikeArray)

% Simple plotter for spike index arrays
%
% USAGE : 
% 
% plotSpikesRaster(spikeArray)
%
% spikeArray is a binary 2d array of spike presence or absence
% trials x timepoints
%

%figure(10);clf;hold on
for i = 1:size(spikeArray,1)
    if sum(spikeArray(i,:))>0
    plot([1; 1]*find(spikeArray(i,:)), i+[-.5; .5],'k')
    end
end
ylabel('Trials')
xlabel('Time')
