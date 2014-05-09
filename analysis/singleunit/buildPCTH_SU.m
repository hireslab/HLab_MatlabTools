% Cell and Contact Summarizer
%
% % CTAdir = '/Volumes/MONOLITH/Silicon/CTA'
% % ConTAdir = '/Volumes/MONOLITH/Silicon/ConTA/new'
% CTAdir = 'Q:\Silicon\CTA'
% ConTAdir = '/Lab/Whisker Project/SingleUnit/ConTA/'
ConTAdir = 'Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\'
TAdir = 'Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\'
 
 cd(TAdir)
 TAd = dir('*trial_array*')
 cd(ConTAdir)
 ConTAd = dir('*ConTA*')

for sessNum = 1:53
    load([TAdir TAd(sessNum).name])
    load([ConTAdir ConTAd(sessNum).name])
    %% Setup
    
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));

    segmentInds = {};
    
    tt{1} = whiskerTIN(cellfun(@(x)x.trialContactType==1, contacts(whiskerTIN)));
    tt{2} = whiskerTIN(cellfun(@(x)x.trialContactType==2, contacts(whiskerTIN)));
    tt{3} = whiskerTIN(cellfun(@(x)x.trialContactType==3, contacts(whiskerTIN)));
    tt{4} = whiskerTIN(cellfun(@(x)x.trialContactType==4, contacts(whiskerTIN)));
    tt{5} = whiskerTIN(cellfun(@(x)x.trialContactType==0, contacts(whiskerTIN))); % No Contact
    
    
    Sind = find(cellfun(@(x)strncmpi(x, T.sessionName,16),S.filename))
    
    spikeUseFlag=[];
    
    trialNums = T.trialNums;
    
    segmentInds(whiskerTIN) = cellfun(@(x)x.segmentInds{1},contacts(whiskerTIN),'UniformOutput',0)
    
    
    cellNum = T.cellNum;
    wfS = T.trials{find(T.whiskerTrialInds,1,'first')}.whiskerTrial.framePeriodInSec; % Whisker Frame Duration
    sfS = T.trials{find(T.whiskerTrialInds,1,'first')}.spikesTrial.sampleRate; % Spike Sampling Rate
    wTTO = T.whiskerTrialTimeOffset;
    
    for i=1:length(contacts)
        spikeTimes{i} = T.trials{i}.spikesTrial.spikeTimes;
    end
    
    %% Plotting
    
    % axisSize = [-1 5 1 length(T.trials)];
    % axisSizeSeq = [-1 5 1 length(tt{1})];
    % cAlign = 2;
    %
    % j=17% cellNumber
    %
    % % By trial number
    % figure(2)
    %
    % for k = 1:4
    %     subplot(2,2,k);
    %     cla;hold on;
    %
    %     for i = tt{k}
    %         try
    %             plot(double(spikeTimes{j})/sfS+wTTO-wfS*segmentInds{i}(cAlign,1),trialNums(i),'k.')
    %         end
    %     end
    %     axis(axisSize)
    %
    % grid on
    % end
    % % By sequential number
    %
    % figure(3)
    %
    % for k = 1:3
    %     subplot(2,2,k);
    %     cla;hold on;
    %     p_ind = tt{k};
    %     for i = 1:length(p_ind)
    %         try
    %             plot(double(spikeTimes{p_ind(i)}{j})/sfS+wTTO-wfS*segmentInds{p_ind(i)}(cAlign,1),i,'k.')
    %         end
    %     end
    %     axis(axisSizeSeq)
    % grid on
    %
    % end
    
    
    %% Contact Summaries
    
    
    
    
    
    %% Find baseline firing
    
    % baselineSR is the pre-cue spiking rate.  To calculate the spike
    % contributions on top of the motion induced spiking it is probably
    % better to use a 500ms pre initial contact baseline spike rate
    pcBaselineSR=[];
    for k=1:5
      
            baselineSR(k) = nanmean(cellfun(@(x)sum(x.spikesTrial.spikeTimes > .4*19530 & x.spikesTrial.spikeTimes < .7 *19530)/.6,...
                T.trials(tt{k})));
            
            
            tmp =[];
            trials = tt{k};
            for j = 1:length(trials)
                if isempty(contacts{trials(j)}.segmentInds{1})
                    pcWindow = ([T.trials{trials(j)}.pinDescentOnsetTime T.trials{trials(j)}.pinDescentOnsetTime+.5]*T.trials{1}.spikesTrial.sampleRate);
                    
                else
                    pcWindow =  ([contacts{trials(j)}.segmentInds{1}(1)-500 contacts{trials(j)}.segmentInds{1}(1)]/1000-T.whiskerTrialTimeOffset)*T.trials{1}.spikesTrial.sampleRate;
                end
                
                tmp(j)  = sum(T.trials{trials(j)}.spikesTrial.spikeTimes > pcWindow(1) & ...
                    T.trials{trials(j)}.spikesTrial.spikeTimes < pcWindow(2));
                
                
            end
            pcBaselineSR(k) = nanmean(tmp)/.5;
            
            
            
            
            nanmean(cellfun(@(x)sum(x.spikesTrial.spikeTimes > (-T.whiskerTrialTimeOffset + x.pinDescentOnsetTime)*19530 &...
                x.spikesTrial.spikeTimes < (-T.whiskerTrialTimeOffset + x.pinDescentOnsetTime)*19530)...
                /-T.whiskerTrialTimeOffset,...
                T.trials(tt{k})))
      
    end
    

    
    
    %% Find means, modulation, adaptation
    
    
    
    
    %     colors = prism(6);
    %     figure(5);clf;
    
    timeWindow = [0 .05]
    set(0, 'DefaultAxesFontSize', 8);
    titleType = {'Go Pro','Go Ret', 'Nogo Pro'}
    
    
    for j=1:length(Sind)% cellNumber
        figure(j);clf;set(gcf,'Position',[25 25 1500 1200],'PaperPosition',[0 0 15 12],'PaperSize',[15 12])
        
        for cAlign = 1:5; % Number of contact to align to
            
            
            
            binSize        = .001; % sec
            startWindow    = -0.05; % seconds
            endWindow      = .05; % seconds
            edges          = startWindow:binSize:endWindow;
            
            
            for k=1:3
                subplot(4,5,cAlign+(k)*5);hold on
                
                allSpikes{k,cAlign} = [];
                
                for i = tt{k}
                    try
                        allSpikes{k,cAlign} = cat(1,allSpikes{k,cAlign},double(spikeTimes{i})/sfS-wTTO-wfS*segmentInds{i}(cAlign,1));
                    end
                end
                
                allLength{k,cAlign} = sum(cellfun(@(x)size(x,1),segmentInds(tt{k}))>=cAlign);
                allHist{k,cAlign}   = histc(allSpikes{k,cAlign},edges)/allLength{k,cAlign}/binSize;
                
                if isempty(allHist{k,cAlign})
                    allHist{k,cAlign} = zeros(length(edges(:)),1);
                end
                %windSR(j,cAlign,k) = sum(allSpikes{k,cAlign} > timeWindow(1) & allSpikes{k,cAlign} < timeWindow(2)) / allLength{1} / diff(timeWindow);
                
                bar(edges+binSize/2,allHist{k,cAlign},'k')
                %plot(edges+binSize/2,allHist{k},'Color',colors(cAlign,:),'LineWidth',2)
                plot([startWindow endWindow],[pcBaselineSR(k) pcBaselineSR(k)],'r:')
                
                
                tlabel{k,cAlign}=sprintf('%0.2f',(mean(allHist{k,cAlign}(find(abs(edges - timeWindow(1))<.0001):find(abs(edges - timeWindow(2))<.0001)-1))-pcBaselineSR(k))*(timeWindow(2)-timeWindow(1)));
                
                set(gca,'Xlim',[startWindow endWindow])
                % xlabel('Time (s)')
                %ylabel('Mean Spike Count')
                grid on
                title([titleType{k} ' Contact #' num2str(cAlign)])
            end
           
        end
        ylimit =  [0 max(max(cellfun(@(x)max(x),allHist)))*1.01];
        for k=1:3
            for cAlign = 1:5; % Number of contact to align to
                
                subplot(4,5,cAlign+(k)*5);hold on
                set(gca,'YLim',ylimit)
                
                text(.001,ylimit(2)*.9,[sprintf('%0.2f',pcBaselineSR(k)) ' baseline rate'],'FontSize',8);
                text(.001,ylimit(2)*(.8),[tlabel{k,cAlign} ' spikes added'],'FontSize',8 ,'color' ,[1 0 0 ]);
                
            end
        end
        
 
   
        allGoProSpikes      = [];
        allGoRetSpikes      = [];
        allNogoProSpikes    = [];
        allAllSpikes        = [];
        for i=1:length(allSpikes(:))
            allAllSpikes = cat(1,allAllSpikes,allSpikes{i});
        end
        for i=1: size(allSpikes,2)
            allGoProSpikes = cat(1,allGoProSpikes,allSpikes{1,i});
        end
        for i=1: size(allSpikes,2)
            allGoRetSpikes = cat(1,allGoRetSpikes,allSpikes{2,i});
        end
        for i=1:size(allSpikes,2)
            allNogoProSpikes = cat(1,allNogoProSpikes,allSpikes{3,i});
        end

        %Grand Mean
        subplot(4,5,1);cla;
        allAllHist = histc(allAllSpikes,edges)/sum(sum(cellfun(@(x)x,allLength)))/binSize;
        bar(edges+binSize/2,allAllHist,'k')
        hold on
        normSR = [allLength{1} allLength{2} allLength{3}]./(allLength{1,1}+allLength{2,1}+allLength{3,1});

        plot([startWindow endWindow],[ sum(pcBaselineSR(1:3).*normSR) sum(pcBaselineSR(1:3).*normSR)],'r:')
        text(.001,ylimit(2)*.9,[sprintf('%0.2f',sum(pcBaselineSR(1:3).*normSR)) ' baseline rate'],'FontSize',8);
        text(.001,ylimit(2)*(.8),[sprintf('%0.2f',(mean(allAllHist(find(abs(edges - timeWindow(1))<.0001):find(abs(edges - timeWindow(2))<.0001)-1))-sum(pcBaselineSR(1:3).*normSR))*(timeWindow(2)-timeWindow(1))) ' spikes added'],...
            'FontSize',8 ,'color' ,[1 0 0 ]);
        set(gca,'Xlim',[startWindow endWindow],'YLim',ylimit)
        grid on
        
        title('Contacts Grand Mean')
        subplot(4,5,11)
        ylabel('Spike Rate (spikes/s)')
        subplot(4,5,18)
        xlabel('Time since contact (s)')
        
        %Go Pro Mean
        subplot(4,5,2);cla;
        allGoProHist = histc(allGoProSpikes,edges)/sum(sum(cellfun(@(x)x,allLength(1:3:15))))/binSize;
        bar(edges+binSize/2,allGoProHist,'k')
        hold on
        plot([startWindow endWindow],[pcBaselineSR(1) pcBaselineSR(1)],'r:')
        text(.001,ylimit(2)*.9,[sprintf('%0.2f',pcBaselineSR(1)) ' baseline rate'],'FontSize',8);
        text(.001,ylimit(2)*(.8),[sprintf('%0.2f',(mean(allGoProHist(find(abs(edges - timeWindow(1))<.0001):find(abs(edges - timeWindow(2))<.0001)-1))-pcBaselineSR(1))*(timeWindow(2)-timeWindow(1))) ' spikes added'],...
            'FontSize',8 ,'color' ,[1 0 0 ]);
        set(gca,'Xlim',[startWindow endWindow],'YLim',ylimit)
        grid on
        
        title('Contacts Go Pro Mean')
        subplot(4,5,11)
        ylabel('Spike Rate (spikes/s)')
        subplot(4,5,18)
        xlabel('Time since contact (s)')
       
        %Go Ret Mean
        subplot(4,5,3);cla;
        allGoRetHist = histc(allGoRetSpikes,edges)/sum(sum(cellfun(@(x)x,allLength(2:3:15))))/binSize;
        bar(edges+binSize/2,allGoRetHist,'k')
        hold on
        plot([startWindow endWindow],[pcBaselineSR(2) pcBaselineSR(2)],'r:')
        text(.001,ylimit(2)*.9,[sprintf('%0.2f',pcBaselineSR(2)) ' baseline rate'],'FontSize',8);
        text(.001,ylimit(2)*(.8),[sprintf('%0.2f',(mean(allGoRetHist(find(abs(edges - timeWindow(1))<.0001):find(abs(edges - timeWindow(2))<.0001)-1))-pcBaselineSR(2))*(timeWindow(2)-timeWindow(1))) ' spikes added'],...
            'FontSize',8 ,'color' ,[1 0 0 ]);
        set(gca,'Xlim',[startWindow endWindow],'YLim',ylimit)
        grid on
        
        title('Contacts Go Ret Mean')
        subplot(4,5,11)
        ylabel('Spike Rate (spikes/s)')
        subplot(4,5,18)
        xlabel('Time since contact (s)')
                            
        %NoGo Pro Mean
        subplot(4,5,4);cla;
        allNogoProHist = histc(allNogoProSpikes,edges)/sum(sum(cellfun(@(x)x,allLength(3:3:15))))/binSize;
        bar(edges+binSize/2,allNogoProHist,'k')
        hold on
        plot([startWindow endWindow],[pcBaselineSR(3) pcBaselineSR(3)],'r:')
        text(.001,ylimit(2)*.9,[sprintf('%0.2f',pcBaselineSR(3)) ' baseline rate'],'FontSize',8);
        text(.001,ylimit(2)*(.8),[sprintf('%0.2f',(mean(allNogoProHist(find(abs(edges - timeWindow(1))<.0001):find(abs(edges - timeWindow(2))<.0001)-1))-pcBaselineSR(3))*(timeWindow(2)-timeWindow(1))) ' spikes added'],...
            'FontSize',8 ,'color' ,[1 0 0 ]);
        set(gca,'Xlim',[startWindow endWindow],'YLim',ylimit)
        grid on
        
        title('Contacts Nogo Pro Mean')
        subplot(4,5,11)
        ylabel('Spike Rate (spikes/s)')
        subplot(4,5,18)
        xlabel('Time since contact (s)')
               
        % Cell Info
                subplot(4,5,5);cla;axis off;
        text(0,.9, ['\fontsize{10}' 'Session : ' T.sessionName]);
        text(0,.7, ['\fontsize{10}' 'Cell : ' num2str(T.cellNum)]) ;
        text(0,.3, ['\fontsize{10}' 'Depth : ' num2str(T.depth(j)) ' (um)']) ;
        text(0,.1, ['\fontsize{10}' 'Dist : ' num2str(sqrt(T.recordingLocation(j,1)^2+T.recordingLocation(j,2)^2)) ' (mm)']) ;
        
        
%         S.windowSR{Sind(j)}     = squeeze(windSR(j,:,:));
%         S.adaptationSR{Sind(j)} = S.windowSR{Sind(j)}./repmat(S.windowSR{Sind(j)}(1,:),5,1);
%         S.modulationSR{Sind(j)} = S.windowSR{Sind(j)}./mean(S.baselineSR{Sind(j)}(1:3));
%         S.timeWindowSR{Sind(j)} = timeWindow;

              print('-depsc', ['Z:\users\Andrew\Whisker Project\SingleUnit\PCTH\PCTH_SU' sessNum '_' T.mouseName '_' T.sessionName '_Cell_' num2str(T.cellNum(j))...
            '_Depth' num2str(T.depth(j))])   
    end
end
  
