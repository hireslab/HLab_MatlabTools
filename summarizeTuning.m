function Tuning=summarizeTuning(array, contacts, params)

g=params;
Tuning.position.linear=[];
Tuning.acceleration.linear=[];
Tuning.velocity.linear=[];
Tuning.M0combo.linear=[];
Tuning.Faxial.linear=[];

Tuning.spikeRateUsed=[];

Tuning.index.hit=[];
Tuning.index.miss=[];
Tuning.index.correctRejection=[];
Tuning.index.falseAlarm=[];


h = waitbar(0,'Sorting Arrays');
j=array.length;
   

[~,useTrials,~]=intersect(array.trialNums, array.whiskerTrialNums);

for k=useTrials(find(array.trialNums(useTrials) >= params.trialRange(1)& array.trialNums(useTrials) <= params.trialRange(2)));

    waitbar(k/j,h);
    Tuning.framesUsed{k}=g.framesUsed;
        time=array.trials{k}.whiskerTrial.time{1}; % All times in current trial
    cT=array.trials{k};
    cW=array.trials{k}.whiskerTrial;
    cB=array.trials{k}.behavTrial;
    cS=array.trials{k}.shanksTrial;
    
    switch g.displayType

        case 'all'
            g.framesUsed = 1:length(time);

        case 'contactsOnly'
            g.framesUsed = contacts{k}.contactInds{1};

        case 'excludeContacts'
            g.framesUsed = ones(size(time));
            g.framesUsed(contacts{k}.contactInds{1})=0;
            g.framesUsed= find(g.framesUsed);

        case 'poleToDecision'
            if isempty(cB.answerLickTime)==0
                g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                    time < cB.answerLickTime);
            else
                g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                    time < g.meanAnswerTime);
            end

        case 'contactToDecision'             
            if isempty(contacts{k}.contactInds{1})==0
                g.framesUsed = find(time > time(contacts{k}.contactInds{1}(1)) &...
                    time < g.meanAnswerTime);
            else
                g.framesUsed=[];
            end

        case 'postDecision'             

            if isempty(cB.answerLickTime)==0;
                g.framesUsed = find(time > cB.answerLickTime);
            else
                g.framesUsed = find(time> g.meanAnswerTime);
            end

        case 'postPole'             
            g.framesUsed = find(time > cT.pinAscentOnsetTime);

        case 'arbitrary'
            g.framesUsed = find(time > str2num(g.arbTimes{1}) & time < str2num(g.arbTimes{2}));

        otherwise
            error('Invalid string argument.')
    end
    
    spikeIndex=zeros(46000,1);
    if isempty(cW)==0
        try
            spikeIndex(cS.spikeTimes)=1;
        catch
        end
        
    else
        
    end
    
    if isempty(g.framesUsed)==0
        
        % Save the bounding indexs of hit,miss,FA,and CR trials for the
        % complete linearly sorted dataset
        
        if sum(find(array.hitTrialInds)==k);
        Tuning.index.hit(size(Tuning.index.hit,1)+1,1:2)=...
            [length(Tuning.spikeRateUsed)+min([1 length(g.framesUsed)]) length(Tuning.spikeRateUsed)+length(g.framesUsed)];
        
        elseif sum(find(array.missTrialInds)==k);
        Tuning.index.miss(size(Tuning.index.miss,1)+1,1:2)=...
            [length(Tuning.spikeRateUsed)+min([1 length(g.framesUsed)]) length(Tuning.spikeRateUsed)+length(g.framesUsed)];
        
        elseif sum(find(array.falseAlarmTrialInds)==k);
        Tuning.index.falseAlarm(size(Tuning.index.falseAlarm,1)+1,1:2)=...
            [length(Tuning.spikeRateUsed)+min([1 length(g.framesUsed)]) length(Tuning.spikeRateUsed)+length(g.framesUsed)];
        
        elseif sum(find(array.correctRejectionTrialInds)==k);
        Tuning.index.correctRejection(size(Tuning.index.correctRejection,1)+1,1:2)=...
            [length(Tuning.spikeRateUsed)+min([1 length(g.framesUsed)]) length(Tuning.spikeRateUsed)+length(g.framesUsed)];
        else
        end
        
        % Sort spikerate vs. various for every timepoint in dataset. 
   
        sampleRate=cS.sampleRate;
        spikeRate=smooth(spikeIndex,g.spikeRateWindow*sampleRate)*sampleRate;
        spikeRateUsed=spikeRate(g.framesUsed*10+round((array.whiskerTrialTimeOffset+g.spikeSynapticOffset)*sampleRate));    
        Tuning.spikeRateUsed=cat(1,Tuning.spikeRateUsed,spikeRateUsed);
    
        xP=cW.thetaAtBase{1};
        xPos{1}=xP(g.framesUsed);
        Tuning.position.linear=cat(2,Tuning.position.linear,xPos{1}); 
        
        xV=diff([0 xP])./diff([0 time]);
        xVel{1}=xV(g.framesUsed);
        Tuning.velocity.linear=cat(2,Tuning.velocity.linear,xVel{1}); 
        
        xA=diff([0 xV])./diff([0 time]);
        xAcc{1}=xA(g.framesUsed);
        Tuning.acceleration.linear=cat(2,Tuning.acceleration.linear,xAcc{1});   
        
        Tuning.M0combo.linear=cat(2,Tuning.M0combo.linear,contacts{k}.M0combo{1}(g.framesUsed));
        Tuning.Faxial.linear=cat(2,Tuning.Faxial.linear,contacts{k}.FaxialAdj{1}(g.framesUsed));
        
       
    else
    end
    
