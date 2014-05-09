figure(5);clf;hold on


SUnums = find([SU.distance{:}] < .250)
Snums = find([S.dist{:}] < .250)
Snums = Snums(1:end-1)
for k=1:length(SUnums)
 subplot(7,12,k);hold on

bar(zedges+.001/2,SU.PCTH.Con15.allHist{SUnums(k)},'k','edgecolor','k')
set(gca,'Xlim',[-0.05 .05])
end

for k = 1:length(Snums)
     subplot(7,12,k+length(SUnums));hold on

bar(zedges+.001/2,S.PCTH.Con15.allHist{Snums(k)},'k','edgecolor','k')
set(gca,'Xlim',[-0.05 .05])
end
%%

figure(6);clf;hold on


SUnums = find([SU.distance{:}] < .250)
Snums = find([S.dist{:}] < .250)
Snums = Snums(1:end-1)
for k=1:length(SUnums)
 subplot(7,12,k);hold on

bar(zedges+.001/2,SU.PCTH.FirstCon.allHist{SUnums(k)},'k','edgecolor','k')
set(gca,'Xlim',[-0.05 .05])
end

for k = 1:length(Snums)
     subplot(7,12,k+length(SUnums));hold on

bar(zedges+.001/2,S.PCTH.FirstCon.allHist{Snums(k)},'k','edgecolor','k')
set(gca,'Xlim',[-0.05 .05])
end

%%
figure(7);clf;hold on


SUnums = find([SU.distance{:}] < .250)
Snums = find([S.dist{:}] < .250)
Snums = Snums(1:end-1)
for k=1:length(SUnums)
 subplot(7,12,k);hold on

bar(zedges+.001/2,SU.PCTH.FirstCon.allHist{SUnums(k)}-SU.PCTH.Con15.allHist{SUnums(k)},'b','edgecolor','b')
set(gca,'Xlim',[-0.05 .05])
end

for k = 1:length(Snums)
     subplot(7,12,k+length(SUnums));hold on

bar(zedges+.001/2,S.PCTH.FirstCon.allHist{Snums(k)}-S.PCTH.Con15.allHist{Snums(k)},'b','edgecolor','b')
set(gca,'Xlim',[-0.05 .05])
end

