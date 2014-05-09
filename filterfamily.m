function family=filterfamily(array, contacts, params)




h = waitbar(0,'Sorting Arrays');

windowSpan=.005;
filterRange=[0:windowSpan:.08];
j=length(filterRange);
params.spikeRateWindow=windowSpan;
family=cell(j,1);

[~,useTrials,~]=intersect(array.trialNums, array.whiskerTrialNums);

for l=1:j
    waitbar(l/j,h);
    params.spikeSynapticOffset=filterRange(l);
    filters.position.linear=[];
    filters.acceleration.linear=[];
    filters.velocity.linear=[];
    filters.M0combo.linear=[];
    filters.Faxial.linear=[];
    filters.spikeRateUsed=[];


    for k=useTrials(find(array.trialNums(useTrials) >= params.trialRange(1)& array.trialNums(useTrials) <= params.trialRange(2)));

  
        filters.framesUsed{k}=params.framesUsed;
        time=array.trials{k}.whiskerTrial.time{1}; % All times in current trial
        cT=array.trials{k};
        cW=array.trials{k}.whiskerTrial;
        cB=array.trials{k}.behavTrial;
        cS=array.trials{k}.spikesTrial;

        switch params.displayType

            case 'all'
                params.framesUsed = 1:length(time);

            case 'contactsOnly'
                params.framesUsed = contacts{k}.contactInds{1};

            case 'excludeContacts'
                params.framesUsed = ones(size(time));
                params.framesUsed(contacts{k}.contactInds{1})=0;
                params.framesUsed= find(params.framesUsed);

            case 'poleToDecision'
                if isempty(cB.answerLickTime)==0
                    params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                        time < cB.answerLickTime);
                else
                    params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                        time < params.meanAnswerTime);
                end

            case 'contactToDecision'             
                if isempty(contacts{k}.contactInds{1})==0
                    params.framesUsed = find(time > time(contacts{k}.contactInds{1}(1)) &...
                        time < params.meanAnswerTime);
                else
                    params.framesUsed=[];
                end

            case 'postDecision'             

                if isempty(cB.answerLickTime)==0;
                    params.framesUsed = find(time > cB.answerLickTime);
                else
                    params.framesUsed = find(time> params.meanAnswerTime);
                end

            case 'postPole'             
                params.framesUsed = find(time > cT.pinAscentOnsetTime);

            case 'arbitrary'
                params.framesUsed = find(time > str2num(params.arbTimes{1}) & time < str2num(params.arbTimes{2}));

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

        if isempty(params.framesUsed)==0

            % Save the bounding indexs of hit,miss,FA,and CR trials for the
            % complete linearly sorted dataset

    %         if sum(find(array.hitTrialInds)==k);
    %         filters.index.hit(size(filters.index.hit,1)+1,1:2)=...
    %             [length(filters.spikeRateUsed)+min([1 length(params.framesUsed)]) length(filters.spikeRateUsed)+length(params.framesUsed)];
    %         
    %         elseif sum(find(array.missTrialInds)==k);
    %         filters.index.miss(size(filters.index.miss,1)+1,1:2)=...
    %             [length(filters.spikeRateUsed)+min([1 length(params.framesUsed)]) length(filters.spikeRateUsed)+length(params.framesUsed)];
    %         
    %         elseif sum(find(array.falseAlarmTrialInds)==k);
    %         filters.index.falseAlarm(size(filters.index.falseAlarm,1)+1,1:2)=...
    %             [length(filters.spikeRateUsed)+min([1 length(params.framesUsed)]) length(filters.spikeRateUsed)+length(params.framesUsed)];
    %         
    %         elseif sum(find(array.correctRejectionTrialInds)==k);
    %         filters.index.correctRejection(size(filters.index.correctRejection,1)+1,1:2)=...
    %             [length(filters.spikeRateUsed)+min([1 length(params.framesUsed)]) length(filters.spikeRateUsed)+length(params.framesUsed)];
    %         else
    %         end
    %         
            % Sort spikerate vs. various for every timepoint in dataset. 

            sampleRate=cS.sampleRate;
            spikeRate=smooth(spikeIndex,params.spikeRateWindow*sampleRate)*sampleRate;
            spikeRateUsed=spikeRate(params.framesUsed*10+round((array.whiskerTrialTimeOffset+params.spikeSynapticOffset)*sampleRate));    
            filters.spikeRateUsed=cat(1,filters.spikeRateUsed,spikeRateUsed);

            xP=cW.thetaAtBase{1};
            xPos{1}=xP(params.framesUsed);
            filters.position.linear=cat(2,filters.position.linear,xPos{1}); 

            xV=diff([0 xP])./diff([0 time]);
            xVel{1}=xV(params.framesUsed);
            filters.velocity.linear=cat(2,filters.velocity.linear,xVel{1}); 

            xA=diff([0 xV])./diff([0 time]);
            xAcc{1}=xA(params.framesUsed);
            filters.acceleration.linear=cat(2,filters.acceleration.linear,xAcc{1});   

            filters.M0combo.linear=cat(2,filters.M0combo.linear,contacts{k}.M0combo{1}(params.framesUsed));
            filters.Faxial.linear=cat(2,filters.Faxial.linear,contacts{k}.FaxialAdj{1}(params.framesUsed));


        else
        end

    end




