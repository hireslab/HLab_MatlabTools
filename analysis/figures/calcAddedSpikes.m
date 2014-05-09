for i = S.touchcells
 S.PCTH.FirstCon.spikesAdded{i} = 36*(mean(S.PCTH.FirstCon.allHist{i}(55:90))-mean(S.PCTH.FirstCon.allHist{i}(1:50)))/1000
 S.PCTH.Con210.spikesAdded{i} = 36*(mean(S.PCTH.Con210.allHist{i}(55:90))-mean(S.PCTH.Con210.allHist{i}(1:50)))/1000

end

for i = SU.touchCells
 SU.PCTH.FirstCon.spikesAdded{i} = 36*(mean(SU.PCTH.FirstCon.allHist{i}(55:90))-mean(SU.PCTH.FirstCon.allHist{i}(1:50)))/1000
 SU.PCTH.Con210.spikesAdded{i} = 36*(mean(SU.PCTH.Con210.allHist{i}(55:90))-mean(SU.PCTH.Con210.allHist{i}(1:50)))/1000
end

mean([SU.PCTH.FirstCon.spikesAdded{SU.touchCells} S.PCTH.FirstCon.spikesAdded{S.touchcells} ])
std([SU.PCTH.FirstCon.spikesAdded{SU.touchCells} S.PCTH.FirstCon.spikesAdded{S.touchcells} ])

mean([SU.PCTH.Con210.spikesAdded{SU.touchCells} S.PCTH.Con210.spikesAdded{S.touchcells} ])
std([SU.PCTH.Con210.spikesAdded{SU.touchCells} S.PCTH.Con210.spikesAdded{S.touchcells} ])

adaptationRatio = [SU.PCTH.Con210.spikesAdded{SU.touchCells} S.PCTH.Con210.spikesAdded{S.touchcells} ]./ [SU.PCTH.FirstCon.spikesAdded{SU.touchCells} S.PCTH.FirstCon.spikesAdded{S.touchcells} ]