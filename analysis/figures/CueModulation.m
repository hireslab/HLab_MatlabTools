% cue modulation
depth = -cellfun(@(x)x(3),SU.recordingLocation);


%% High Performing region
figure(1);clf
% Panel A : Peak Pre cue / baseline
subplot(2,3,1)
plot(depth,([cueResponse.poleInCRpeak{:,1}]-[cueResponse.poleInBR{:,1}])./[cueResponse.poleInBR{:,1}],'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel B : Zscore Pre cue
subplot(2,3,2)
plot(depth,([cueResponse.poleInCRpeak{:,1}]-[cueResponse.poleInBR{:,1}])./[cueResponse.poleInBRstd{:,1}],'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel C : Total Spikes Added PreCue
subplot(2,3,3)
plot(depth,([cueResponse.poleInCRmean{:,1}]-[cueResponse.poleInBR{:,1}])*.08,'o');
title('Total Spikes Added')
ylabel('Spikes Added')

% Panel D : Peak Post cue / baseline
subplot(2,3,4)
plot(depth,([cueResponse.poleOutCRpeak{:,1}]-[cueResponse.poleOutBR{:,1}])./[cueResponse.poleOutBR{:,1}],'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel E : Zscore Post cue
subplot(2,3,5)
plot(depth,([cueResponse.poleOutCRpeak{:,1}]-[cueResponse.poleOutBR{:,1}])./[cueResponse.poleOutBRstd{:,1}],'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel F : Total Spikes Added PostCue
subplot(2,3,6)
plot(depth,([cueResponse.poleOutCRmean{:,1}]-[cueResponse.poleOutBR{:,1}])*.08,'o');
title('Total Spikes Added')
ylabel('Spikes Added')

%% Non-Performing region
figure(2);clf
postPerfCells = [4 8 9 17 19 21 22 26 28 32 46];

% Panel A : Peak Pre cue / baseline
subplot(2,3,1)
plot(depth(postPerfCells),([cueResponse.poleInCRpeak{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])./[cueResponse.poleInBR{postPerfCells,2}],'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel B : Zscore Pre cue
subplot(2,3,2)
plot(depth(postPerfCells),([cueResponse.poleInCRpeak{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])./[cueResponse.poleInBRstd{postPerfCells,2}],'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel C : Total Spikes Added PreCue
subplot(2,3,3)
plot(depth(postPerfCells),([cueResponse.poleInCRmean{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])*.08,'o');
title('Total Spikes Added')
ylabel('Spikes Added')

% Panel D : Peak Post cue / baseline
subplot(2,3,4)
plot(depth(postPerfCells),([cueResponse.poleOutCRpeak{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])./[cueResponse.poleOutBR{postPerfCells,2}],'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel E : Zscore Post cue
subplot(2,3,5)
plot(depth(postPerfCells),([cueResponse.poleOutCRpeak{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])./[cueResponse.poleOutBRstd{postPerfCells,2}],'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel F : Total Spikes Added PostCue
subplot(2,3,6)
plot(depth(postPerfCells),([cueResponse.poleOutCRmean{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])*.08,'o');
title('Total Spikes Added')
ylabel('Spikes Added')

%% Non-Performing Vs. Performing region
figure(3);clf
postPerfCells = [4 8 9 17 19 21 22 26 28 32 46];

% Panel A : Peak Pre cue / baseline
subplot(2,3,1)
plot(depth(postPerfCells),(([cueResponse.poleInCRpeak{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])./[cueResponse.poleInBR{postPerfCells,2}]./...
    ([cueResponse.poleInCRpeak{postPerfCells,1}]-[cueResponse.poleInBR{postPerfCells,1}])./[cueResponse.poleInBR{postPerfCells,1}]),'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel B : Zscore Pre cue
subplot(2,3,2)
plot(depth(postPerfCells),(([cueResponse.poleInCRpeak{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])./[cueResponse.poleInBRstd{postPerfCells,2}]./...
    ([cueResponse.poleInCRpeak{postPerfCells,1}]-[cueResponse.poleInBR{postPerfCells,1}])./[cueResponse.poleInBRstd{postPerfCells,1}]),'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel C : Total Spikes Added Pre Vs Post Cue
subplot(2,3,3)
plot(depth(postPerfCells),([cueResponse.poleInCRmean{postPerfCells,2}]-[cueResponse.poleInBR{postPerfCells,2}])*.08./(([cueResponse.poleInCRmean{postPerfCells,1}]-[cueResponse.poleInBR{postPerfCells,1}])*.08),'o');
title('Total Spikes Added')
ylabel('Spikes Added')

% Panel D : Peak Post cue / baseline
subplot(2,3,4)
plot(depth(postPerfCells),([cueResponse.poleOutCRpeak{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])./[cueResponse.poleOutBR{postPerfCells,2}],'o');
title('Peak Modulation')
ylabel('Mod Depth')
% Panel E : Zscore Post cue
subplot(2,3,5)
plot(depth(postPerfCells),([cueResponse.poleOutCRpeak{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])./[cueResponse.poleOutBRstd{postPerfCells,2}],'o');
title('Peak Z-score')
ylabel('Z-score')

% Panel F : Total Spikes Added PostCue
subplot(2,3,6)
plot(depth(postPerfCells),([cueResponse.poleOutCRmean{postPerfCells,2}]-[cueResponse.poleOutBR{postPerfCells,2}])*.08,'o');
title('Total Spikes Added')
ylabel('Spikes Added')
