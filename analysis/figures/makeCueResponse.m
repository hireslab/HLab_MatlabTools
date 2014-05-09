for i =1:53
    for j = 1:2
        SU.cueResponse.poleInBR{i,j} = mean(SU.poleInHist{i,j}(1:8));
        SU.cueResponse.poleInBRstd{i,j} = std(SU.poleInHist{i,j}(1:8));
        SU.cueResponse.poleInCRmean{i,j} = mean(SU.poleInHist{i,j}(10:17));
        SU.cueResponse.poleInCRstd{i,j} = std(SU.poleInHist{i,j}(10:17));
        SU.cueResponse.poleInCRpeak{i,j} = max(SU.poleInHist{i,j}(10:17));
        SU.cueResponse.poleOutBR{i,j} = mean(SU.poleOutHist{i,j}(1:8));
        SU.cueResponse.poleOutBRstd{i,j} = std(SU.poleOutHist{i,j}(1:8));
        SU.cueResponse.poleOutCRmean{i,j} = mean(SU.poleOutHist{i,j}(10:17));
        SU.cueResponse.poleOutCRstd{i,j} = std(SU.poleOutHist{i,j}(10:17));
        SU.cueResponse.poleOutCRpeak{i,j} = max(SU.poleOutHist{i,j}(10:17));

    end
end
