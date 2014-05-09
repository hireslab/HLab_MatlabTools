for i = 1:52
    [CA, T, DA, contacts, params] = loadSUData(i, SU)
    for j = find(cellfun(@(x)~isempty(x),(DA.contactTimesInSamplingPeriod)));
    samplePeriodContactM0{i}{j} = contacts{j}.peakM0adj{1}(1:min(length(contacts{j}.peakM0adj{1}),length(DA.contactTimesInSamplingPeriod{j})));
    samplePeriodContactFax{i}{j} = contacts{j}.peakFaxialAdj{1}(1:min(length(contacts{j}.peakFaxialAdj{1}), length(DA.contactTimesInSamplingPeriod{j})));

    end
end

for i = 1:52
firstConM0{i} = cellfun(@(x)x(1),samplePeriodContactM0{i}(~cellfun(@isempty,samplePeriodContactM0{i})))
nextConM0{i} = cellfun(@(x)x(2:end),samplePeriodContactM0{i}(cellfun(@numel,samplePeriodContactM0{i})>1),'UniformOutput',0)
end

for i = 1:52
firstConFax{i} = cellfun(@(x)x(1),samplePeriodContactFax{i}(~cellfun(@isempty,samplePeriodContactFax{i})))
nextConFax{i} = cellfun(@(x)x(2:end),samplePeriodContactFax{i}(cellfun(@numel,samplePeriodContactFax{i})>1),'UniformOutput',0)
end


%%
 tmp = [firstConM0{:}];
tmp = tmp(abs(tmp)<3e-3);
meanM0FirstCon = nanmean(abs(tmp))
stdM0FirstCon = nanstd(abs(tmp))

 tmp2 = [nextConM0{:}];
 tmp2 = [tmp2{:}];
 tmp2 = tmp2(abs(tmp2)<3e-3);
meanM0NextCon = nanmean(abs(tmp2))
stdM0NextCon = nanstd(abs(tmp2))

 tmp3 = [firstConFax{:}];
tmp3 = tmp3(abs(tmp3)<1e-3);
meanFaxFirstCon = nanmean(abs(tmp3))
stdFaxFirstCon = nanstd(abs(tmp3))

 tmp4 = [nextConFax{:}];
 tmp4 = [tmp4{:}];
 tmp4 = tmp4(abs(tmp4)<1e-3);
meanFaxNextCon = nanmean(abs(tmp4))
stdFaxNextCon = nanstd(abs(tmp4))
 