% Bin and sort all data

[filters.position.binSpikeRate filters.position.bin filters.position.binBounds]=...
    binslin(filters.position.linear,filters.spikeRateUsed,'equalN',params.maxBins);
[filters.velocity.binSpikeRate filters.velocity.bin filters.velocity.binBounds]=...
    binslin(filters.velocity.linear,filters.spikeRateUsed,'equalN',params.maxBins);
[filters.acceleration.binSpikeRate filters.acceleration.bin filters.acceleration.binBounds]=...
    binslin(filters.acceleration.linear,filters.spikeRateUsed,'equalN',params.maxBins);
[filters.M0combo.binSpikeRate filters.M0combo.bin filters.M0combo.binBounds]=...
    binslin(filters.M0combo.linear,filters.spikeRateUsed,'equalN',params.maxBins);
[filters.Faxial.binSpikeRate filters.Faxial.bin filters.Faxial.binBounds]=...
    binslin(filters.Faxial.linear(find(filters.Faxial.linear)),filters.spikeRateUsed(find(filters.Faxial.linear)),'equalN',min([params.maxBins length(find(filters.Faxial.linear))]));

family{l}.position.bin = cellfun(@mean,(filters.position.bin));
family{l}.position.binSpikeRate = cellfun(@mean,(filters.position.binSpikeRate));
family{l}.position.binBounds = filters.position.binBounds;

family{l}.velocity.bin = cellfun(@mean,(filters.velocity.bin));
family{l}.velocity.binSpikeRate = cellfun(@mean,(filters.velocity.binSpikeRate));
family{l}.velocity.binBounds = filters.velocity.binBounds;

family{l}.acceleration.bin = cellfun(@mean,(filters.acceleration.bin));
family{l}.acceleration.binSpikeRate = cellfun(@mean,(filters.acceleration.binSpikeRate));
family{l}.acceleration.binBounds = filters.acceleration.binBounds;

family{l}.M0combo.bin = cellfun(@mean,(filters.M0combo.bin));
family{l}.M0combo.binSpikeRate = cellfun(@mean,(filters.M0combo.binSpikeRate));
family{l}.M0combo.binBounds = filters.M0combo.binBounds;

family{l}.Faxial.bin = cellfun(@mean,(filters.Faxial.bin));
family{l}.Faxial.binSpikeRate = cellfun(@mean,(filters.Faxial.binSpikeRate));
family{l}.Faxial.binBounds = filters.Faxial.binBounds;
end

