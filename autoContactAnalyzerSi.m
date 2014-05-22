function [contacts, params]=autoContactAnalyzerSi(array, params, contacts, varargin)

% Version 0.5.0 SAH 110827





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
if nargin==1
    [contacts, params] = buildNewContactArray(array);
    
elseif nargin == 2
    
    [contacts, params] = buildNewContactArray(array,params);

else   
end

whiskerTIN                          = find(array.whiskerTrialInds);
% goTrialNums                         = cat(1,array.missTrialNums(:),array.hitTrialNums(:));
trialNums                           = array.trialNums;

pinDescentOnsetTime(whiskerTIN)     = cellfun(@(x)x.behavTrial.pinDescentOnsetTime,array.trials(whiskerTIN),'UniformOutput',0);
pinAscentOnsetTime(whiskerTIN)      = cellfun(@(x)x.behavTrial.pinAscentOnsetTime,array.trials(whiskerTIN),'UniformOutput',0);

time(whiskerTIN)                    = cellfun(@(x)x.whiskerTrial.time{1},                   array.trials(whiskerTIN),'UniformOutput',0);
distanceToPoleCenter(whiskerTIN)    = cellfun(@(x)x.whiskerTrial.distanceToPoleCenter{1},   array.trials(whiskerTIN),'UniformOutput',0);
kappa(whiskerTIN)                   = cellfun(@(x)x.whiskerTrial.deltaKappa{1},             array.trials(whiskerTIN),'UniformOutput',0);
% thetaAtBase(whiskerTIN)             = cellfun(@(x)x.whiskerTrial.thetaAtBase{1},            array.trials(whiskerTIN),'UniformOutput',0);
% thetaAtContact(whiskerTIN)          = cellfun(@(x)x.whiskerTrial.thetaAtContact{1},         array.trials(whiskerTIN),'UniformOutput',0);
M0(whiskerTIN)                      = cellfun(@(x)x.whiskerTrial.M0{1},                     array.trials(whiskerTIN),'UniformOutput',0); 
M0I(whiskerTIN)                     = cellfun(@(x)x.whiskerTrial.M0I{1},                    array.trials(whiskerTIN),'UniformOutput',0); 
Faxial(whiskerTIN)                  = cellfun(@(x)x.whiskerTrial.Faxial{1},                 array.trials(whiskerTIN),'UniformOutput',0); 
trialClass(whiskerTIN)              = cellfun(@(x)x.trialType*2 + x.trialCorrect + 1,       array.trials(whiskerTIN),'UniformOutput',0);
answerLickTime                      = cellfun(@(x)x.behavTrial.answerLickTime,              array.trials            ,'UniformOutput',0);

meanContactCurve = zeros(max(whiskerTIN),1);
trialContactType = zeros(max(whiskerTIN),1);

% use new parameters but retain manually scored contacts

if nargin == 3

        addFieldIdx = find(cellfun(@(x)isfield(x,'manualAdd'),contacts));
        delFieldIdx = find(cellfun(@(x)isfield(x,'manualAdd'),contacts));

        addContactInds(addFieldIdx) = cellfun(@(x)x.manualAdd{1},contacts(addFieldIdx),'UniformOutput',0);
        delContactInds(delFieldIdx) = cellfun(@(x)x.manualAdd{1},contacts(delFieldIdx),'UniformOutput',0);

        contacts = buildNewContactArray(array,params);

    for i = addFieldIdx
        contacts{i}.manualAdd{1} = addContactInds{i};
        contacts{i}.contactInds{1} = unique(cat(2,contacts{i}.manualAdd{1}(:)',contacts{i}.contactInds{1}(:)'));
    end

    for i = delFieldIdx
        contacts{i}.manualDel{1} = delContactInds{i};
        contacts{i}.contactInds{1} = unique(cat(2,contacts{i}.manualDel{1}(:)',contacts{i}.contactInds{1}(:)'));

    end


    

   
end



%% Contact Segmenter
% 
% Segmentation of contacts into an ordered list.  Each trial gets its own
% cell within the contacts structure.  Analysis of each contact resides in
% within fields of contacts{k}, where k is the trial index. 
% (k ~= overall trial number)
%
% This cell also plots the distance to pole of the first trial of each
% class (go pro/ret, nogo pro/ret)


if nargin <= 3;


    for k=whiskerTIN;
        if isempty(contacts{k}.contactInds{1})==0;
            contacts{k}.contactInds{1} = contacts{k}.contactInds{1}(contacts{k}.contactInds{1}>array.trials{k}.pinDescentOnsetTime*1000);

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

end

%cellfun(@(x)x.trialContactType,contacts)

if nargin ==4
    argString = varargin{1};
end

    % just recalculate dependent fields


%% Contact Characterizer


% Find timelength for each contact

disp('Finding timelength for each contact')

