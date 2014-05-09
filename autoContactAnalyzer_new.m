function contacts=autoContactAnalyzer(array, varargin)

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
% Pulls data from T.trials{k}.M0I
% Stores data to a subclassed field : T.trials{k}.contactInds
% Also writes a contacts{k} structure to the workspace that contains all
% the analysis output.
%
% Version 0.1.0 SAH 06/07/10
%
%
%
if nargin==1
    disp('Using default analysis parameters')
    % create default parameters
    contacts=cell(1,length(array.trials));
    params=struct;
    params.touchThresh = [.18 0.05 .3 .3]; %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
    params.goProThresh = -10; % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
    params.nogoProThresh = -15; % Mean curvature above this value indicates probable nogo protraction, below it, a nogo retraction trial.
    params.poleOffset = .768; % Time delay between start of pole motion and where pole becomes accessible
    params.poleEndOffset = .3; % Time between start of pole exit and inaccessiblity
    params.spikeSynapticOffset = .02; % Estimated synaptic delay for assigning spikes to contact epochs
    params.tid=0; % Trajectory id
    params.framesUsed=1:length(array.trials{1}.time{1});
    params.curveMultiplier=1;
    disp(params)
    
else
    disp('Using custom analysis parameters')
    g=varargin{1};
end
    
% Make initial guesses for contact periods
   disp('Determining contact periods')
for k=1:length(array.trials);
    
    if max(cat(1,array.missTrialNums(:),array.hitTrialNums(:))==array.trialNums(k))  %determine trial type
        touchThreshi=max(params.touchThresh(1:2));     % go trials
    else
        touchThreshi=max(params.touchThresh(3:4));     % nogo trials
    end

    % Finds indexes of time periods of contacts by distance to pole - curvature
    contacts{k}.contactInds{1} = array.trials{k}.time{1}(array.trials{k}.distanceToPoleCenter{1} - ...
        params.curveMultiplier*abs(array.trials{k}.kappa{1}) < touchThreshi);  
    
    % Crops indexs to only pole available times
    contacts{k}.contactInds{1}=contacts{k}.contactInds{1}(contacts{k}.contactInds{1} >...
        params.poleOffset+array.trials{k}.behavTrial.pinDescentOnsetTime & contacts{k}.contactInds{1} < params.poleEndOffset +array.trials{k}.behavTrial.pinAscentOnsetTime );

    [~,~,contacts{k}.contactInds{1}]=intersect(contacts{k}.contactInds{1},array.trials{k}.time{1});

    % Calculate the mean curvature during contact period
    meanContactCurve(k)=mean(array.trials{k}.thetaAtBase{1}(contacts{k}.contactInds{1})-array.trials{k}.thetaAtContact{1}(contacts{k}.contactInds{1}));

end




% Determine if contacts are protraction or retraction and refine contact
% periods
 disp('Determining contact directions and refining contact periods')
for k=1:length(array.trials);

    if max(cat(1,array.missTrialNums(:),array.hitTrialNums(:))==array.trialNums(k))
        if meanContactCurve(k)>params.goProThresh
            touchThreshi=params.touchThresh(1); % use go / protraction threshold
            trialContactType(k)=1;
        else
            touchThreshi=params.touchThresh(2); % use go / retraction threshold
            trialContactType(k)=2;
        end
        
    else
        if meanContactCurve(k)>params.nogoProThresh
            touchThreshi=params.touchThresh(3); % use no-go / protraction threshold
            trialContactType(k)=3;
        else
            touchThreshi=params.touchThresh(4); % use no-go / retraction threshold
            trialContactType(k)=4;
        end
        
    end
    

    % Finds indexes of time periods of contacts by distance to pole - curvature
    contacts{k}.contactInds{1} = array.trials{k}.time{1}(array.trials{k}.distanceToPoleCenter{1}...
        - params.curveMultiplier*abs(array.trials{k}.kappa{1}) <touchThreshi);

    % Crops contact indexes to only pole available times
    contacts{k}.contactInds{1} = ...
        contacts{k}.contactInds{1}(contacts{k}.contactInds{1} > params.poleOffset+array.trials{k}.behavTrial.pinDescentOnsetTime ...
        & contacts{k}.contactInds{1} < params.poleEndOffset+array.trials{k}.behavTrial.pinAscentOnsetTime );

    [~,~,contacts{k}.contactInds{1}]=intersect(contacts{k}.contactInds{1},array.trials{k}.time{1}); % c, ia are unused

     % Recalculate mean contact curvature with refined contacts
     meanContactCurve(k)=nanmean(array.trials{k}.thetaAtBase{1}(contacts{k}.contactInds{1})-array.trials{k}.thetaAtContact{1}(contacts{k}.contactInds{1}));
    
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