end
close(h);



% Bin and sort all data

[Tuning.position.binSpikeRate Tuning.position.bin Tuning.position.binBounds]=...
    binslin(Tuning.position.linear,Tuning.spikeRateUsed,'equalN',g.maxBins);
[Tuning.velocity.binSpikeRate Tuning.velocity.bin Tuning.velocity.binBounds]=...
    binslin(Tuning.velocity.linear,Tuning.spikeRateUsed,'equalN',g.maxBins);
[Tuning.acceleration.binSpikeRate Tuning.acceleration.bin Tuning.acceleration.binBounds]=...
    binslin(Tuning.acceleration.linear,Tuning.spikeRateUsed,'equalN',g.maxBins);
[Tuning.M0combo.binSpikeRate Tuning.M0combo.bin Tuning.M0combo.binBounds]=...
    binslin(Tuning.M0combo.linear,Tuning.spikeRateUsed,'equalN',g.maxBins);
[Tuning.Faxial.binSpikeRate Tuning.Faxial.bin Tuning.Faxial.binBounds]=...
    binslin(Tuning.Faxial.linear(find(Tuning.Faxial.linear)),Tuning.spikeRateUsed(find(Tuning.Faxial.linear)),'equalN',min([g.maxBins length(find(Tuning.Faxial.linear))]));

% Rebin all hit data

ind=[];
for i=1:size(Tuning.index.hit,1)
ind=cat(2,ind,Tuning.index.hit(i,1):Tuning.index.hit(i,2));
end

[Tuning.hit.position.binSpikeRate Tuning.hit.position.bin Tuning.hit.position.binBounds]=...
    binslin(Tuning.position.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.hit.velocity.binSpikeRate Tuning.hit.velocity.bin Tuning.hit.velocity.binBounds]=...
    binslin(Tuning.velocity.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.hit.acceleration.binSpikeRate Tuning.hit.acceleration.bin Tuning.hit.acceleration.binBounds]=...
    binslin(Tuning.acceleration.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.hit.M0combo.binSpikeRate Tuning.hit.M0combo.bin Tuning.hit.M0combo.binBounds]=...
    binslin(Tuning.M0combo.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.hit.Faxial.binSpikeRate Tuning.hit.Faxial.bin Tuning.hit.Faxial.binBounds]=...
    binslin(Tuning.Faxial.linear(find(Tuning.Faxial.linear(ind))),Tuning.spikeRateUsed(find(Tuning.Faxial.linear(ind))),'equalN',min([g.maxBins length(find(Tuning.Faxial.linear(ind)))]));

% Rebin all miss data

ind=[];
for i=1:size(Tuning.index.miss,1)
ind=cat(2,ind,Tuning.index.miss(i,1):Tuning.index.miss(i,2));
end

[Tuning.miss.position.binSpikeRate Tuning.miss.position.bin Tuning.miss.position.binBounds]=...
    binslin(Tuning.position.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.miss.velocity.binSpikeRate Tuning.miss.velocity.bin Tuning.miss.velocity.binBounds]=...
    binslin(Tuning.velocity.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.miss.acceleration.binSpikeRate Tuning.miss.acceleration.bin Tuning.miss.acceleration.binBounds]=...
    binslin(Tuning.acceleration.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.miss.M0combo.binSpikeRate Tuning.miss.M0combo.bin Tuning.miss.M0combo.binBounds]=...
    binslin(Tuning.M0combo.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.miss.Faxial.binSpikeRate Tuning.miss.Faxial.bin Tuning.miss.Faxial.binBounds]=...
    binslin(Tuning.Faxial.linear(find(Tuning.Faxial.linear(ind))),Tuning.spikeRateUsed(find(Tuning.Faxial.linear(ind))),'equalN',min([g.maxBins length(find(Tuning.Faxial.linear(ind)))]));

