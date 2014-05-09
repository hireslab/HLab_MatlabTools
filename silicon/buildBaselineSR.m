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
    
    baselineSR=[];
    for cNum = nClusts
        useInd = find(cellfun(@(x)x.shanksTrial.clustData{1}.useFlag,T.trials));
        
        
        baselineSR(cNum) = nanmean(cellfun(@(x)sum(x.shanksTrial.clustData{cNum}.spikeTimes < -T.whiskerTrialTimeOffset*19530)/-T.whiskerTrialTimeOffset,T.trials(useInd)));

    
    
    
    
        S.baselineSR{Sind(cNum)} = baselineSR(cNum);
    
    
    
    display(['Finished processing cell number ' num2str(Sind(cNum))])
    end
end