close(h);
% % Rebin all hit data
% 
% ind=[];
% for i=1:size(filters.index.hit,1)
% ind=cat(2,ind,filters.index.hit(i,1):filters.index.hit(i,2));
% end
% 
% [filters.hit.position.binSpikeRate filters.hit.position.bin filters.hit.position.binBounds]=...
%     binslin(filters.position.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.hit.velocity.binSpikeRate filters.hit.velocity.bin filters.hit.velocity.binBounds]=...
%     binslin(filters.velocity.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.hit.acceleration.binSpikeRate filters.hit.acceleration.bin filters.hit.acceleration.binBounds]=...
%     binslin(filters.acceleration.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.hit.M0combo.binSpikeRate filters.hit.M0combo.bin filters.hit.M0combo.binBounds]=...
%     binslin(filters.M0combo.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.hit.Faxial.binSpikeRate filters.hit.Faxial.bin filters.hit.Faxial.binBounds]=...
%     binslin(filters.Faxial.linear(find(filters.Faxial.linear(ind))),filters.spikeRateUsed(find(filters.Faxial.linear(ind))),'equalN',min([params.maxBins length(find(filters.Faxial.linear(ind)))]));
% 
% % Rebin all miss data
% 
% ind=[];
% for i=1:size(filters.index.miss,1)
% ind=cat(2,ind,filters.index.miss(i,1):filters.index.miss(i,2));
% end
% 
% [filters.miss.position.binSpikeRate filters.miss.position.bin filters.miss.position.binBounds]=...
%     binslin(filters.position.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.miss.velocity.binSpikeRate filters.miss.velocity.bin filters.miss.velocity.binBounds]=...
%     binslin(filters.velocity.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.miss.acceleration.binSpikeRate filters.miss.acceleration.bin filters.miss.acceleration.binBounds]=...
%     binslin(filters.acceleration.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.miss.M0combo.binSpikeRate filters.miss.M0combo.bin filters.miss.M0combo.binBounds]=...
%     binslin(filters.M0combo.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.miss.Faxial.binSpikeRate filters.miss.Faxial.bin filters.miss.Faxial.binBounds]=...
%     binslin(filters.Faxial.linear(find(filters.Faxial.linear(ind))),filters.spikeRateUsed(find(filters.Faxial.linear(ind))),'equalN',min([params.maxBins length(find(filters.Faxial.linear(ind)))]));
% 
% % Rebin all falseAlarm data
% 
% ind=[];
% for i=1:size(filters.index.falseAlarm,1)
% ind=cat(2,ind,filters.index.falseAlarm(i,1):filters.index.falseAlarm(i,2));
% end
% 
% [filters.falseAlarm.position.binSpikeRate filters.falseAlarm.position.bin filters.falseAlarm.position.binBounds]=...
%     binslin(filters.position.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.falseAlarm.velocity.binSpikeRate filters.falseAlarm.velocity.bin filters.falseAlarm.velocity.binBounds]=...
%     binslin(filters.velocity.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.falseAlarm.acceleration.binSpikeRate filters.falseAlarm.acceleration.bin filters.falseAlarm.acceleration.binBounds]=...
%     binslin(filters.acceleration.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.falseAlarm.M0combo.binSpikeRate filters.falseAlarm.M0combo.bin filters.falseAlarm.M0combo.binBounds]=...
%     binslin(filters.M0combo.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.falseAlarm.Faxial.binSpikeRate filters.falseAlarm.Faxial.bin filters.falseAlarm.Faxial.binBounds]=...
%     binslin(filters.Faxial.linear(find(filters.Faxial.linear(ind))),filters.spikeRateUsed(find(filters.Faxial.linear(ind))),'equalN',min([params.maxBins length(find(filters.Faxial.linear(ind)))]));
% 
% % Rebin all correctionRejection data
% 
% ind=[];
% for i=1:size(filters.index.correctRejection,1)
% ind=cat(2,ind,filters.index.correctRejection(i,1):filters.index.correctRejection(i,2));
% end
% 
% [filters.correctRejection.position.binSpikeRate filters.correctRejection.position.bin filters.correctRejection.position.binBounds]=...
%     binslin(filters.position.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.correctRejection.velocity.binSpikeRate filters.correctRejection.velocity.bin filters.correctRejection.velocity.binBounds]=...
%     binslin(filters.velocity.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.correctRejection.acceleration.binSpikeRate filters.correctRejection.acceleration.bin filters.correctRejection.acceleration.binBounds]=...
%     binslin(filters.acceleration.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.correctRejection.M0combo.binSpikeRate filters.correctRejection.M0combo.bin filters.correctRejection.M0combo.binBounds]=...
%     binslin(filters.M0combo.linear(ind),filters.spikeRateUsed(ind),'equalN',params.maxBins);
% [filters.correctRejection.Faxial.binSpikeRate filters.correctRejection.Faxial.bin filters.correctRejection.Faxial.binBounds]=...
%     binslin(filters.Faxial.linear(find(filters.Faxial.linear(ind))),filters.spikeRateUsed(find(filters.Faxial.linear(ind))),'equalN',min([params.maxBins length(find(filters.Faxial.linear(ind)))]));
% 

assignin('base', 'family', family);


% Position vs. Spike Rate
h_tuning=figure;
subplot(3,2,1)
x=cellfun(@mean,filters.position.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,filters.position.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,filters.position.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),filters.position.binSpikeRate))'; % Std erorr of the 
binBounds=filters.position.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko');
ylabel('SpikeRate (Hz)');
xlabel('Azimuth');