for k = whiskerTIN 
    if isempty(contacts{k}.segmentInds{1})==0
        contacts{k}.contactLength{1}=time{k}(contacts{k}.segmentInds{1}(:,2))-time{k}(contacts{k}.segmentInds{1}(:,1));
    else
        contacts{k}.contactLength={[]};
    end
end

% Find precontact curvature to adjust force calculations

for k = whiskerTIN
    cLookBack = 3; % in frames
        if isempty(contacts{k}.segmentInds{1})==0
            for i =1:size(contacts{k}.segmentInds{1},1);
                contacts{k}.preConCurve{1}(i) = ...
                    mean(array.trials{k}.whiskerTrial.deltaKappa{1}(contacts{k}.segmentInds{1}(i,1)-(1:cLookBack)));
            end
        else
            contacts{k}.preConCurve{1} = [];
            
        end
end

disp('Merging contact/curvature-derived moment (M0) and axial force (FaxialAdj) with acceleration based moment (M0I)')

M0combo=cell(1,length(array.trials)); % Combined moment calculated from acceleration for non-contact periods and curvature from contact periods.

for k = whiskerTIN ;
    contacts{k}.M0combo{1}=M0I{k};
    contacts{k}.M0combo{1}(abs(contacts{k}.M0combo{1})>1e-7)=NaN;

    contacts{k}.Faxial{1}=zeros(1,length(Faxial{k}));

    if isnan(contacts{k}.contactInds{1})==0
        ind=[];
        for i=1:length(contacts{k}.segmentInds{1}(:,1))
            ind=cat(2,ind,contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2));
        end
        contacts{k}.M0combo{1}(ind)=M0{k}(ind);   % build M0Combo from the Segment Inds that have had the 1-2 frame drops filtered out
        contacts{k}.Faxial{1}(ind)=Faxial{k}(ind);
        
    else

    end
end

% Generate M0comboAdj FaxialAdj to shift baseline curvature for each contact period

for k=whiskerTIN
    contacts{k}.M0comboAdj = contacts{k}.M0combo;
    contacts{k}.FaxialAdj = contacts{k}.Faxial;

    for j=1:size(contacts{k}.segmentInds{1},1)
        adjind=contacts{k}.segmentInds{1}(j,1):contacts{k}.segmentInds{1}(j,2);

        contacts{k}.M0comboAdj{1}(adjind) = contacts{k}.M0combo{1}(adjind)...
            .* (1-contacts{k}.preConCurve{1}(j) ./ array.trials{k}.whiskerTrial.deltaKappa{1}(adjind));
        contacts{k}.FaxialAdj{1}(adjind) = contacts{k}.Faxial{1}(adjind)...
            .* (1-contacts{k}.preConCurve{1}(j) ./ array.trials{k}.whiskerTrial.deltaKappa{1}(adjind));
    end
end
         

% Find mean M0 for each contact

disp('Finding mean M0 for each contact')

contacts{1}.meanM0={[]};   
for k = whiskerTIN 
         meanContactCurve(k)=nanmean(kappa{k}(contacts{k}.contactInds{1}));

    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
                    contacts{k}.meanM0{1}(i)=nanmean(M0{k}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
                    contacts{k}.meanM0adj{1}(i)=nanmean(contacts{k}.M0comboAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));


        end
    else
        
        contacts{k}.meanM0={[]};   
        contacts{k}.meanM0adj={[]};   

    end
end

% Find peak M0 for each contact

disp('Find peak M0 for each contact')

contacts{1}.peakM0={[]};   
for k = whiskerTIN 
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakM0{1}(i)=max(abs(M0{k}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2))))*...
                sign(contacts{k}.meanM0{1}(i));
            contacts{k}.peakM0adj{1}(i)=max(abs(contacts{k}.M0comboAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2))))*...
                sign(contacts{k}.meanM0adj{1}(i));

        end
    else
    contacts{k}.peakM0={[]};
    contacts{k}.peakM0adj={[]};   

    end
end



% Find mean Faxial for each contact

disp('Finding mean Faxial for each contact')

