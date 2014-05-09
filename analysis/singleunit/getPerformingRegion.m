for i = 1:52
    [CA, T, DA, contacts, params] = loadSUData(i, SU);
    performace{i}  = numel([DA.hitInd DA.CRInd])/numel([DA.hitInd DA.CRInd DA.missInd DA.FAInd])
end
