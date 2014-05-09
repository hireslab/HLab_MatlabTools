% Basic Setup
whiskerTIN  = find(T.whiskerTrialInds)
timeWindow  = [.01 .050];
maxConNum   = 10;
proConSR    ={};
useFlag     ={};
csind       ={};
cind        ={};

wfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.whiskerTrial.framePeriodInSec; % Whisker Frame Duration
sfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.shanksTrial.sampleRate; % Spike Sampling Rate
wTTO       = T.whiskerTrialTimeOffset;
time(whiskerTIN) = cellfun(@(x)x.whiskerTrial.time{1}, T.trials(whiskerTIN),'UniformOutput',0);

% Setup Contact Indicies
proCon = whiskerTIN(cellfun(@(x)x.trialContactType == 1,contacts(whiskerTIN)) | ...
    cellfun(@(x)x.trialContactType == 3,contacts(whiskerTIN)));

retCon = whiskerTIN(cellfun(@(x)x.trialContactType == 2,contacts(whiskerTIN)) | ...
    cellfun(@(x)x.trialContactType == 4,contacts(whiskerTIN)));


proConM0 = cell(maxConNum,1);
retConM0 = cell(maxConNum,1);

% SpikeTimes is {trials}{clusts}(spikeTime)
for i=1:length(contacts)
    spikeTimes{i} = cellfun(@(x)x.spikeTimes,T.trials{i}.shanksTrial.clustData,'UniformOutput',0);
end

for conNum = 1:maxConNum
    proConM0{conNum} = nan(max(whiskerTIN),1);
    retConM0{conNum} = nan(max(whiskerTIN),1);

    %protraction Contacts
    proCind{conNum} = proCon(  cellfun(@(x)~isempty(x.segmentInds{1})             ,contacts(proCon))); % limit to trials with i number of contacts
    proCind{conNum} = proCind{conNum}(    cellfun(@(x)numel(x.segmentInds{1}(:,1)) >= conNum ,contacts(proCind{conNum}))); % limit to trials with i number of contacts
    proCind{conNum} = proCind{conNum}(    cellfun(@(x)x.segmentInds{1}(conNum,1) < 1750      ,contacts(proCind{conNum}))); % limit to trials where i-th contact comes before answer Lick
    proCind{conNum} = proCind{conNum}(    cellfun(@(x)x.meanM0adj{1}(conNum) < -3e-8      ,contacts(proCind{conNum}))); % limit to trials where i-th contact comes before answer Lick

    proConM0{conNum}(proCind{conNum}) =   cellfun(@(x)x.meanM0adj{1}(conNum)      ,contacts(proCind{conNum})); % get mean force
   
        %retraction Contacts
    retCind{conNum} = retCon(  cellfun(@(x)~isempty(x.segmentInds{1})             ,contacts(retCon))); % limit to trials with i number of contacts
    retCind{conNum} = retCind{conNum}(    cellfun(@(x)numel(x.segmentInds{1}(:,1)) >= conNum ,contacts(retCind{conNum}))); % limit to trials with i number of contacts
    retCind{conNum} = retCind{conNum}(    cellfun(@(x)x.segmentInds{1}(conNum,1) < 1750      ,contacts(retCind{conNum}))); % limit to trials where i-th contact comes before answer Lick
    retCind{conNum} = retCind{conNum}(    cellfun(@(x)x.meanM0adj{1}(conNum) > 3e-8      ,contacts(retCind{conNum}))); % limit to trials where i-th contact comes before answer Lick

    retConM0{conNum}(retCind{conNum}) =   cellfun(@(x)x.meanM0adj{1}(conNum)      ,contacts(retCind{conNum})); % get mean force
   
    
    %proConM0 is {contact}(trial)
    
    %proConSR{i} =   cellfun(@(x)x.meanM0adj{1}(i)                 ,contacts(proCind{conNum})); % get mean force
    
    % build spike rate as {clust}{contact}(trial)
    for clust = 1:length(T.cellNum);
        proConSR{clust}{conNum} = nan(max(whiskerTIN),1); % initialize spikerate array
        retConSR{clust}{conNum} = nan(max(whiskerTIN),1); % initialize spikerate array

        proUseFlag{clust} = cellfun(@(x)x.shanksTrial.clustData{clust}.useFlag, T.trials(proCind{conNum})); % find trials with valid spike data
        proCSind{clust}{conNum}   = proCind{conNum}(find(proUseFlag{clust})); % contacts with vaild spike data for this cluster
        
        retUseFlag{clust} = cellfun(@(x)x.shanksTrial.clustData{clust}.useFlag, T.trials(retCind{conNum})); % find trials with valid spike data
        retCSind{clust}{conNum}   = retCind{conNum}(find(retUseFlag{clust})); % contacts with vaild spike data for this cluster
 
        for trial = proCSind{clust}{conNum};
            shiftSpikes = double(spikeTimes{trial}{clust}) / sfS + wTTO - ...
                time{trial}(contacts{trial}.segmentInds{1}(conNum,1)); % Timeshift all spikeTimes for the trial
            proConSR{clust}{conNum}(trial) = sum(shiftSpikes > timeWindow(1) & shiftSpikes < timeWindow(2)) / diff(timeWindow);
        end
        
             for trial = retCSind{clust}{conNum};
            shiftSpikes = double(spikeTimes{trial}{clust}) / sfS + wTTO - ...
                time{trial}(contacts{trial}.segmentInds{1}(conNum,1)); % Timeshift all spikeTimes for the trial
            retConSR{clust}{conNum}(trial) = sum(shiftSpikes > timeWindow(1) & shiftSpikes < timeWindow(2)) / diff(timeWindow);
        end
    end
end

%% Plotting output
figure(12);clf;hold on

for clust = 1:length(T.cellNum)
subplot(4,5,clust);hold on

colors = jet(3);
for conNum = 1:3;
    %protraction
    x_prepro = proConM0{conNum}(proCSind{clust}{conNum});
    y_prepro = proConSR{clust}{conNum}(proCSind{clust}{conNum});
    x_pro = x_prepro(~isnan(x_prepro) & ~isnan(y_prepro));
    y_pro = y_prepro(~isnan(x_prepro) & ~isnan(y_prepro));
    
    %retraction
    x_preret = retConM0{conNum}(retCSind{clust}{conNum});
    y_preret = retConSR{clust}{conNum}(retCSind{clust}{conNum});
    x_ret = x_preret(~isnan(x_preret) & ~isnan(y_preret));
    y_ret = y_preret(~isnan(x_preret) & ~isnan(y_preret));
    
    [p_pro,s_pro] = polyfit(x_pro,y_pro,1);
    [p_ret,s_ret] = polyfit(x_ret,y_ret,1);
    %plot(x,y,'.','Color',colors(conNum,:))
    plot(sort(x_pro),polyval(p_pro,sort(x_pro)),'Color',colors(conNum,:))
    plot(sort(x_ret),polyval(p_ret,sort(x_ret)),'Color',colors(conNum,:))
    set(gca,'YLim',[0 80])
end
end