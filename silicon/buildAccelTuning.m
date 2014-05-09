% Accel selectivity


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

  [sortSR sortAcc binBounds] = accelVsSpikeRate(T, contacts);
  
for cNum = nClusts
    % Vmod is {cluster}(pro/base,ret/base, (pro-ret)/(pro+ret))
        
        Acurves{cNum}{1} = cellfun(@mean,sortAcc);
        Acurves{cNum}{2} = cellfun(@mean,sortSR{cNum});
        Acurves{cNum}{3} = binBounds;
        Acurves{cNum}{4} = length(sortSR);

        Abase = mean(sortSR{cNum}{ceil(numel(sortSR{cNum})/2)});
    Apro = mean(sortSR{cNum}{end});
    Aret = mean(sortSR{cNum}{1});
    
    Amod{cNum}(1) = log2(Apro/Abase);
    Amod{cNum}(2) = log2(Aret/Abase);
    Amod{cNum}(3) = (Apro-Aret)/(Apro+Aret);

    S.Amod{Sind(cNum)} = Amod{cNum};
         S.Acurves{Sind(cNum)} = Acurves{cNum};
        S.Amod{Sind(cNum)} = Amod{cNum};
    display(['Finished processing cell number ' num2str(Sind(cNum))])
end
    
end

%% Plotting
% figure(14);clf;
% 
% subplot(1,4,1)
% hold on
% dColor=jet(70)%double(uint8(10*log2(max(cellfun(@(x)nanmean(x),S.baselineSR))))+1));
% colormap(dColor(1:64,:));
% 
% for cNum = 1:148
%     plot(S.depth{cNum}, S.Vmod{cNum}(1),'ko','MarkerFaceColor',dColor(uint8(10*log2(nanmean(S.baselineSR{cNum})))+1,:))
% end
% ylabel({'Spike Rate Modulation';'log2(High Velocity rate / Low Velocity Rate)'})
% title('Protraction')
% grid on
% axis([0 700 -9 9])
% subplot(1,4,2)
% hold on
% for cNum = 1:148
%         plot(S.depth{cNum}, S.Vmod{cNum}(2),'ko','MarkerFaceColor',dColor(uint8(10*log2(nanmean(S.baselineSR{cNum})))+1,:))
% end
% axis([0 700 -9 9])
% xlabel('Depth from pia (um)')
% title('Retraction')
% grid on
% subplot(1,4,3)
% hold on
% 
% for cNum = 1:148
%         plot(S.depth{cNum}, S.Vmod{cNum}(3),'ko','MarkerFaceColor',dColor(uint8(10*log2(nanmean(S.baselineSR{cNum})))+1,:))
% end
% axis([0 700 -1.1 1.1])
% grid on
% ylabel('(Pro-Ret) / (Pro+Ret)')
% title('Directional Selectivity')
% 
% subplot(1,4,4)
% colorbar
% ylabel({'Baseline Spike Rate (spk/s)'})
% colorbar('YTick',[1 11 21 31 41 51 61],'YTickLabel',{'1','2','4','8','16','32','64'})
% set(gcf,'Position',[100 100 1500 400],'PaperOrientation','portrait','PaperPosition',[0 0 20 5], 'PaperSize', [5 20])
% 
% 
%   
% print('-depsc', 'Q:\Silicon\Figures\VelocityTuning') 