% Rebin all falseAlarm data

ind=[];
for i=1:size(Tuning.index.falseAlarm,1)
ind=cat(2,ind,Tuning.index.falseAlarm(i,1):Tuning.index.falseAlarm(i,2));
end

[Tuning.falseAlarm.position.binSpikeRate Tuning.falseAlarm.position.bin Tuning.falseAlarm.position.binBounds]=...
    binslin(Tuning.position.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.falseAlarm.velocity.binSpikeRate Tuning.falseAlarm.velocity.bin Tuning.falseAlarm.velocity.binBounds]=...
    binslin(Tuning.velocity.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.falseAlarm.acceleration.binSpikeRate Tuning.falseAlarm.acceleration.bin Tuning.falseAlarm.acceleration.binBounds]=...
    binslin(Tuning.acceleration.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.falseAlarm.M0combo.binSpikeRate Tuning.falseAlarm.M0combo.bin Tuning.falseAlarm.M0combo.binBounds]=...
    binslin(Tuning.M0combo.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.falseAlarm.Faxial.binSpikeRate Tuning.falseAlarm.Faxial.bin Tuning.falseAlarm.Faxial.binBounds]=...
    binslin(Tuning.Faxial.linear(find(Tuning.Faxial.linear(ind))),Tuning.spikeRateUsed(find(Tuning.Faxial.linear(ind))),'equalN',min([g.maxBins length(find(Tuning.Faxial.linear(ind)))]));

% Rebin all correctionRejection data

ind=[];
for i=1:size(Tuning.index.correctRejection,1)
ind=cat(2,ind,Tuning.index.correctRejection(i,1):Tuning.index.correctRejection(i,2));
end

[Tuning.correctRejection.position.binSpikeRate Tuning.correctRejection.position.bin Tuning.correctRejection.position.binBounds]=...
    binslin(Tuning.position.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.correctRejection.velocity.binSpikeRate Tuning.correctRejection.velocity.bin Tuning.correctRejection.velocity.binBounds]=...
    binslin(Tuning.velocity.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.correctRejection.acceleration.binSpikeRate Tuning.correctRejection.acceleration.bin Tuning.correctRejection.acceleration.binBounds]=...
    binslin(Tuning.acceleration.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.correctRejection.M0combo.binSpikeRate Tuning.correctRejection.M0combo.bin Tuning.correctRejection.M0combo.binBounds]=...
    binslin(Tuning.M0combo.linear(ind),Tuning.spikeRateUsed(ind),'equalN',g.maxBins);
[Tuning.correctRejection.Faxial.binSpikeRate Tuning.correctRejection.Faxial.bin Tuning.correctRejection.Faxial.binBounds]=...
    binslin(Tuning.Faxial.linear(find(Tuning.Faxial.linear(ind))),Tuning.spikeRateUsed(find(Tuning.Faxial.linear(ind))),'equalN',min([g.maxBins length(find(Tuning.Faxial.linear(ind)))]));




% Position vs. Spike Rate
h_tuning=figure;
subplot(3,2,1)
x=cellfun(@mean,Tuning.position.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,Tuning.position.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,Tuning.position.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),Tuning.position.binSpikeRate))'; % Std erorr of the 
binBounds=Tuning.position.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko');
ylabel('SpikeRate (Hz)');
xlabel('Azimuth');

plot(cellfun(@mean,Tuning.miss.position.bin)',cellfun(@mean,Tuning.miss.position.binSpikeRate)','k.-');
plot(cellfun(@mean,Tuning.falseAlarm.position.bin)',cellfun(@mean,Tuning.falseAlarm.position.binSpikeRate)','g.-');
plot(cellfun(@mean,Tuning.correctRejection.position.bin)',cellfun(@mean,Tuning.correctRejection.position.binSpikeRate)','r.-');
plot(cellfun(@mean,Tuning.hit.position.bin)',cellfun(@mean,Tuning.hit.position.binSpikeRate)','.-');
xmin=min([x';cellfun(@mean,Tuning.miss.position.bin);cellfun(@mean,Tuning.falseAlarm.position.bin);...
    cellfun(@mean,Tuning.correctRejection.position.bin);cellfun(@mean,Tuning.hit.position.bin)]);
