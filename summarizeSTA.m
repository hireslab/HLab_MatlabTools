function STA=summarizeSTA(array, contacts, parameters);

%% Summarize Session

% This takes arguments array, contacts, and parameters passed from the
% paramBrowser function.  It calculates a variety of interesting things
% about the session.  Uses code borrowed from the old autoContactAnalyzer.m


% % Plot the spike triggered average moment.

g=parameters;

h = waitbar(0,'Computing STAs...');
j=length(array.whiskerTrialInds==1);
STA=struct
STA.trials=cell(1,length(array.trials));
x=([-.1:.001:.05]);

for k=find(array.whiskerTrialInds);
    

    waitbar(k/j,h)
    
    g.sweepNum=k;
    cS=array.trials{g.sweepNum}.spikesTrial;
    time=array.trials{g.sweepNum}.whiskerTrial.time{1}; % All times in current trial
    cT=array.trials{g.sweepNum};
    cW=array.trials{g.sweepNum}.whiskerTrial;
    cB=array.trials{g.sweepNum}.behavTrial;
    cS=array.trials{g.sweepNum}.spikesTrial;
    switch g.displayType
    
    case 'all'
        g.framesUsed = 1:length(time);
        
    case 'contactsOnly'
        g.framesUsed = contacts{g.sweepNum}.contactInds{1};
    
    case 'excludeContacts'
        g.framesUsed = ones(size(time));
        g.framesUsed(contacts{g.sweepNum}.contactInds{1})=0;
        g.framesUsed= find(g.framesUsed);
        
    case 'poleToDecision'
        if isempty(cB.answerLickTime)==0
            g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                time < cB.answerLickTime);
        else
            g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                time < cT.pinAscentOnsetTime);
        end
        
    case 'contactToDecision'             
        if isempty(contacts{g.sweepNum}.contactInds{1})==0
            g.framesUsed = find(time > time(contacts{g.sweepNum}.contactInds{1}(1)) &...
                time < cT.pinAscentOnsetTime);
        else
            g.framesUsed=[];
        end
        
    case 'postDecision'             
        g.framesUsed = find(time > cB.answerLickTime);

    case 'postPole'             
        g.framesUsed = find(time > cT.pinAscentOnsetTime);
        
    case 'arbitrary'
        g.framesUsed = find(time > str2num(g.arbTimes{1}) & time < str2num(g.arbTimes{2}));
            
    otherwise
        error('Invalid string argument.')
    end
    
    % Find spikes inside framesUsed mask
    if isempty(g.framesUsed)==0
        tmp=repmat(g.framesUsed*10+g.spikeSynapticOffset*cS.sampleRate,10,1)+repmat([0:9]',1,length(g.framesUsed));
        spikeTimes=intersect(intersect(cS.spikeTimes,tmp(:)),1001:44500);  % limit to spikes with whisker frame data and inside the plotting window
    else
        spikeTimes=[];
    end
    
    if isnan(spikeTimes)==0
        spikeTriggerM0combo=nan(151,length(spikeTimes));
        spikeTriggerFaxial=nan(151,length(spikeTimes));
        spikeTriggerdM0combo=nan(151,length(spikeTimes));
        spikeTriggerdFaxial=nan(151,length(spikeTimes));
        spikeTriggerAcceleration=nan(151,length(spikeTimes));
        spikeTriggerVelocity=nan(151,length(spikeTimes));
        spikeTriggerthetaAtBase=nan(151,length(spikeTimes));
        spikeTriggerX=nan(151,length(spikeTimes));
        spikeTriggerY=nan(151,length(spikeTimes));
        
        cthetaAtBase=array.trials{k}.whiskerTrial.thetaAtBase{1};   % Angular position of current trial
        cVelocity=diff([0 cthetaAtBase])./diff([0 time]);  % Angular Velocity of current trial
        cAcceleration=smooth(diff([0 cVelocity])./diff([0 time]),3); % Angular Acceleration of current trial
                
        dM0combo=diff([0 contacts{k}.M0combo{1}]);
        dFaxial=diff([0 contacts{k}.FaxialAdj{1}]);
       
        
        for i=1:length(spikeTimes);
            lim=spikeTimes(i)+cS.sampleRate*([x(1) x(end)]-array.whiskerTrialTimeOffset);
            ind=find(round(cS.sampleRate*time)>=lim(1)...
                & round(cS.sampleRate*time)<lim(2));
            
            if isempty(ind)==0;
                ind2=round((time(ind)-time(ind(1)))*1000)+1;
            else
                ind2=[];
            end
            
            spikeTriggerM0combo(ind2,i)=contacts{k}.M0combo{1}(ind);
            spikeTriggerFaxial(ind2,i)=contacts{k}.FaxialAdj{1}(ind);
            spikeTriggerdM0combo(ind2,i)=dM0combo(ind);
            spikeTriggerdFaxial(ind2,i)=dFaxial(ind);
            spikeTriggerthetaAtBase(ind2,i)=cthetaAtBase(ind);
            spikeTriggerVelocity(ind2,i)=cVelocity(ind);
            spikeTriggerAcceleration(ind2,i)=cAcceleration(ind);
            spikeTriggerX(ind2,i)=cW.follicleCoordsX{1}(ind);
            spikeTriggerY(ind2,i)=cW.follicleCoordsY{1}(ind);
        end
        STA.trials{k}.framesUsed{1}=g.framesUsed;
        STA.trials{k}.spikesUsed{1}=spikeTimes;
        STA.trials{k}.M0combo{1}=spikeTriggerM0combo;
        STA.trials{k}.Faxial{1}=spikeTriggerFaxial;
        STA.trials{k}.dM0combo{1}=spikeTriggerdM0combo;
        STA.trials{k}.dFaxial{1}=spikeTriggerdFaxial;
        STA.trials{k}.Acceleration{1}=spikeTriggerAcceleration;
        STA.trials{k}.Velocity{1}=spikeTriggerVelocity;
        STA.trials{k}.thetaAtBase{1}=spikeTriggerthetaAtBase;
        STA.trials{k}.X{1}=spikeTriggerX;
        STA.trials{k}.Y{1}=spikeTriggerY;
        
    else
        STA.trials{k}.framesUsed{1}=[];
        STA.trials{k}.spikesUsed{1}=[];
        STA.trials{k}.M0combo{1}=[];
        STA.trials{k}.Faxial{1}=[];
        STA.trials{k}.dM0combo{1}=[];
        STA.trials{k}.dFaxial{1}=[];
        STA.trials{k}.Acceleration{1}=[];
        STA.trials{k}.Velocity{1}=[];
        STA.trials{k}.thetaAtBase{1}=[];
        STA.trials{k}.X{1}=[];
        STA.trials{k}.Y{1}=[];

    end
end

close(h)

disp('Generating mean STAs')

% Generate mean STA for all trials with WhiskerTrials

STA.all.M0combo=[];
STA.all.Faxial = [];
STA.all.dM0combo = [];
STA.all.dFaxial = [];
STA.all.Acceleration = [];
STA.all.Velocity = [];
STA.all.thetaAtBase = [];
STA.all.X = [];
STA.all.Y = [];


for k=find(array.whiskerTrialInds);
    STA.all.M0combo = cat(2,STA.all.M0combo,STA.trials{k}.M0combo{1});
    STA.all.Faxial = cat(2,STA.all.Faxial,STA.trials{k}.Faxial{1});
    STA.all.dM0combo = cat(2,STA.all.dM0combo,STA.trials{k}.dM0combo{1});
    STA.all.dFaxial = cat(2,STA.all.dFaxial,STA.trials{k}.dFaxial{1});
    STA.all.Acceleration = cat(2,STA.all.Acceleration,STA.trials{k}.Acceleration{1});
    STA.all.Velocity = cat(2,STA.all.Velocity,STA.trials{k}.Velocity{1});
    STA.all.thetaAtBase = cat(2,STA.all.thetaAtBase,STA.trials{k}.thetaAtBase{1});
    STA.all.X = cat(2,STA.all.X,STA.trials{k}.X{1});
    STA.all.Y = cat(2,STA.all.Y,STA.trials{k}.Y{1});
end

disp('Generating mean STAs for hit trials')

 % Generate mean STA for hit trials 

STA.hit.M0combo=[];
STA.hit.Faxial = [];
STA.hit.dM0combo = [];
STA.hit.dFaxial = [];
STA.hit.Acceleration = [];
STA.hit.Velocity = [];
STA.hit.thetaAtBase = [];
STA.hit.X = [];
STA.hit.Y = [];

for k=find(array.hitTrialInds & array.whiskerTrialInds);
    STA.hit.M0combo = cat(2,STA.hit.M0combo,STA.trials{k}.M0combo{1});
    STA.hit.Faxial = cat(2,STA.hit.Faxial,STA.trials{k}.Faxial{1});
    STA.hit.dM0combo = cat(2,STA.hit.dM0combo,STA.trials{k}.dM0combo{1});
    STA.hit.dFaxial = cat(2,STA.hit.dFaxial,STA.trials{k}.dFaxial{1});
    STA.hit.Acceleration = cat(2,STA.hit.Acceleration,STA.trials{k}.Acceleration{1});
    STA.hit.Velocity = cat(2,STA.hit.Velocity,STA.trials{k}.Velocity{1});
    STA.hit.thetaAtBase = cat(2,STA.hit.thetaAtBase,STA.trials{k}.thetaAtBase{1});
    STA.hit.X = cat(2,STA.hit.X,STA.trials{k}.X{1});
    STA.hit.Y = cat(2,STA.hit.Y,STA.trials{k}.Y{1});
end

disp('Generating mean STAs for miss trials')

 % Generate mean STA for miss trials 
 
STA.miss.M0combo=[];
STA.miss.Faxial = [];
STA.miss.dM0combo = [];
STA.miss.dFaxial = [];
STA.miss.Acceleration = [];
STA.miss.Velocity = [];
STA.miss.thetaAtBase = [];
STA.miss.X = [];
STA.miss.Y = [];


for k=find(array.missTrialInds & array.whiskerTrialInds);
    STA.miss.M0combo = cat(2,STA.miss.M0combo,STA.trials{k}.M0combo{1});
    STA.miss.Faxial = cat(2,STA.miss.Faxial,STA.trials{k}.Faxial{1});
    STA.miss.dM0combo = cat(2,STA.miss.dM0combo,STA.trials{k}.dM0combo{1});
    STA.miss.dFaxial = cat(2,STA.miss.dFaxial,STA.trials{k}.dFaxial{1});
    STA.miss.Acceleration = cat(2,STA.miss.Acceleration,STA.trials{k}.Acceleration{1});
    STA.miss.Velocity = cat(2,STA.miss.Velocity,STA.trials{k}.Velocity{1});
    STA.miss.thetaAtBase = cat(2,STA.miss.thetaAtBase,STA.trials{k}.thetaAtBase{1});
    STA.miss.X = cat(2,STA.miss.X,STA.trials{k}.X{1});
    STA.miss.Y = cat(2,STA.miss.Y,STA.trials{k}.Y{1});
end


disp('Generating mean STAs for false alarm trials')

 % Generate mean STA for false alarm trials 
 
STA.falseAlarm.M0combo=[];
STA.falseAlarm.Faxial = [];
STA.falseAlarm.dM0combo = [];
STA.falseAlarm.dFaxial = [];
STA.falseAlarm.Acceleration = [];
STA.falseAlarm.Velocity = [];
STA.falseAlarm.thetaAtBase = [];
STA.falseAlarm.X = [];
STA.falseAlarm.Y = [];


for k=find(array.falseAlarmTrialInds & array.whiskerTrialInds);
    STA.falseAlarm.M0combo = cat(2,STA.falseAlarm.M0combo,STA.trials{k}.M0combo{1});
    STA.falseAlarm.Faxial = cat(2,STA.falseAlarm.Faxial,STA.trials{k}.Faxial{1});
    STA.falseAlarm.dM0combo = cat(2,STA.falseAlarm.dM0combo,STA.trials{k}.dM0combo{1});
    STA.falseAlarm.dFaxial = cat(2,STA.falseAlarm.dFaxial,STA.trials{k}.dFaxial{1});
    STA.falseAlarm.Acceleration = cat(2,STA.falseAlarm.Acceleration,STA.trials{k}.Acceleration{1});
    STA.falseAlarm.Velocity = cat(2,STA.falseAlarm.Velocity,STA.trials{k}.Velocity{1});
    STA.falseAlarm.thetaAtBase = cat(2,STA.falseAlarm.thetaAtBase,STA.trials{k}.thetaAtBase{1});
    STA.falseAlarm.X = cat(2,STA.falseAlarm.X,STA.trials{k}.X{1});
    STA.falseAlarm.Y = cat(2,STA.falseAlarm.Y,STA.trials{k}.Y{1});
end

disp('Generating mean STAs for correct rejection trials')

 % Generate mean STA for correct rejection trials
 
STA.correctRejection.M0combo=[];
STA.correctRejection.Faxial = [];
STA.correctRejection.dM0combo = [];
STA.correctRejection.dFaxial = [];
STA.correctRejection.Acceleration = [];
STA.correctRejection.Velocity = [];
STA.correctRejection.thetaAtBase = [];
STA.correctRejection.X = [];
STA.correctRejection.Y = [];


for k=find(array.correctRejectionTrialInds & array.whiskerTrialInds);
    STA.correctRejection.M0combo = cat(2,STA.correctRejection.M0combo,STA.trials{k}.M0combo{1});
    STA.correctRejection.Faxial = cat(2,STA.correctRejection.Faxial,STA.trials{k}.Faxial{1});
    STA.correctRejection.dM0combo = cat(2,STA.correctRejection.dM0combo,STA.trials{k}.dM0combo{1});
    STA.correctRejection.dFaxial = cat(2,STA.correctRejection.dFaxial,STA.trials{k}.dFaxial{1});
    STA.correctRejection.Acceleration = cat(2,STA.correctRejection.Acceleration,STA.trials{k}.Acceleration{1});
    STA.correctRejection.Velocity = cat(2,STA.correctRejection.Velocity,STA.trials{k}.Velocity{1});
    STA.correctRejection.thetaAtBase = cat(2,STA.correctRejection.thetaAtBase,STA.trials{k}.thetaAtBase{1});
    STA.correctRejection.X = cat(2,STA.correctRejection.X,STA.trials{k}.X{1});
    STA.correctRejection.Y = cat(2,STA.correctRejection.Y,STA.trials{k}.Y{1});
end

disp('Exporting STA structure')

% Temp Kludge

if isempty(STA.miss.M0combo);
    STA.miss.M0combo=NaN(length(x),1);
    STA.miss.Faxial=NaN(length(x),1);
    STA.miss.dM0combo=NaN(length(x),1);
    STA.miss.dFaxial=NaN(length(x),1);
    STA.miss.Acceleration=NaN(length(x),1);
    STA.miss.Velocity=NaN(length(x),1);
    STA.miss.thetaAtBase=NaN(length(x),1);
    STA.miss.X=NaN(length(x),1);
    STA.miss.Y=NaN(length(x),1);
end

if isempty(STA.correctRejection.M0combo);
    STA.correctRejection.M0combo=NaN(length(x),1);
    STA.correctRejection.Faxial=NaN(length(x),1);
    STA.correctRejection.dM0combo=NaN(length(x),1);
    STA.correctRejection.dFaxial=NaN(length(x),1);
    STA.correctRejection.Acceleration=NaN(length(x),1);
    STA.correctRejection.Velocity=NaN(length(x),1);
    STA.correctRejection.thetaAtBase=NaN(length(x),1);
    STA.correctRejection.X=NaN(length(x),1);
    STA.correctRejection.Y=NaN(length(x),1);
end

assignin('base','STA',STA);


%% Plotting
disp('Building summary STA plots')

h_STA=figure;

subplot(3,5,1);cla;
    plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
try
    text(-.3,.9, ['\fontsize{7}' 'Time Period : \bf' g.displayType '  ' num2str(g.arbTimes)]);
end
    text(-.3,.8, ['\fontsize{7}\color[rgb]{.5 .5 .5}' 'AP Synaptic Offset : ' num2str(g.spikeSynapticOffset) ' (s)']);
    text(-.3,.7, ['\fontsize{7}\color[rgb]{.5 .5 .5}' 'AP Integration Window : ' num2str(g.spikeRateWindow) ' (s)']);
    text(-.3,.6, ['\fontsize{7}' 'Contact Threshold ' num2str(g.touchThresh(1)) ' / ' num2str(g.touchThresh(2)) ' / ' num2str(g.touchThresh(3)) ' / ' num2str(g.touchThresh(4))]);
    text(-.3,.5, ['\fontsize{7}' 'Mean Answer Time : ' num2str(g.meanAnswerTime) ' (s)']);
    text(-.3,.4, ['\fontsize{7}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
    text(-.3,.3, ['\fontsize{7}' 'Mouse : ' array.mouseName]);
    text(-.3,.2, ['\fontsize{7}' 'Cell : ' array.cellNum '' array.cellCode]) ;
    text(-.3,.1, ['\fontsize{7}' 'Location : ' num2str(array.depth) ' (\mum)' ' ' array.recordingLocation]) ;

subplot(3,5,9);cla;
hold on
title('M0 dir')
plot(x,nanmean(STA.miss.M0combo,2),'k')
plot(x,nanmean(STA.falseAlarm.M0combo,2),'g')
plot(x,nanmean(STA.hit.M0combo,2),'b')
plot(x,nanmean(STA.correctRejection.M0combo,2),'r')
plot(x,nanmean(STA.all.M0combo,2),'.','Color',[.5 .5 .5])
ylabel('N*m');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,10);cla;
hold on
title('M0 mag')
plot(x,nanmean(abs(STA.miss.M0combo),2),'k')
plot(x,nanmean(abs(STA.falseAlarm.M0combo),2),'g')
plot(x,nanmean(abs(STA.correctRejection.M0combo),2),'r')
plot(x,nanmean(abs(STA.hit.M0combo),2),'b')
plot(x,nanmean(abs(STA.all.M0combo),2),'.','Color',[.5 .5 .5])
ylabel('abs(N*m)');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,3);cla;
hold on
title('Faxial')
plot(x,nanmean(STA.miss.Faxial,2),'k')
plot(x,nanmean(STA.falseAlarm.Faxial,2),'g')
plot(x,nanmean(STA.correctRejection.Faxial,2),'r')
plot(x,nanmean(STA.hit.Faxial,2),'b')
plot(x,nanmean(STA.all.Faxial,2),'.','Color',[.5 .5 .5])
ylabel('N');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,14);cla;
hold on
title('\DeltaM0 dir')
plot(x,nanmean(STA.miss.dM0combo,2),'k')
plot(x,nanmean(STA.falseAlarm.dM0combo,2),'g')
plot(x,nanmean(STA.correctRejection.dM0combo,2),'r')
plot(x,nanmean(STA.hit.dM0combo,2),'b')
plot(x,nanmean(STA.all.dM0combo,2),'.','Color',[.5 .5 .5])
ylabel('N*m / s');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,15);cla;
hold on
title('\DeltaM0 mag')
plot(x,nanmean(abs(STA.miss.dM0combo),2),'k')
plot(x,nanmean(abs(STA.falseAlarm.dM0combo),2),'g')
plot(x,nanmean(abs(STA.correctRejection.dM0combo),2),'r')
plot(x,nanmean(abs(STA.hit.dM0combo),2),'b')
plot(x,nanmean(abs(STA.all.dM0combo),2),'.','Color',[.5 .5 .5])
ylabel('abs(N*m) / s');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,4);cla;
hold on
title('\Delta''Fax dir')
plot(x,nanmean(STA.miss.dFaxial,2),'k')
plot(x,nanmean(STA.falseAlarm.dFaxial,2),'g')
plot(x,nanmean(STA.correctRejection.dFaxial,2),'r')
plot(x,nanmean(STA.hit.dFaxial,2),'b')
plot(x,nanmean(STA.all.dFaxial,2),'.','Color',[.5 .5 .5])
ylabel('N / s');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,5);cla;
hold on
title('\DeltaFax mag')
plot(x,nanmean(abs(STA.miss.dFaxial),2),'k')
plot(x,nanmean(abs(STA.falseAlarm.dFaxial),2),'g')
plot(x,nanmean(abs(STA.correctRejection.dFaxial),2),'r')
plot(x,nanmean(abs(STA.hit.dFaxial),2),'b')
plot(x,nanmean(abs(STA.all.dFaxial),2),'.','Color',[.5 .5 .5])
ylabel('abs(N / s');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,12);cla;
hold on
title('Accel')
plot(x,nanmean(STA.miss.Acceleration,2),'k')
plot(x,nanmean(STA.falseAlarm.Acceleration,2),'g')
plot(x,nanmean(STA.correctRejection.Acceleration,2),'r')
plot(x,nanmean(STA.hit.Acceleration,2),'b')
plot(x,nanmean(STA.all.Acceleration,2),'.','Color',[.5 .5 .5])
ylabel('Deg / s^2');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,13);cla;
hold on
title('Accel mag')
plot(x,nanmean(abs(STA.miss.Acceleration),2),'k')
plot(x,nanmean(abs(STA.falseAlarm.Acceleration),2),'g')
plot(x,nanmean(abs(STA.correctRejection.Acceleration),2),'r')
plot(x,nanmean(abs(STA.hit.Acceleration),2),'b')
plot(x,nanmean(abs(STA.all.Acceleration),2),'.','Color',[.5 .5 .5])
ylabel('abs(Deg / s^2)');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,7);cla;
hold on
title('Velocity')
plot(x,nanmean(STA.miss.Velocity,2),'k')
plot(x,nanmean(STA.falseAlarm.Velocity,2),'g')
plot(x,nanmean(STA.correctRejection.Velocity,2),'r')
plot(x,nanmean(STA.hit.Velocity,2),'b')
plot(x,nanmean(STA.all.Velocity,2),'.','Color',[.5 .5 .5])
ylabel('Deg / s');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,8);cla;
hold on
title('Velocity mag')
plot(x,nanmean(abs(STA.miss.Velocity),2),'k')
plot(x,nanmean(abs(STA.falseAlarm.Velocity),2),'g')
plot(x,nanmean(abs(STA.correctRejection.Velocity),2),'r')
plot(x,nanmean(abs(STA.hit.Velocity),2),'b')
plot(x,nanmean(abs(STA.all.Velocity),2),'.','Color',[.5 .5 .5])
ylabel('abs(Deg / s)');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,2);cla;
hold on
title('\Theta at Base')
plot(x,nanmean(STA.miss.thetaAtBase,2),'k')
plot(x,nanmean(STA.falseAlarm.thetaAtBase,2),'g')
plot(x,nanmean(STA.correctRejection.thetaAtBase,2),'r')
plot(x,nanmean(STA.hit.thetaAtBase,2),'b')
plot(x,nanmean(STA.all.thetaAtBase,2),'.','Color',[.5 .5 .5])
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,6);cla;
hold on
title('Follicle X')
plot(x,nanmean(STA.miss.X,2),'k')
plot(x,nanmean(STA.falseAlarm.X,2),'g')
plot(x,nanmean(STA.correctRejection.X,2),'r')
plot(x,nanmean(STA.hit.X,2),'b')
plot(x,nanmean(STA.all.X,2),'.','Color',[.5 .5 .5])
ylabel('Pixels');
axis tight
set(gca,'XLim',[-.1 0.049]);

subplot(3,5,11);cla;
hold on
title('Follicle Y')
plot(x,nanmean(STA.miss.Y,2),'k')
plot(x,nanmean(STA.falseAlarm.Y,2),'g')
plot(x,nanmean(STA.correctRejection.Y,2),'r')
plot(x,nanmean(STA.hit.Y,2),'b')
plot(x,nanmean(STA.all.Y,2),'.','Color',[.5 .5 .5])
ylabel('Pixels');
axis tight
set(gca,'XLim',[-.1 0.049]);

set(h_STA,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
print(h_STA, '-depsc',[array.mouseName '-' array.cellNum '-' 'STA-' g.displayType '-' num2str(g.spikeSynapticOffset) '.eps']);

% print -f -depsc 