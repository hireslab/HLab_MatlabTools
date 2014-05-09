figure(2);clf
for i = 1:148
    subplot(10,15,i)
    if sum(S.PCTH.z{i}(57:72)>3.5)>1
        
bar(S.PCTH.allHist{i},'r','edgecolor','r')
    else
 bar(S.PCTH.allHist{i},'k')
        
    end
    set(gca,'xlim',[0 100])
end

figure(3);clf
for i = 1:52
    subplot(6,9,i)
    if sum(SU.PCTH.FirstCon.z{i}(57:72)>5)>0
        
        
bar(SU.PCTH.FirstCon.allHist{i},'r','edgecolor','r')
    else
 bar(SU.PCTH.FirstCon.allHist{i},'k')
        
    end
    set(gca,'xlim',[0 100])
end

SU.touchCells = [1:11 14 16 18 20 24 25 27 28 32 34 36 37 41 46 48 50 51]; 
S.touchCells = 

% SUtouchLat = cellfun(@(x)find(x(51:72)== max(x(51:72)),1),SU.PCTH.FirstCon.allHist( SU.touchCells(find([SU.distance{SU.touchCells}]<.25))),'UniformOutput',0)
SUtouchLatNear = cellfun(@(x)find(x(51:72)>3.5,1),SU.PCTH.FirstCon.z( SU.touchCells(find([SU.distance{SU.touchCells}]<.25))))
SUtouchLatFar = cellfun(@(x)find(x(51:72)>3.5,1),SU.PCTH.FirstCon.z( SU.touchCells(find([SU.distance{SU.touchCells}]>.25))))

StouchLatNear = cellfun(@(x)find(x(51:72)>3.5,1),  S.PCTH.z(S.touchcells(find([S.dist{S.touchcells}]<.25))))
StouchLatFar  = cellfun(@(x)find(x(51:72)>3.5,1),  S.PCTH.z(S.touchcells(find([S.dist{S.touchcells}]>.25))))

StouchLat = cellfun(@(x)find(x(51:72)>3.5,1,'first'),S.PCTH.z(S.touchcells))
StouchLat = StouchLat(StouchLat>5)


%%
touchModS  = cellfun(@(x)max(x(55:72)),S.PCTH.Con15.allHist(S.touchcells))./[S.whiskSR{S.touchcells}]
touchModSU = cellfun(@(x)max(x(55:72)),SU.PCTH.Con15.allHist(SU.touchCells))./[SU.whiskSR{SU.touchCells}]

touchModFirstS  = cellfun(@(x)max(x(55:72)),S.PCTH.FirstCon.allHist(S.touchcells))./[S.whiskSR{S.touchcells}]
touchModFirstSU = cellfun(@(x)max(x(55:72)),SU.PCTH.FirstCon.allHist(SU.touchCells))./[SU.whiskSR{SU.touchCells}]

find([touchModFirstS touchModFirstSU] >20)
median([touchModFirstS touchModFirstSU])