xmax=max([x';cellfun(@mean,Tuning.miss.position.bin);cellfun(@mean,Tuning.falseAlarm.position.bin);...
    cellfun(@mean,Tuning.correctRejection.position.bin);cellfun(@mean,Tuning.hit.position.bin)]);
axis([xmin xmax 0 max([1 y+yerr])]);


% Velocity vs. Spike Rate
subplot(3,2,3)
x=cellfun(@mean,Tuning.velocity.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,Tuning.velocity.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,Tuning.velocity.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),Tuning.velocity.binSpikeRate))'; % Std erorr of the 
binBounds=Tuning.velocity.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Velocity');

plot(cellfun(@mean,Tuning.miss.velocity.bin)',cellfun(@mean,Tuning.miss.velocity.binSpikeRate)','k.-');
plot(cellfun(@mean,Tuning.falseAlarm.velocity.bin)',cellfun(@mean,Tuning.falseAlarm.velocity.binSpikeRate)','g.-');
plot(cellfun(@mean,Tuning.correctRejection.velocity.bin)',cellfun(@mean,Tuning.correctRejection.velocity.binSpikeRate)','r.-');
plot(cellfun(@mean,Tuning.hit.velocity.bin)',cellfun(@mean,Tuning.hit.velocity.binSpikeRate)','.-');
xmin=min([x';cellfun(@mean,Tuning.miss.velocity.bin);cellfun(@mean,Tuning.falseAlarm.velocity.bin);...
    cellfun(@mean,Tuning.correctRejection.velocity.bin);cellfun(@mean,Tuning.hit.velocity.bin)]);
xmax=max([x';cellfun(@mean,Tuning.miss.velocity.bin);cellfun(@mean,Tuning.falseAlarm.velocity.bin);...
    cellfun(@mean,Tuning.correctRejection.velocity.bin);cellfun(@mean,Tuning.hit.velocity.bin)]);
axis([xmin xmax 0 max([1 y+yerr])]);


% Acceleration vs. Spike Rate
subplot(3,2,5)
x=cellfun(@mean,Tuning.acceleration.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,Tuning.acceleration.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,Tuning.acceleration.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),Tuning.acceleration.binSpikeRate))'; % Std erorr of the 
binBounds=Tuning.acceleration.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
ylabel('SpikeRate (Hz)');
xlabel('Acceleration');

plot(cellfun(@mean,Tuning.miss.acceleration.bin)',cellfun(@mean,Tuning.miss.acceleration.binSpikeRate)','k.-');
plot(cellfun(@mean,Tuning.falseAlarm.acceleration.bin)',cellfun(@mean,Tuning.falseAlarm.acceleration.binSpikeRate)','g.-');
plot(cellfun(@mean,Tuning.correctRejection.acceleration.bin)',cellfun(@mean,Tuning.correctRejection.acceleration.binSpikeRate)','r.-');
plot(cellfun(@mean,Tuning.hit.acceleration.bin)',cellfun(@mean,Tuning.hit.acceleration.binSpikeRate)','.-');
xmin=min([x';cellfun(@mean,Tuning.miss.acceleration.bin);cellfun(@mean,Tuning.falseAlarm.acceleration.bin);...
    cellfun(@mean,Tuning.correctRejection.acceleration.bin);cellfun(@mean,Tuning.hit.acceleration.bin)]);
xmax=max([x';cellfun(@mean,Tuning.miss.acceleration.bin);cellfun(@mean,Tuning.falseAlarm.acceleration.bin);...
    cellfun(@mean,Tuning.correctRejection.acceleration.bin);cellfun(@mean,Tuning.hit.acceleration.bin)]);
axis([xmin xmax 0 max([1 y+yerr])]);



% Moment vs. Spike Rate
subplot(3,2,4)
x=cellfun(@mean,Tuning.M0combo.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,Tuning.M0combo.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,Tuning.M0combo.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),Tuning.M0combo.binSpikeRate))'; % Std erorr of the 
binBounds=Tuning.M0combo.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Moment');

plot(cellfun(@mean,Tuning.miss.M0combo.bin)',cellfun(@mean,Tuning.miss.M0combo.binSpikeRate)','k.-');
plot(cellfun(@mean,Tuning.falseAlarm.M0combo.bin)',cellfun(@mean,Tuning.falseAlarm.M0combo.binSpikeRate)','g.-');
plot(cellfun(@mean,Tuning.correctRejection.M0combo.bin)',cellfun(@mean,Tuning.correctRejection.M0combo.binSpikeRate)','r.-');
plot(cellfun(@mean,Tuning.hit.M0combo.bin)',cellfun(@mean,Tuning.hit.M0combo.binSpikeRate)','.-');
xmin=min([x';cellfun(@mean,Tuning.miss.M0combo.bin);cellfun(@mean,Tuning.falseAlarm.M0combo.bin);...
    cellfun(@mean,Tuning.correctRejection.M0combo.bin);cellfun(@mean,Tuning.hit.M0combo.bin)]);
