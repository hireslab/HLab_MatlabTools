SU_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
SU_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')
SU_SDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\SweepArrays\')

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\')

for i=25:149%:length(SU.cellName);
    
    if ~strcmp( S.trialArrayName{i}(5:17), T.sessionName(4:16))
    display(['Loading '  S.trialArrayName{i}])
    load([Si_TDir S.trialArrayName{i}])
    
    end
    
     clustInd = find(T.cellNum == S.clust{i} & T.shankNum==S.shank{i})


tmp = T.get_all_interspike_intervals([],clustInd);
ISI = tmp(:,3);
nonburst = sum(ISI>=.01)
burst = diff([0; ISI<.01 ;0]);
startburst = find(burst ==1);
endburst = find(burst==-1);
%ISI = ISI(ISI>.002);
edges = [0:20]-.5;
isihist = histc(endburst-startburst,edges);
isihist(1) = nonburst;
S.ISI.isi{i} = ISI;
S.ISI.burst{i} = isihist;
S.ISI.edges{i} = edges;
i

end
