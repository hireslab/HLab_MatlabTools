% Velocity selectivity



CTAdir = '/Lab/Silicon/CTA'
ConTAdir = '/Lab/Silicon/ConTA/'
%  CTAdir = '/Volumes/MONOLITH/Silicon/CTA'
%  ConTAdir = '/Volumes/MONOLITH/Silicon/ConTA/new'
% % CTAdir = 'Q:/Silicon/CTA'
% ConTAdir = 'Q:/Silicon/ConTA/new'

cd(CTAdir)
CTAd = dir('*CTA*')
cd(ConTAdir)
ConTAd = dir('*ConTA*')




for sess = 1:21
    cd(ConTAdir)
    load(ConTAd(sess).name)
    
    
    cd(CTAdir)
    load(CTAd(sess).name)
    
    Sind = find(cellfun(@(x)strncmpi(x, T.sessionName,16),S.filename));
    
    
    nClusts = 1:length(T.cellNum)
    whiskerTIN  = find(T.whiskerTrialInds);
    
    baselineSR=[];
    
    for i=1:20
        subplot(4,5,i);cla;hold on;
        set(gca,'XLim',[-1 4.5]);
    end
    
    
    for cNum = nClusts
        st(whiskerTIN) = cellfun(@(x)double(x.shanksTrial.clustData{cNum}.spikeTimes)./19530-.490, T.trials(whiskerTIN),'UniformOutput',0)
        bbt(whiskerTIN) = cellfun(@(x)x.beamBreakTimes(x.beamBreakTimes <4.5), T.trials(whiskerTIN),'UniformOutput',0)
        
        figure(1);
        subplot(4,5,[1 2 6 7]);cla;hold on;title('All Trials')
        axis([-.5 4.5 0 T.whiskerTrialNums(end)]);
        subplot(4,5,3);cla;hold on;title('Hit Trials');axis([-.5 4.5 0 100])
        subplot(4,5,4);cla;hold on;title('Miss Trials');axis([-.5 4.5 0 100])
        subplot(4,5,8);cla;hold on;title('CR Trials');axis([-.5 4.5 0 100])
        subplot(4,5,9);cla;hold on;title('FA Trials');axis([-.5 4.5 0 100])
        subplot(4,5,10);cla;hold on;title('No Contact');axis([-1 4 0 100])
        subplot(4,5,11);cla;hold on;title('Go Con #1 Pro');axis([-.5 1.5 0 50])
        subplot(4,5,12);cla;hold on;title('Go Con #2 Pro');axis([-.5 1 0 50])
        subplot(4,5,13);cla;hold on;title('Go Con #3 Pro');axis([-.5 1 0 50])
        subplot(4,5,14);cla;hold on;title('Go Con #4 Pro');axis([-.5 1 0 50])
        subplot(4,5,15);cla;hold on;title('NoGo Con #5 Pro');axis([-.5 1 0 50])
        subplot(4,5,16);cla;hold on;title('Go Con #1 Ret');axis([-.5 1 0 50])
        subplot(4,5,17);cla;hold on;title('Go Con #2 Ret');axis([-.5 1 0 50])
        subplot(4,5,18);cla;hold on;title('Go Con #3 Ret');axis([-.5 1 0 50])
        subplot(4,5,19);cla;hold on;title('Go Con #4 Ret');axis([-.5 1 0 50])
        subplot(4,5,20);cla;hold on;title('NoGo Con #5 Ret');axis([-.5 1 0 50])
        
        subplot(4,5,5);cla;axis off;
        text(0,.9, ['\fontsize{10}' 'Session : ' T.sessionName]);
        text(0,.7, ['\fontsize{10}' 'Shank : ' num2str(T.shankNum(cNum))]) ;
        text(0,.5, ['\fontsize{10}' 'Cluster : ' num2str(T.cellNum(cNum)) ' / (' num2str(cNum) ')']) ;
        text(0,.3, ['\fontsize{10}' 'Depth : ' num2str(T.depth(cNum)) ' (um)']) ;
        text(0,.1, ['\fontsize{10}' 'Dist : ' num2str(T.recordingLocation(cNum,3)) ' (mm)']) ;
        
        
        lnum=zeros(4,5);
        useFlag = find(cellfun(@(x)x.shanksTrial.clustData{cNum}.useFlag,T.trials));
        
        subplot(4,5,3);   % Hit Trials
        for i = intersect(useFlag,find(T.hitTrialInds));
            if ~isempty(bbt{i});
                plot(repmat(bbt{i}',2,1),  repmat([lnum(1,3); lnum(1,3)+1],1,length(bbt{i})),'c')
                

            end
            if ~isempty(st{i});
                
                plot(repmat(st{i}',2,1), repmat([lnum(1,3); lnum(1,3)+1],1,length(st{i})),'k')
            end
            
            lnum(1,3)=lnum(1,3)+1;
            
            
        end
        
        subplot(4,5,4);   % Miss Trials
        for i = intersect(useFlag,find(T.missTrialInds));
            if ~isempty(bbt{i});
                plot(repmat(bbt{i}',2,1), repmat([lnum(1,4); lnum(1,4)+1],1,length(bbt{i})),'c')
            end
            if ~isempty(st{i});
                plot(repmat(st{i}',2,1), repmat([lnum(1,4); lnum(1,4)+1],1,length(st{i})),'k')
            end
            
            lnum(1,4)=lnum(1,4)+1;
            
            
        end
        subplot(4,5,8);   % CR Trials
        for i = intersect(useFlag,find(T.correctRejectionTrialInds));
            if ~isempty(bbt{i});
                plot(repmat(bbt{i}',2,1), repmat([lnum(2,3); lnum(2,3)+1],1,length(bbt{i})),'c')
            end
            if ~isempty(st{i});
                
                plot(repmat(st{i}',2,1), repmat([lnum(2,3); lnum(2,3)+1],1,length(st{i})),'k')
            end
            
            lnum(2,3)=lnum(2,3)+1;
            
        end
        
        subplot(4,5,9);   % FA Trials
        for i = intersect(useFlag,find(T.falseAlarmTrialInds));
            if ~isempty(bbt{i});
                plot(repmat(bbt{i}',2,1), repmat([lnum(2,4); lnum(2,4)+1],1,length(bbt{i})),'c')
            end
            if ~isempty(st{i});
                
                plot(repmat(st{i}',2,1), repmat([lnum(2,4); lnum(2,4)+1],1,length(st{i})),'k')
            end
            lnum(2,4)=lnum(2,4)+1;
            
        end
        
        
        
        for i = intersect(useFlag,whiskerTIN);
            subplot(4,5,[1 2 6 7]);   % All Trials
            if ~isempty(bbt{i});
                plot(repmat(bbt{i}',2,1), repmat([i; i+1],1,length(bbt{i})),'c')
            end
            if ~isempty(st{i});
                
                plot(repmat(st{i}',2,1), repmat([i; i+1],1,length(st{i})),'k')
            end
            
            
            
            
            
            
            
            if isempty(contacts{i}.segmentInds{1})
                subplot(4,5,10); hold on;                                % No Contact trials
                if ~isempty(bbt{i});
                    plot(repmat(bbt{i}',2,1), repmat([lnum(2,5); lnum(2,5)+1],1,length(bbt{i})),'c')
                end
                if ~isempty(st{i});
                    
                    plot(repmat(st{i}',2,1), repmat([lnum(2,5); lnum(2,5)+1],1,length(st{i})),'k')
                end
                
                lnum(2,5)=lnum(2,5)+1;
                
                
                
            elseif  contacts{i}.trialContactType == 1 | contacts{i}.trialContactType == 3;
                
                subplot(4,5,10+contacts{i}.barPosType);hold on
                if ~isempty(bbt{i});
                    plot(repmat(bbt{i}'-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(1,1)),2,1),...
                        repmat([lnum(3,contacts{i}.barPosType); lnum(3,contacts{i}.barPosType)+1],1,length(bbt{i})),'c')
                end
                if ~isempty(st{i});
                    
                    plot(repmat(st{i}'-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(1,1)),2,1),...
                        repmat([lnum(3,contacts{i}.barPosType); lnum(3,contacts{i}.barPosType)+1],1,length(st{i})),'k' )
                end
                
                lnum(3,contacts{i}.barPosType) = lnum(3,contacts{i}.barPosType)+1;
                
                
            elseif  contacts{i}.trialContactType == 2 | contacts{i}.trialContactType == 4;
                subplot(4,5,15+contacts{i}.barPosType);hold on
                if ~isempty(bbt{i});
                    plot(repmat(bbt{i}'-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(1,1)),2,1),...
                        repmat([lnum(4,contacts{i}.barPosType); lnum(4,contacts{i}.barPosType)+1],1,length(bbt{i})),'c')
                end
                if ~isempty(st{i});
                    
                    plot(repmat(st{i}'-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(1,1)),2,1),...
                        repmat([lnum(4,contacts{i}.barPosType); lnum(4,contacts{i}.barPosType)+1],1,length(st{i})),'k' )
                end
                
                lnum(4,contacts{i}.barPosType) = lnum(4,contacts{i}.barPosType)+1;
            end
            
        end
        
        
        set(gcf,'Position',[100 100 1100 850],'PaperOrientation','portrait','PaperPosition',[0 0 11 8.5], 'PaperSize', [11 8.5])
        
        
        
        print('-depsc', ['/Lab/Silicon/Rasters/Raster_' T.sessionName '_Clust' num2str(T.shankNum(cNum)) '_' num2str(T.cellNum(cNum)) '_S'...
            num2str(Sind(cNum)) '_Depth' num2str(T.depth(cNum))])
        
        
        
    end
    
end


%
%             for j = 1:5
%
%                 subplot(4,5,[10+j]);
%
%
%
%                  plot(repmat(st{i}-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)),1,2),...
%                           [lnum(contacts{i}.barPosType,j) lnum(contacts{i}.barPosType,j)+1],'k' )
%                 %             lnum(contacts{i}.barPosType,j)=lnum(contacts{i}.barPosType,j)+1
%                 %
%                 %
%                 %
%                 %
%                 %
%                 %
%                 %             S.baselineSR{Sind(cNum)} = baselineSR(cNum);
%                 %
%                 %
%                 %
%                 %             display(['Finished processing cell number ' num2str(Sind(cNum))])
%             end
%         end
%     end
% end
