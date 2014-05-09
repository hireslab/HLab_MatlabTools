%% Setup

tt{1} = find(cellfun(@(x)x.trialContactType==1, contacts));
tt{2} = find(cellfun(@(x)x.trialContactType==2, contacts));
tt{3} = find(cellfun(@(x)x.trialContactType==3, contacts));
tt{4} = find(cellfun(@(x)x.trialContactType==4, contacts));
tt{5} = find(cellfun(@(x)x.trialContactType==0, contacts)); % No Contact

for i = 1:length(T.cellNum);
    spikeUseFlag{i} = find(cellfun(@(x)x.spikeUseFlag{1}(i),contacts));
end

trialNums = T.trialNums;

segmentInds = cellfun(@(x)x.segmentInds{1},contacts,'UniformOutput',0)


cellNum = T.cellNum;
wfS = T.trials{find(T.whiskerTrialInds,1,'first')}.whiskerTrial.framePeriodInSec; % Whisker Frame Duration
sfS = T.trials{find(T.whiskerTrialInds,1,'first')}.shanksTrial.sampleRate; % Spike Sampling Rate
wTTO = T.whiskerTrialTimeOffset; 

for i=1:length(contacts)
    spikeTimes{i} = cellfun(@(x)x.spikeTimes,T.trials{i}.shanksTrial.clustData,'UniformOutput',0);
end

%% Plotting

axisSize = [-1 5 1 length(T.trials)];
axisSizeSeq = [-1 5 1 length(tt{1})];
cAlign = 1;

j=15% cellNumber

% By trial number
figure(2)

for k = 1:4
    subplot(2,2,k);
    cla;hold on;

    for i = intersect(spikeUseFlag{1},tt{k})
        try    
            plot(double(spikeTimes{i}{j})/sfS+wTTO-wfS*segmentInds{i}(cAlign,1),trialNums(i),'k.')
        end   
    end
    axis(axisSize)
end

% By sequential number

figure(3)

for k = 1:3
    subplot(2,2,k);
    cla;hold on;
    p_ind = intersect(spikeUseFlag{1},tt{k})
    for i = 1:length(p_ind)
        try    
            plot(double(spikeTimes{p_ind(i)}{j})/sfS+wTTO-wfS*segmentInds{p_ind(i)}(cAlign,1),i,'k.')
        end   
    end
    axis(axisSizeSeq)
end

%% Find means


cAlign = 1; % Number of contact to align to

j=17% cellNumber


 binSize        = .005; % sec
 startWindow    = -.2 % seconds
 endWindow      = .5; % seconds
 edges          = startWindow:binSize:endWindow;
 
 figure(4)

 for k=1:3
     subplot(2,2,k);cla

     allSpikes{k} = [];

     for i = tt{k}
         try
         allSpikes{k} = cat(1,allSpikes{k},double(spikeTimes{i}{j})/sfS+wTTO-wfS*segmentInds{i}(cAlign,1));
         end
     end
     
    allLength{k} = sum(cellfun(@(x)size(x,1),segmentInds(tt{k}))>=cAlign)
    allHist{k}   = histc(allSpikes{k},edges)/allLength{k}/binSize;
    
    bar(edges+binSize/2,allHist{k})
    set(gca,'Xlim',[startWindow endWindow])
    grid on
 end
 


%
% % chronological
% hfig_calign = figure(13);
% for i=tt{1}
%     for j = 1:length(T.cellNum)
%     T.trials{tt{1}}.shanksTrial.clustData{1}.spikeTimes


