function contacts=addContact(toAdd)

%% Trial Primary Contact Type Determination
%
% Estimates contact times of the whisker into the pole.  Good results
% requires a very accurate .bar file and accurate touch thresholds.  Four
% touch thresholds are used, for go (protraction, retraction), no-go
% (protraction,retraction).  These should be determined by visual
% inspection of the distanceToPoleCenter plots in several example trials,
% in concert with the video of the trial. Use Parameter Estimation cell to
% help.
%
% In general, k represents a trial number, i represents some event number
% in the trial (contact, spike).
%
% First use some generous limits for the touchThresh values.  Then, use the
% plot output of the Contact Segmenter cell to refine the touchThresh
% values and rerun the Trial Primary Contact Type Determination
%
% Use Parameter Estimation cell to check how well the contacts are being
% scored (currently broken?)
%
%
% Currently designed to work only with 1 whisker, but could be modified to
% analyze a specific tid.
%
% Designed to be used with the Whisker.WhiskerTrialLiteI subclass, which
% has two additional fields, M0I: Holds the acceleration calculated moment
%                            contactInds: Index of contact times
%
% Pulls data from T.trials{k}.whiskerTrial.M0I
% Stores data to a subclassed field : T.trials{k}.whiskerTrial.contactInds
% Also writes a contacts{k} structure to the workspace that contains all
% the analysis output.
%
% Version 0.1.0 SAH 06/07/10
%
%
%


%% Contact Segmenter
%
% Segmentation of contacts into an ordered list.  Each trial gets its own
% cell within the contacts structure.  Analysis of each contact resides in
% within fields of contacts{k}, where k is the trial index.
% (k ~= overall trial number)
%
% This cell also plots the distance to pole of the first trial of each
% class (go pro/ret, nogo pro/ret)

h_app    = getappdata(0);
h_pBG    = h_app.hParamBrowserGui;
pBG_data = getappdata(h_pBG);

array    = pBG_data.array;
params   = pBG_data.params;
contacts = pBG_data.contacts;

whiskerTIN = params.sweepNum;

framePeriodInSec                    = 1000;
if isfield('shanksTrial',array.trials{1})
    sampleRate                          = array.trials{1}.shanksTrial.sampleRate;
elseif isfield('spikesTrial',array.trials{1})
    
    sampleRate                          = array.trials{1}.spikesTrial.sampleRate;
end

if ~isfield(contacts{whiskerTIN},'manualAdd')
    contacts{whiskerTIN}.manualAdd{1} = [];
end
if ~isfield(contacts{whiskerTIN},'manualDel')
    contacts{whiskerTIN}.manualDel{1} = [];
end


contacts{whiskerTIN}.manualAdd{1}   = unique(cat(2,toAdd,contacts{whiskerTIN}.manualAdd{1}));

contacts{whiskerTIN}.manualDel{1}   = setdiff(contacts{whiskerTIN}.manualDel{1},contacts{whiskerTIN}.manualAdd{1});
contacts{whiskerTIN}.contactInds{1} = unique(cat(2,contacts{whiskerTIN}.manualAdd{1},contacts{whiskerTIN}.contactInds{1}));
M0(whiskerTIN)                      = cellfun(@(x)x.whiskerTrial.M0{1},   array.trials(whiskerTIN),'UniformOutput',0);
time(whiskerTIN)                    = cellfun(@(x)x.whiskerTrial.time{1}, array.trials(whiskerTIN),'UniformOutput',0);




for k=whiskerTIN;
    if isempty(contacts{k}.contactInds{1})==0;
        contacts{k}.segmentInds{1}=[];
        contacts{k}.segmentInds{1}(:,1)=contacts{k}.contactInds{1}([1 find(diff(contacts{k}.contactInds{1})>4)+1]);   % don't switch back to intertial if the tracking disappears for 1-3 frames
        contacts{k}.segmentInds{1}(:,2)=contacts{k}.contactInds{1}([find(diff(contacts{k}.contactInds{1})>4) end]);
        ind=[];
        
        for i=1:length(contacts{k}.segmentInds{1}(:,1))
            ind=cat(2,ind,contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2));
        end
        
        contacts{k}.inferredInds{1} = setdiff(ind,contacts{k}.contactInds{1});
        contacts{k}.contactInds{1} = ind;
    else
        contacts{k}.segmentInds={[]};
        trialContactType(k)=0;
    end
    
    
end



%% Contact Characterizer

% Find mean M0 for each contact

disp('Finding mean M0 for each contact')

for k = whiskerTIN
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.meanM0{1}(i)=nanmean(M0{k}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
        
        contacts{k}.meanM0={[]};
    end
end

% Find peak M0 for each contact

disp('Find peak M0 for each contact')

for k = whiskerTIN
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakM0{1}(i)=max(abs(M0{k}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2))))*...
                sign(contacts{k}.meanM0{1}(i));
        end
    else
        contacts{k}.peakM0={[]};
    end
end

% Find spikes associated with each contact

disp('Finding spikes associated with each contact')

if isfield('shanksTrial',array.trials{1})
    for k = whiskerTIN
        if isempty(contacts{k}.segmentInds{1}) == 0
            for i=1:length(contacts{k}.segmentInds{1}(:,1));
                lim = time{k}(contacts{k}.segmentInds{1}(i,:)) + params.spikeSynapticOffset;
                contacts{k}.spikeCount{1}(i,:) = cellfun(@(x)...
                    sum(double(x.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset > lim(1)...
                    & double(x.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset < lim(2)),...
                    array.trials{k}.shanksTrial.clustData);
            end
        else
            contacts{k}.spikeCount={[]};
        end
    end
elseif isfield('spikesTrial',array.trials{1})
    
    for k = whiskerTIN
        if isempty(contacts{k}.segmentInds{1}) == 0
            for i=1:length(contacts{k}.segmentInds{1}(:,1));
                lim = time{k}(contacts{k}.segmentInds{1}(i,:)) + params.spikeSynapticOffset;
                contacts{k}.spikeCount{1}(i,:) = sum(double(array.trials{k}.spikesTrial.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset > lim(1)...
                    & double(array.trials{k}.spikesTrial.spikeTimes) / sampleRate - array.whiskerTrialTimeOffset < lim(2));
            end
        else
            contacts{k}.spikeCount={[]};
        end
    end
else
end



% Find timelength for each contact

disp('Finding timelength for each contact')

for k = whiskerTIN
    if isempty(contacts{k}.segmentInds{1})==0
        contacts{k}.contactLength{1}=time{k}(contacts{k}.segmentInds{1}(:,2))-time{k}(contacts{k}.segmentInds{1}(:,1));
    else
        contacts{k}.contactLength={[]};
    end
end

disp('Merging contact/curvature-derived moment (M0) and axial force (FaxialAdj) with acceleration based moment (M0I)')



% Find mean M0 for each contact

disp('Finding mean Faxial for each contact')

for k = whiskerTIN
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.meanFaxial{1}(i)=nanmean(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
        
        contacts{k}.meanFaxial={[]};
    end
end

% Find peak M0 for each contact

disp('Find peak Faxial for each contact')
for k = whiskerTIN
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakFaxial{1}(i)=min(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
        contacts{k}.peakFaxial={[]};
    end
end


setappdata(h_pBG,'contacts',contacts);

assignin('base','contacts',contacts);
display('Contact Added')