contacts{1}.meanFaxial={[]};   
for k = whiskerTIN 
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.meanFaxial{1}(i)=nanmean(contacts{k}.Faxial{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
            contacts{k}.meanFaxialAdj{1}(i)=nanmean(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));

        end
    else
        contacts{k}.meanFaxial={[]}; 
        contacts{k}.meanFaxialAdj={[]};       


        
           
    end
end

% Find peak M0 for each contact

disp('Find peak Faxial for each contact')

contacts{1}.peakFaxial={[]};   
for k = whiskerTIN 
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakFaxial{1}(i)=min(contacts{k}.Faxial{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
            contacts{k}.peakFaxialAdj{1}(i)=min(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
    contacts{k}.peakFaxial={[]};   
    contacts{k}.peakFaxialAdj={[]};   

    end
end

% Find answertime for each contact

contacts{1}.answerLickTime={[]};   
for k = whiskerTIN 
    contacts{k}.answerLickTime=answerLickTime{k};   
end
assignin('base','contacts',contacts);


% %% Plotting Output
% 
% Plot the estimated primary contact type by trial number
    h_analyzer=figure(12);
    set(gcf,'DefaultLineMarkerSize',12)
    subplot(2,3,[2 3]);cla;hold on;
    for k=whiskerTIN
        plot(trialNums(k),meanContactCurve(k), [params.trialcolors{trialClass{k}} '.']);
    end
    plot([trialNums(1) trialNums(end)],[params.goProThresh params.goProThresh],'k:');
    plot([trialNums(1) trialNums(end)],[params.nogoProThresh params.nogoProThresh],'k--');
    
    xlabel('Trial Number');
    ylabel('Mean Contact Curvature (\kappa)');
    grid off
    
    subplot(2,3,[5 6]);cla;hold on
    for k=whiskerTIN
        plot(trialNums(k),contacts{k}.trialContactType, [params.trialcolors{trialClass{k}} '.']);
    end
    axis([trialNums(1) trialNums(end) -.1 4.1])
    xlabel('Trial Number')
    grid on
    set(gca,'YTick',[0 1 2 3 4],'YTickLabel','No Contact | Go Protract | Go Retract | Nogo Protract | Nogo Retract')
    title('estimated primary contact type')
    
    subplot(2,3,1);cla;
   % plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
    text(-.3,.9, ['\fontsize{8}' 'Trajectory ID :\bf ' num2str(params.tid)]);
    text(-.3,.8, ['\fontsize{8}' 'Pole Delay Offset  On :\bf ' num2str(params.poleOffset) '\rm  Off : \bf' num2str(params.poleEndOffset) '(s)']);
    text(-.3,.7, ['\fontsize{8}' 'Pro/Ret Threshold  Go :\bf ' num2str(params.goProThresh) '\rm  NoGo : \bf' num2str(params.nogoProThresh)]);
    text(-.3,.6, ['\fontsize{8}' 'Contact Threshold :\bf ' num2str(params.touchThresh(1)) ' / ' num2str(params.touchThresh(2)) ' / ' num2str(params.touchThresh(3)) ' / ' num2str(params.touchThresh(4))]);
    text(-.3,.5, ['\fontsize{8}' 'Curvature Multiplier :\bf ' num2str(params.curveMultiplier)]);
%    text(-.3,.4, ['\fontsize{8}' 'Mean Spike Rate :\bf ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
    text(-.3,.3, ['\fontsize{8}' 'Mouse :\bf ' array.mouseName]);
%    text(-.3,.2, ['\fontsize{8}' 'Cell :\bf ' array.cellNum '' array.cellCode '' array.mouseName]) ;
 %  text(-.3,.1, ['\fontsize{8}' 'Location :\bf ' num2str([min(array.depth) ) ' \mum' ' ' num2str(array.recordingLocation)]) ;
set(h_analyzer,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])

%%
hitTIN      = intersect(whiskerTIN,find(array.hitTrialInds));
CRTIN       = intersect(whiskerTIN,find(array.correctRejectionTrialInds));
edges       = -.2:.001:.5;
onTrim      = mean(cellfun(@(x)x,pinDescentOnsetTime(whiskerTIN))) + params.poleOffset;
offTrim     = min(cellfun(@(x)x,pinAscentOnsetTime(whiskerTIN)));

n   = zeros(length(CRTIN),length(edges));
n2  = zeros(length(CRTIN),length(edges));
    
hfig_contactThresh = figure(5);

for k=hitTIN
    y = distanceToPoleCenter{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    y2 =  kappa{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
       n(k,:) = histc(y,edges);
       n2(k,:) = histc(y-params.curveMultiplier*abs(y2)-(5*params.curveMultiplier*y2).^2,edges);
       
       
end 

subplot(2,1,1);cla;hold on
       plot(edges+.0005,mean(n))
       plot(edges+.0005,mean(n2),'r')
       
n   = zeros(length(CRTIN),length(edges));
n2  = zeros(length(CRTIN),length(edges));
for k=CRTIN
    y = distanceToPoleCenter{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    y2 =  kappa{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    edges = -.2:.001:.5;
    edges2 = -.2:.001:.5;
       n(k,:) = histc(y,edges);
       n2(k,:) = histc(y-params.curveMultiplier*abs(y2)-5*(params.curveMultiplier*y2).^2,edges);
       
       
end 
       
subplot(2,1,2);cla;
hold on;
plot(edges+.0005,mean(n))
plot(edges2+.0005,mean(n2),'r')
%display('saving contacts');
%save(['Z:\users\Andrew\Whisker Project\Silicon\ConTA\recalc\ConTA_' array.mouseName '_' array.sessionName], 'contacts', 'params');
%print(h_analyzer, '-depsc',[array.mouseName '-' array.cellNum '-' 'contactParams.eps']);