ind=[];


for k=1:length(array.trials);
    contacts{k}.trialContactType=0;
end
for k=1:length(array.trials);
    if isempty(contacts{k}.contactInds{1})==0;
        contacts{k}.segmentInds{1}(:,1)=contacts{k}.contactInds{1}([1 find(diff(contacts{k}.contactInds{1})>3)+1]);   % don't switch back to intertial if the tracking disappears for 1-2 frames
        contacts{k}.segmentInds{1}(:,2)=contacts{k}.contactInds{1}([find(diff(contacts{k}.contactInds{1})>3) end]);
    
        for i=1:length(contacts{k}.segmentInds{1}(:,1))  
            ind=cat(2,ind,contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2));
        end
        
    else
        contacts{k}.segmentInds={[]};
        trialContactType(k)=0;
    end
    
    contacts{k}.trialContactType=trialContactType(k);

end



%% Contact Characterizer

% Find mean M0 for each contact

disp('Finding mean M0 for each contact')

contacts{1}.meanM0={[]};   
for k=1:length(array.trials);
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.meanM0{1}(i)=nanmean(array.trials{k}.M0{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
        
        contacts{k}.meanM0={[]};   
    end
end

% Find peak M0 for each contact

disp('Find peak M0 for each contact')

contacts{1}.peakM0={[]};   
for k=1:length(array.trials);
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakM0{1}(i)=max(abs(array.trials{k}.M0{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2))))*...
                sign(contacts{k}.meanM0{1}(i));
        end
    else
    contacts{k}.peakM0={[]};   
    end
end

% Find spikes associated with each contact
 
disp('Finding spikes associated with each contact')

for k=find(array.whiskerTrialInds)
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            lim=array.trials{k}.framePeriodInSec*contacts{k}.segmentInds{1}(i,:)+params.spikeSynapticOffset;
            contacts{k}.spikeCount{1}(i)=sum(array.trials{k}.spikesTrial.spikeTimes/10000-array.whiskerTrialTimeOffset>lim(1)...
                & array.trials{k}.spikesTrial.spikeTimes/10000-array.whiskerTrialTimeOffset<lim(2));
        end
    else
        contacts{k}.spikeCount={[]};
    end
end

% Find timele   ngth for each contact

disp('Finding timelength for each contact')

for k=1:length(array.trials);
    if isempty(contacts{k}.segmentInds{1})==0
        contacts{k}.contactLength{1}=array.trials{k}.time{1}(contacts{k}.segmentInds{1}(:,2))-array.trials{k}.time{1}(contacts{k}.segmentInds{1}(:,1));
    else
        contacts{k}.contactLength={[]};
    end
end

disp('Merging contact/curvature-derived moment (M0) and axial force (FaxialAdj) with acceleration based moment (M0I)')

M0combo=cell(1,length(array.trials)); % Combined moment calculated from acceleration for non-contact periods and curvature from contact periods.

for k=1:length(array.trials);
    
    th = array.trials{k}.thetaAtBase{1};
    t  = array.trials{k}.time{1};       

    m=18.8e-9; % Mass of whisker in kilograms
    h=16e-3; % length of whisker in m
    r=33.5e-6; % radius of whisker at base in m

    I=3/20*m*(r^2+4*h^2)+m*h^2/16;
    contacts{k}.M0combo{1}= I*([0 0 diff(diff(smooth(deg2rad(th),3)))']./[0 diff(t)].^2);
           
    %contacts{k}.M0combo{1}=array.trials{k}.M0I{1};
    contacts{k}.M0combo{1}(find(abs(contacts{k}.M0combo{1})>1e-7))=NaN;

    contacts{k}.FaxialAdj{1}=zeros(1,length(array.trials{k}.Faxial{1}));

    if isnan(contacts{k}.contactInds{1})==0
        ind=[];
        for i=1:length(contacts{k}.segmentInds{1}(:,1))
            ind=cat(2,ind,contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2));
        end
        contacts{k}.M0combo{1}(ind)=array.trials{k}.M0{1}(ind);   % build M0Combo from the Segment Inds that have had the 1-2 frame drops filtered out
        contacts{k}.FaxialAdj{1}(ind)=array.trials{k}.Faxial{1}(ind);
        
    else

    end
end

% Find mean M0 for each contact

disp('Finding mean M0 for each contact')

contacts{1}.meanFaxial={[]};   
for k=1:length(array.trials);
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.meanFaxial{1}(i)=nanmean(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
        
        contacts{k}.meanFaxial={[]};       
    end
end

% Find peak M0 for each contact

disp('Find peak M0 for each contact')

contacts{1}.peakFaxial={[]};   
for k=1:length(array.trials);
    
    if isempty(contacts{k}.segmentInds{1})==0
        for i=1:length(contacts{k}.segmentInds{1}(:,1));
            contacts{k}.peakFaxial{1}(i)=min(contacts{k}.FaxialAdj{1}(contacts{k}.segmentInds{1}(i,1):contacts{k}.segmentInds{1}(i,2)));
        end
    else
    contacts{k}.peakFaxial={[]};   
    end
end

% Find answertime for each contact

contacts{1}.answerLickTime={[]};   
for k=1:length(array.trials);
    contacts{k}.answerLickTime=array.trials{7}.behavTrial.answerLickTime;   
end
assignin('base','contacts',contacts);


% %% Plotting Output
% 
% Plot the estimated primary contact type by trial number
    h_analyzer=figure;
    set(gcf,'DefaultLineMarkerSize',12)
    subplot(2,3,[2 3]);
    plot(array.trialNums,meanContactCurve,'.');
    xlabel('Trial Number');
    ylabel('Mean Contact Curvature (\kappa)');
    grid on
    
    subplot(2,3,[5 6]);
    plot(array.whiskerTrialNums,cellfun(@(x)x.trialContactType,contacts(1:length(array.trials))),'.') 
    axis([array.whiskerTrialNums(1) array.whiskerTrialNums(end) -.1 4.1])
    xlabel('Trial Number')
    grid on
    set(gca,'YTick',[0 1 2 3 4],'YTickLabel','No Contact | Go Protract | Go Retract | Nogo Protract | Nogo Retract')
    title('estimated primary contact type')
    
    subplot(2,3,1);cla;
    plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
    text(-.3,.9, ['\fontsize{8}' 'Trajectory ID :\bf ' num2str(params.tid)]);
    text(-.3,.8, ['\fontsize{8}' 'Pole Delay Offset  On :\bf ' num2str(params.poleOffset) '\rm  Off : \bf' num2str(params.poleEndOffset) '(s)']);
    text(-.3,.7, ['\fontsize{8}' 'Pro/Ret Threshold  Go :\bf ' num2str(params.goProThresh) '\rm  NoGo : \bf' num2str(params.nogoProThresh)]);
    text(-.3,.6, ['\fontsize{8}' 'Contact Threshold :\bf ' num2str(params.touchThresh(1)) ' / ' num2str(params.touchThresh(2)) ' / ' num2str(params.touchThresh(3)) ' / ' num2str(params.touchThresh(4))]);
    text(-.3,.5, ['\fontsize{8}' 'Curvature Multiplier :\bf ' num2str(params.curveMultiplier)]);
    text(-.3,.4, ['\fontsize{8}' 'Mean Spike Rate :\bf ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
    text(-.3,.3, ['\fontsize{8}' 'Mouse :\bf ' array.mouseName]);
    text(-.3,.2, ['\fontsize{8}' 'Cell :\bf ' array.cellNum '' array.cellCode '' array.mouseName]) ;
    text(-.3,.1, ['\fontsize{8}' 'Location :\bf ' num2str(array.depth) ' \mum' ' ' array.recordingLocation]) ;
set(h_analyzer,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
print(h_analyzer, '-depsc',[array.mouseName '-' array.cellNum '-' 'contactParams.eps']);


% %Plot first trial example of each type to confirm distance thresholds
%     figure
%     subplot(2,2,1)
%     tmp=find(trialContactType==1);
%     if isempty(tmp)==0
%         plot(array.trials{tmp(1)}.time{1},array.trials{tmp(1)}.distanceToPoleCenter{1},'.-')
%         title(strcat('distance to pole on go protraction trial #',num2str(array.trialNums(tmp(1)))))
%     end
% 
%     subplot(2,2,2)
%     tmp=find(trialContactType==2);
%     if isempty(tmp)==0
%         plot(array.trials{tmp(1)}.time{1},array.trials{tmp(1)}.distanceToPoleCenter{1},'.-')
%         title(strcat('distance to pole on go retraction trial #',num2str(array.trialNums(tmp(1)))))
%     else
%     end
% 
%     subplot(2,2,3)
%     tmp=find(trialContactType==3);
%     if isempty(tmp)==0
%         plot(array.trials{tmp(1)}.time{1},array.trials{tmp(1)}.distanceToPoleCenter{1},'.-')
%         title(strcat('distance to pole on nogo protraction trial #',num2str(array.trialNums(tmp(1)))))
%     else
%     end
% 
%     subplot(2,2,4)
%     tmp=find(trialContactType==4);
%     if isempty(tmp)==0
%         plot(array.trials{tmp(1)}.time{1},array.trials{tmp(1)}.distanceToPoleCenter{1},'.-')
%         title(strcat('distance to pole on nogo retraction trial #',num2str(array.trialNums(tmp(1)))))
%     else
%     end
% 
%     
% % Calculate and plot Spikes vs. Peak contact M0
% figure
% sumSpikePeakM0=[];
% sumSpikeMeanM0=[];
% for k=find(array.whiskerTrialInds==1)
%     sumSpikePeakM0=cat(1,sumSpikePeakM0,[find(contacts{k}.peakM0{1});contacts{k}.peakM0{1};contacts{k}.spikeCount{1};contacts{k}.contactLength{1};]');  
%     sumSpikeMeanM0=cat(1,sumSpikeMeanM0,[find(contacts{k}.meanM0{1});contacts{k}.meanM0{1};contacts{k}.spikeCount{1};contacts{k}.contactLength{1};]');  
%     subplot(2,2,1);hold on
%     plot(contacts{k}.peakM0{1},contacts{k}.spikeCount{1},'.k');
%     subplot(2,2,2);hold on
%     plot(contacts{k}.meanM0{1},contacts{k}.spikeCount{1},'.r');
% end
% 
% sumSpikePeakM0(:,5)=sumSpikePeakM0(:,3)./sumSpikePeakM0(:,4); % Spike count / contact length
% sumSpikeMeanM0(:,5)=sumSpikeMeanM0(:,3)./sumSpikeMeanM0(:,4);
% 
% %x=linspace(min(sumSpikePeakM0(:,2)),max(sumSpikePeakM0(:,2)),25);
% %xm=linspace(min(sumSpikeMeanM0(:,2)),max(sumSpikeMeanM0(:,2)),25);
% x=linspace(-5e-7,5e-7,25);
% xm=linspace(-5e-7,5e-7,25);
% 
% y=zeros(length(x)-1,1);
% ym=zeros(length(xm)-1,1);
% for i=1:length(x)-1
%     y(i)=nanmean(sumSpikePeakM0(find(sumSpikePeakM0(:,2)>=x(i) & sumSpikePeakM0(:,2)<=x(i+1)),5));
%     ystd(i)=nanstd(sumSpikePeakM0(find(sumSpikePeakM0(:,2)>=x(i) & sumSpikePeakM0(:,2)<=x(i+1)),5));
% end
% for i=1:length(xm)-1
%     ym(i)=nanmean(sumSpikeMeanM0(find(sumSpikeMeanM0(:,2)>=xm(i) & sumSpikeMeanM0(:,2)<=xm(i+1)),5));
%     ymstd(i)=nanstd(sumSpikeMeanM0(find(sumSpikeMeanM0(:,2)>=xm(i) & sumSpikeMeanM0(:,2)<=xm(i+1)),5));
% end
% 
% x=x+.5*(x(2)-x(1));
% x=x(1:end-1);
% x=xm+.5*(xm(2)-xm(1));
% x=xm(1:end-1);
% 
% subplot(2,2,3);
% %plot(x+.5*(x(2)-x(1)),y);
% errorbar(x,y,ystd);
% 
% subplot(2,2,4);
% %plot(xm+.5*(xm(2)-xm(1)),ym);
% errorbar(x,ym,ymstd);
% 
% for i=1:length(xm)-1
%     ym2(i)=nanmean(sumSpikeMeanM0(find(sumSpikeMeanM0(:,2)>=xm(i) & sumSpikeMeanM0(:,2)<=xm(i+1) & sumSpikeMeanM0(:,1)>=2),5));
% end
% 
% %% Spike Triggered averages
% %
% % Plot the spike triggered average moment.
% 
% for k=find(array.whiskerTrialInds==1);
% 
%     spikeTimes=array.trials{k}.spikesTrial.spikeTimes(array.trials{k}.spikesTrial.spikeTimes>10000*conta(1) & array.trials{k}.spikesTrial.spikeTimes<10000*spikeWindow(2));
%     if isnan(spikeTimes)==0
%         spikeTriggerM0I=nan(150,length(spikeTimes));
%         spikeTriggerFaxial=nan(150,length(spikeTimes));
%         spikeTriggerAcceleration=nan(150,length(spikeTimes));
%         spikeTriggerVelocity=nan(150,length(spikeTimes));
%         spikeTriggerPosition=nan(150,length(spikeTimes));
% 
%         for i=1:length(spikeTimes);
%             lim=spikeTimes(i)+10000*([-.1 .05]-array.whiskerTrialTimeOffset);
%             ind=find(round(10000*array.trials{k}.time{1})>=lim(1) & round(10000*array.trials{k}.time{1})<lim(2));
%             if isempty(ind)==0;
%                 ind2=round((array.trials{k}.time{1}(ind)-array.trials{k}.time{1}(ind(1)))*1000)+1;
%             else
%                 ind2=[];
%             end
%             
%             spikeTriggerM0I(ind2,i)=M0combo{k}(ind);
%             spikeTriggerFaxial(ind2,i)=contacts{k}.FaxialAdj{1}(ind);
%             spikeTriggerPosition(ind2,i)=array.trials{k}.theta{1}(ind);
% 
%             v=array.trials{k}.get_velocity(p.tid,3);
%             spikeTriggerVelocity(ind2,i)=v(ind);
% 
%             a=array.trials{k}.get_acceleration(p.tid,3);
%             spikeTriggerAcceleration(ind2,i)=a(ind);
% 
% 
% 
%         end
%         contacts{k}.spikeTriggerM0I{1}=spikeTriggerM0I;
%         contacts{k}.spikeTriggerFaxial{1}=spikeTriggerFaxial;
%         contacts{k}.spikeTriggerAcceleration{1}=spikeTriggerAcceleration;
%         contacts{k}.spikeTriggerVelocity{1}=spikeTriggerVelocity;
%         contacts{k}.spikeTriggerPosition{1}=spikeTriggerPosition;
%    
%     else
%         contacts{k}.spikeTriggerM0I{1}=[];
%         contacts{k}.spikeTriggerFaxial{1}=[];
%         contacts{k}.spikeTriggerAcceleration{1}=[];
%         contacts{k}.spikeTriggerVelocity{1}=[];
%         contacts{k}.spikeTriggerPosition{1}=[];
%     
% 
%     end
% end
% 
% 
% allSpikeTriggerM0I=[];
% absAllSpikeTriggerM0I=[]
% for i=find(array.whiskerTrialInds);
%     allSpikeTriggerM0I =cat(2,allSpikeTriggerM0I,contacts{i}.spikeTriggerM0I{1});
%     absAllSpikeTriggerM0I =cat(2,absAllSpikeTriggerM0I,abs(contacts{i}.spikeTriggerM0I{1}));
% end
% 
% hitSpikeTriggerM0I=[];
% absHitSpikeTriggerM0I=[];
% for i=find(array.hitTrialInds & array.whiskerTrialInds);
%     hitSpikeTriggerM0I =cat(2,hitSpikeTriggerM0I,contacts{i}.spikeTriggerM0I{1});
%     absHitSpikeTriggerM0I =cat(2,absHitSpikeTriggerM0I,abs(contacts{i}.spikeTriggerM0I{1}));
% end
% 
% missSpikeTriggerM0I=[];
% absMissSpikeTriggerM0I=[];
% for i=find(array.missTrialInds & array.whiskerTrialInds);
%     missSpikeTriggerM0I =cat(2,missSpikeTriggerM0I,contacts{i}.spikeTriggerM0I{1});
%     absMissSpikeTriggerM0I =cat(2,absMissSpikeTriggerM0I,abs(contacts{i}.spikeTriggerM0I{1}));
% end
% 
% falseAlarmSpikeTriggerM0I=[];
% absFalseAlarmSpikeTriggerM0I=[];
% for i=find(array.falseAlarmTrialInds & array.whiskerTrialInds);
%     falseAlarmSpikeTriggerM0I =cat(2,falseAlarmSpikeTriggerM0I,contacts{i}.spikeTriggerM0I{1});
%     absFalseAlarmSpikeTriggerM0I =cat(2,absFalseAlarmSpikeTriggerM0I,abs(contacts{i}.spikeTriggerM0I{1}));
% end
% 
% correctRejectionSpikeTriggerM0I=[];
% absCorrectRejectionSpikeTriggerM0I=[];
% for i=find(array.correctRejectionTrialInds & array.whiskerTrialInds);
%     correctRejectionSpikeTriggerM0I =cat(2,correctRejectionSpikeTriggerM0I,contacts{i}.spikeTriggerM0I{1});
%     absCorrectRejectionSpikeTriggerM0I =cat(2,absCorrectRejectionSpikeTriggerM0I,abs(contacts{i}.spikeTriggerM0I{1}));
% end
% 
% figure;
% plot([-.1:.001:.049],nanmean(allSpikeTriggerM0I,2),'.','Color',[.5 .5 .5])
% hold on
% title('Spike-triggered mean M0 with direction for all times')
% plot([-.1:.001:.049],nanmean(hitSpikeTriggerM0I,2),'b')
% plot([-.1:.001:.049],nanmean(missSpikeTriggerM0I,2),'k')
% plot([-.1:.001:.049],nanmean(falseAlarmSpikeTriggerM0I,2),'g')
% plot([-.1:.001:.049],nanmean(correctRejectionSpikeTriggerM0I,2),'r')
% 
% figure;
% plot([-.1:.001:.049],nanmean(absAllSpikeTriggerM0I,2),'.','Color',[.5 .5 .5])
% hold on
% title('Spike-triggered mean amplitude of M0 for all times')
% plot([-.1:.001:.049],nanmean(absHitSpikeTriggerM0I,2),'b')
% plot([-.1:.001:.049],nanmean(absMissSpikeTriggerM0I,2),'k')
% plot([-.1:.001:.049],nanmean(absFalseAlarmSpikeTriggerM0I,2),'g')
% plot([-.1:.001:.049],nanmean(absCorrectRejectionSpikeTriggerM0I,2),'r')
% 
% %% Moment aligned to decision
% %
% % Plot the average moment aligned to the decision time of the animal
% 
% maxTime=4500;
% decisionAlignedM0Combo={};
% for k=find(array.whiskerTrialInds);
%     ind=find(array.trials{k}.time{1} < array.trials{k}.behavTrial.answerPeriodTime(2)+1);
%     decisionAlignedM0Combo{k}=zeros(maxTime,1);
%     decisionAlignedM0Combo{k}(round((array.trials{k}.time{1}(ind)-array.trials{k}.time{1}(ind(end)))*1000)+4500)=M0combo{k}(ind);
%     decisionAlignedM0Combo{k}(decisionAlignedM0Combo{k}==0)=NaN;
% end
% 
% 
% 
% hitDecisionAlignedM0Combo = [];
% absHitDecisionAlignedM0Combo = [];
% for i=find(array.hitTrialInds & array.whiskerTrialInds);
%     hitDecisionAlignedM0Combo = cat(2,hitDecisionAlignedM0Combo,decisionAlignedM0Combo{i});
%     absHitDecisionAlignedM0Combo = cat(2,absHitDecisionAlignedM0Combo,abs(decisionAlignedM0Combo{i}));
% end
% 
% falseAlarmDecisionAlignedM0Combo = [];
% absFalseAlarmDecisionAlignedM0Combo = [];
% for i=find(array.falseAlarmTrialInds & array.whiskerTrialInds);
%     falseAlarmDecisionAlignedM0Combo = cat(2,falseAlarmDecisionAlignedM0Combo,decisionAlignedM0Combo{i});
%     absFalseAlarmDecisionAlignedM0Combo = cat(2,absFalseAlarmDecisionAlignedM0Combo,abs(decisionAlignedM0Combo{i}));
% end
% 
% correctRejectionDecisionAlignedM0Combo = [];
% absCorrectRejectionDecisionAlignedM0Combo = [];
% for i=find(array.correctRejectionTrialInds & array.whiskerTrialInds);
%     correctRejectionDecisionAlignedM0Combo = cat(2,correctRejectionDecisionAlignedM0Combo,decisionAlignedM0Combo{i});
%     absCorrectRejectionDecisionAlignedM0Combo = cat(2,absCorrectRejectionDecisionAlignedM0Combo,abs(decisionAlignedM0Combo{i}));
% end
% 
% missDecisionAlignedM0Combo = [];
% absMissDecisionAlignedM0Combo = [];
% for i=find(array.missTrialInds & array.whiskerTrialInds);
%     missDecisionAlignedM0Combo = cat(2,missDecisionAlignedM0Combo,decisionAlignedM0Combo{i});
%     absMissDecisionAlignedM0Combo = cat(2,absMissDecisionAlignedM0Combo,abs(decisionAlignedM0Combo{i}));
% end
% 
% figure;
% plot(-3.5:.001:.999,nanmean(absHitDecisionAlignedM0Combo,2),'b')
% hold on
% plot(-3.5:.001:.999,nanmean(absFalseAlarmDecisionAlignedM0Combo,2),'g')
% plot(-3.5:.001:.999,nanmean(absCorrectRejectionDecisionAlignedM0Combo,2),'r')
% plot(-3.5:.001:.999,nanmean(absMissDecisionAlignedM0Combo,2),'k')

