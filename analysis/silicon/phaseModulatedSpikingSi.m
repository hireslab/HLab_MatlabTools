Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\');
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\');
Si_CADir = ('Z:\Users\Andrew\Whisker Project\Silicon\CellAnalysisArrays\');
savedir = 'Z:\users\Andrew\Whisker Project\Silicon\Figures\PhaseModTouch\';

Snums =S.PCTH.sharpTouchCells;
for cellNum = 1:length(Snums);
    if ~strcmp( S.trialArrayName{Snums(cellNum)}(5:17), T.sessionName(4:16))
        display(['Loading '  S.trialArrayName{Snums(cellNum)}])
        load([Si_TDir S.trialArrayName{Snums(cellNum)}]);
        load([Si_ConDir S.contactsArrayName{Snums(cellNum)}]);
    end
    clustInd = find(T.cellNum == S.clust{Snums(cellNum)} & T.shankNum==S.shank{Snums(cellNum)});
    
    load([Si_CADir S.filename{Snums(cellNum)}]);
    
    figure(2);clf;hold on
    
    cind = {};
    
    contactNumbers = 1:10;
    %     for i = intersect(find(cellfun(@(x)~isempty(x),CA.phase)),find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag ==1,T.trials)))
    
    phaseParsedConTSpikes = cell(8,1);
    phaseParsedConTM0Adj = cell(8,1);
    phaseParsedConTTheta = cell(8,1);
    phaseParsedConTVelocity = cell(8,1);
    phaseParsedConTAccel = cell(8,1);
    phaseParsedConTSetpoint = cell(8,1);
    phaseParsedConTAmp = cell(8,1);
    vel = {};
    accel = {};
    
    useTrials = intersect(find(cellfun(@(x)~isempty(x),CA.phase)),find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag ==1,T.trials)));
    vel(useTrials) = getVelocity(T, useTrials, 5);
    accel(useTrials) = getAccel(T, useTrials, 5);

%     figure(1);clf;hold on
    for i = useTrials
        M0Adj = zeros(size(contacts{i}.M0comboAdj{1}));
        M0Adj(contacts{i}.contactInds{1}) = contacts{i}.M0comboAdj{1}(contacts{i}.contactInds{1});
        
        
        for j = contactNumbers
            if size(contacts{i}.segmentInds{1},1)>=j
                if T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)) <= min([T.trials{i}.answerLickTime 2.5]);
                    
                    [~,cind{i}(j)]  = min(abs(CA.time{i} -  T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1))));
                    phaseQuad{i}(j) = ceil(8*((CA.phase{i}(cind{i}(j))/(2*pi)+.5)));
                    phaseParsedConTSpikes{phaseQuad{i}(j)} = cat(1,phaseParsedConTSpikes{phaseQuad{i}(j)}, CA.spikeArray{i}(cind{i}(j)+[-100:100])');
                    phaseParsedConTM0Adj{phaseQuad{i}(j)}  = cat(1,phaseParsedConTM0Adj{phaseQuad{i}(j)}, M0Adj(cind{i}(j)+[-100:100]));
                    phaseParsedConTTheta{phaseQuad{i}(j)} = cat(1,phaseParsedConTTheta{phaseQuad{i}(j)}, CA.theta{i}(cind{i}(j)+[-100:100]));
                    phaseParsedConTVelocity{phaseQuad{i}(j)} = cat(1,phaseParsedConTVelocity{phaseQuad{i}(j)}, vel{i}(cind{i}(j)+[-100:100]));
                    phaseParsedConTAccel{phaseQuad{i}(j)} = cat(1,phaseParsedConTAccel{phaseQuad{i}(j)}, accel{i}(cind{i}(j)+[-100:100]));
                    phaseParsedConTSetpoint{phaseQuad{i}(j)} = cat(1,phaseParsedConTSetpoint{phaseQuad{i}(j)}, CA.setpoint{i}(cind{i}(j)+[-100:100]));
                    phaseParsedConTAmp{phaseQuad{i}(j)} = cat(1,phaseParsedConTAmp{phaseQuad{i}(j)}, CA.amplitude{i}(cind{i}(j)+[-100:100]));
   
    
                    
%                     
%                     if strcmp(T.trials{i}.trialOutcome, 'Hit')
%                         plot(j,CA.phase{i}(cind{i}(j)),'bo')
%                     elseif strcmp(T.trials{i}.trialOutcome , 'FalseAlarm')
%                         plot(j,CA.phase{i}(cind{i}(j)),'go')
%                     elseif strcmp(T.trials{i}.trialOutcome , 'CorrectRejection')
%                         plot(j,CA.phase{i}(cind{i}(j)),'ro')
%                     end
                end
            end
        end
    end
    
    CA.phaseParsedConTSpikes = phaseParsedConTSpikes;
    
    phaseSpikeContactMap = [];
     cmap = hsv(8);
%      figure(2);clf;hold on
     for i = 1:8
         phaseSpikeContactMap(i,:) = smooth(nanmean(phaseParsedConTSpikes{i}),10);
%          plot(smooth(nanmean(phaseParsedConTSpikes{i}),10),'color',cmap(i,:));
     end
figure(3);clf;subplot(2,5,[1 2 3 6 7 8])
imagesc(phaseSpikeContactMap(:,50:150));
colormap(summer);
ylabel('Phase bin')
xlabel('Time from contact')
title([S.filename{Snums(cellNum)}(1:end-4) '(' num2str(Snums(cellNum)) ')'])
set(gca,'xtick',[1 26 51 76 101],'xticklabel',{'-50','-25','0','25','50'})

subplot(2,5,[4  9]);cla;hold on
plot(mean(phaseSpikeContactMap(:,105:125)'),[-1:-1:-8],'ko-')
title('Touch')
xlabel('spk/s')
subplot(2,5,[5  10]);cla;hold on
title('Phase')

plot(CA.phaseSRBinned.phaseSRMean,[-1:-1:-8],'ro-')
xlabel('spk/s')

print(gcf, '-depsc', [savedir 'PhaseModTouch_1-3Contact' S.filename{Snums(cellNum)}(1:end-4)]);

end