xmin=min(x');
xmax=max(x');
axis([xmin xmax 0 max([1 y+yerr])]);


% Velocity vs. Spike Rate
subplot(3,2,3)
x=cellfun(@mean,filters.velocity.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,filters.velocity.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,filters.velocity.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),filters.velocity.binSpikeRate))'; % Std erorr of the 
binBounds=filters.velocity.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Velocity');


xmin=min(x');
xmax=max(x');
axis([xmin xmax 0 max([1 y+yerr])]);


% Acceleration vs. Spike Rate
subplot(3,2,5)
x=cellfun(@mean,filters.acceleration.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,filters.acceleration.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,filters.acceleration.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),filters.acceleration.binSpikeRate))'; % Std erorr of the 
binBounds=filters.acceleration.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
ylabel('SpikeRate (Hz)');
xlabel('Acceleration');


xmin=min(x');
xmax=max(x');
axis([xmin xmax 0 max([1 y+yerr])]);



% Moment vs. Spike Rate
subplot(3,2,4)
x=cellfun(@mean,filters.M0combo.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,filters.M0combo.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,filters.M0combo.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),filters.M0combo.binSpikeRate))'; % Std erorr of the 
binBounds=filters.M0combo.binBounds;

patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
hold on;
plot(x,y,'ko')
axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Moment');

xmin=min(x');
xmax=max(x');axis([xmin xmax 0 max([1 y+yerr])]);

% Faxial vs. Spike Rate
subplot(3,2,6)
x=cellfun(@mean,filters.Faxial.bin)';           % Define middle of bin boundries as X coords
y=cellfun(@mean,filters.Faxial.binSpikeRate)';                             % Y cords are mean spike rate of the bin
yerr=(cellfun(@std,filters.Faxial.binSpikeRate))';%./cellfun(@(x) sqrt(length(x)),filters.Faxial.binSpikeRate))'; % Std erorr of the 
binBounds=filters.Faxial.binBounds;

if ~isempty([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)])
    patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 .8],'EdgeColor','none');
    hold on;
    plot(x,y,'ko')
    axis([(binBounds(1)+binBounds(2))/2 (binBounds(end)+binBounds(end-1))/2 0 max([1 y+yerr])]);
ylabel('SpikeRate (Hz)');
xlabel('Faxial');


xmin=min(x');
xmax=max(x');axis([xmin xmax 0 max([1 y+yerr])]);
end

% Trial Info vs. Spike Rate
subplot(3,2,2)
plot([0 1],[0 1],'.');
set(gca,'Visible','off');
try
    text(-.1,1, ['\fontsize{8}' 'Time Period : \bf' params.displayType '  ' num2str([params.arbTimes{1} params.arbTimes{2}])]);
end
    text(-.1,.9, ['\fontsize{8}' 'AP Synaptic Offset : \bf' num2str(params.spikeSynapticOffset) ' (s)']);
text(-.1,.8, ['\fontsize{8}\color[rgb]{.5 .5 .5}' 'AP Integration Window : ' num2str(params.spikeRateWindow) ' (s)']);
text(-.1,.7, ['\fontsize{8}' 'Contact Threshold ' num2str(params.touchThresh(1)) ' / ' num2str(params.touchThresh(2)) ' / ' num2str(params.touchThresh(3)) ' / ' num2str(params.touchThresh(4))]);   
text(-.1,.6, ['\fontsize{8}' 'Bins : \bf' num2str(params.maxBins) '  \rmN per Bin : \bf' num2str(length(filters.position.bin{1}))]);
text(-.1,.5, ['\fontsize{8}' 'Mean Answer Time : ' num2str(params.meanAnswerTime) ' (s)']);
text(-.1,.4, ['\fontsize{8}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
text(-.1,.3, ['\fontsize{8}' 'Mouse : ' array.mouseName]);
text(-.1,.2, ['\fontsize{8}' 'Cell : ' array.cellNum '' array.cellCode]) ;
text(-.1,.1, ['\fontsize{8}' 'Location : ' num2str(array.depth) '\mum' ' ' array.recordingLocation]) ;

set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
print(h_tuning, '-depsc',[array.mouseName '-' array.cellNum '-' 'tuning-' params.displayType '-' num2str(params.spikeSynapticOffset) '.eps']);

assignin('base', 'family', family);
