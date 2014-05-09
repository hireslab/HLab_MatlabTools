% build Contact Direction Tuning Contacts Only



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
    
    Sind = find(cellfun(@(x)strncmpi(x, T.sessionName,16),S.filename))
    
    
    nClusts = 1:length(T.cellNum)
    
    [sortSR sortM0 binBounds] = M0VsSpikeRateConOnly(T, contacts);
    
    for cNum = nClusts
        
        M0ConCurves{cNum}{1} = cellfun(@mean,sortM0);
        M0ConCurves{cNum}{2} = cellfun(@mean,sortSR{cNum});
        M0ConCurves{cNum}{3} = binBounds;
        M0ConCurves{cNum}{4} = length(sortSR);

        MConMod={};
        
        [tmp1 tmp2] = max(M0ConCurves{cNum}{2}(1:ceil(numel(M0ConCurves{cNum}{1})/2)));
        MConMod{cNum}{1}(1,1:2) = [tmp1 tmp2];
        
        [tmp1 tmp2] = max(M0ConCurves{cNum}{2}(ceil(numel(M0ConCurves{cNum}{1})/2):end));
        MConMod{cNum}{1}(2,1:2) = [tmp1 tmp2+ceil(numel(M0ConCurves{cNum}{1})/2)-1];
        
        [tmp1 tmp2] = min(M0ConCurves{cNum}{2}(1:ceil(numel(M0ConCurves{cNum}{1})/2)));
        MConMod{cNum}{2}(1,1:2) = [tmp1 tmp2];
        
        [tmp1 tmp2] =  min(M0ConCurves{cNum}{2}(ceil(numel(M0ConCurves{cNum}{1})/2):end));
        MConMod{cNum}{2}(2,1:2) = [tmp1 tmp2+ceil(numel(M0ConCurves{cNum}{1})/2)-1];
        
        MConMod{cNum}{3}(1,1:2) = M0ConCurves{cNum}{2}(find(abs(M0ConCurves{cNum}{1})==min(abs(M0ConCurves{cNum}{1}))));
        
        
        
        
        
        
        
        
        S.M0ConCurves{Sind(cNum)} = M0ConCurves{cNum};
        S.M0ConMod{Sind(cNum)} = MConMod{cNum};
        
        
        display(['Finished processing cell number ' num2str(Sind(cNum))])
    end
    
end

%%
colors = prism(length(S.M0ConCurves));
figure(12);clf; hold on

for i =1:length(S.M0ConCurves)
    subplot(1,3,1)
    hold on
    plot(repmat(S.depth{i},2,1),log2([S.M0ConMod{i}{1}(1) S.M0ConMod{i}{2}(1)]),'.-','Color',colors(i,:) )
    plot(repmat(S.depth{i},2,1),log2(S.M0ConMod{i}{3}(1)),'ok','MarkerSize',5,'MarkerFaceColor',colors(i,:) )
    subplot(1,3,2)
    hold on
    plot(repmat(S.depth{i},2,1),log2([S.M0ConMod{i}{1}(2) S.M0ConMod{i}{2}(2)]),'.-','Color',colors(i,:) )
    plot(repmat(S.depth{i},2,1),log2(S.M0ConMod{i}{3}(2)),'ok','MarkerSize',5,'MarkerFaceColor',colors(i,:) )
    
    subplot(1,3,3)
    hold on
    plot(repmat(S.depth{i},2,1),([S.M0ConMod{i}{1}(1)- S.M0ConMod{i}{1}(2,1)] / [S.M0ConMod{i}{1}(1) + S.M0ConMod{i}{1}(2,1)]),'ok-','MarkerSize',5,'MarkerFaceColor',colors(i,:))
end
subplot(1,3,1)
ylabel({'log2(Range of Spike Rate)'})
axis([0 700 -6 6])
title('Protraction Contacts')
grid on
subplot(1,3,2)

axis([0 700 -6 6])
xlabel('Depth from pia (um)')
title('Retraction Contacts')
grid on
subplot(1,3,3)
title('Contact Directional Selectivity')
ylabel('(Pro-Ret) / (Pro+Ret)')

axis([0 700 -1 1])

grid on

set(gcf,'Position',[100 100 1500 400],'PaperOrientation','portrait','PaperPosition',[0 0 18 6], 'PaperSize', [6 18])



print('-depsc', 'Q:\Silicon\Figures\M0Tuning')