xmax=max([x';cellfun(@mean,Tuning.miss.M0combo.bin);cellfun(@mean,Tuning.falseAlarm.M0combo.bin);...
    cellfun(@mean,Tuning.correctRejection.M0combo.bin);cellfun(@mean,Tuning.hit.M0combo.bin)]);
axis([xmin xmax 0 max([1 y+yerr])]);

% Faxial vs. Spike Rate
subplot(3,2,6)
x=cellfun(@mean,Tuning.Faxial.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,Tuning.Faxial.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,Tuning.Faxial.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),Tuning.Faxial.binSpikeRate))'; % Std erorr of the 
binBounds=Tuning.Faxial.binBounds;

if ~isempty([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)])
    patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
    hold on;
    plot(x,y,'ko')
    axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Faxial');

plot(cellfun(@mean,Tuning.miss.Faxial.bin)',cellfun(@mean,Tuning.miss.Faxial.binSpikeRate)','k.-');
plot(cellfun(@mean,Tuning.falseAlarm.Faxial.bin)',cellfun(@mean,Tuning.falseAlarm.Faxial.binSpikeRate)','g.-');
plot(cellfun(@mean,Tuning.correctRejection.Faxial.bin)',cellfun(@mean,Tuning.correctRejection.Faxial.binSpikeRate)','r.-');
plot(cellfun(@mean,Tuning.hit.Faxial.bin)',cellfun(@mean,Tuning.hit.Faxial.binSpikeRate)','.-');
xmin=min([x';cellfun(@mean,Tuning.miss.Faxial.bin);cellfun(@mean,Tuning.falseAlarm.Faxial.bin);...
    cellfun(@mean,Tuning.correctRejection.Faxial.bin);cellfun(@mean,Tuning.hit.Faxial.bin)]);
xmax=max([x';cellfun(@mean,Tuning.miss.Faxial.bin);cellfun(@mean,Tuning.falseAlarm.Faxial.bin);...
    cellfun(@mean,Tuning.correctRejection.Faxial.bin);cellfun(@mean,Tuning.hit.Faxial.bin)]);
axis([xmin xmax 0 max([1 y+yerr])]);
end

% Trial Info vs. Spike Rate
subplot(3,2,2)
plot([0 1],[0 1],'.');
set(gca,'Visible','off');
try
    text(-.1,1, ['\fontsize{8}' 'Time Period : \bf' g.displayType '  ' num2str([g.arbTimes{1} g.arbTimes{2}])]);
end
    text(-.1,.9, ['\fontsize{8}' 'AP Synaptic Offset : \bf' num2str(g.spikeSynapticOffset) ' (s)']);
text(-.1,.8, ['\fontsize{8}\color[rgb]{.5 .5 .5}' 'AP Integration Window : ' num2str(g.spikeRateWindow) ' (s)']);
text(-.1,.7, ['\fontsize{8}' 'Contact Threshold ' num2str(g.touchThresh(1)) ' / ' num2str(g.touchThresh(2)) ' / ' num2str(g.touchThresh(3)) ' / ' num2str(g.touchThresh(4))]);   
text(-.1,.6, ['\fontsize{8}' 'Bins : \bf' num2str(g.maxBins) '  \rmN per Bin : \bf' num2str(length(Tuning.position.bin{1}))]);
text(-.1,.5, ['\fontsize{8}' 'Mean Answer Time : ' num2str(g.meanAnswerTime) ' (s)']);
text(-.1,.4, ['\fontsize{8}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
text(-.1,.3, ['\fontsize{8}' 'Mouse : ' array.mouseName]);
text(-.1,.2, ['\fontsize{8}' 'Cell : ' array.cellNum '' array.cellCode]) ;
text(-.1,.1, ['\fontsize{8}' 'Location : ' num2str(array.depth) '\mum' ' ' array.recordingLocation]) ;

set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
print(h_tuning, '-depsc',[array.mouseName '-' array.cellNum '-' 'tuning-' g.displayType '-' num2str(g.spikeSynapticOffset) '.eps']);

assignin('base', 'Tuning', Tuning);
