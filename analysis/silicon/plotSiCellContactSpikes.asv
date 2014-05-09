figure(10);cla; hold on
for i = [DA.hitInd]
%     plot(DA.contactTimesInSamplingPeriod{i},repmat(i,length(DA.contactTimesInSamplingPeriod{i})),'b.')
    try
    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'bx','markerSize',12)

    end
    plot(1000*DA.firstLick{i},i,'bo')
end
for i = [DA.FAInd]
%     plot(DA.contactTimesInSamplingPeriod{i},repmat(i,length(DA.contactTimesInSamplingPeriod{i})),'g.')
        plot(1000*DA.firstLick{i},i,'go')
    try
    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'gx','markerSize',12)
    end
end
for i = [DA.missInd DA.CRInd]
%     plot(DA.contactTimesInSamplingPeriod{i},repmat(i,length(DA.contactTimesInSamplingPeriod{i})),'r.')
try
    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'rx','markerSize',12)

    end
end
set(gca,'xlim',[0 2000])
%%
figure(11);cla; hold on
for i = [DA.hitInd]
    plot(DA.spikeTimesInSamplingPeriod{i},repmat(i,length(DA.spikeTimesInSamplingPeriod{i})),'b.')

    plot(1000*DA.firstLick{i},i,'bo')
end
for i = [DA.FAInd]
    plot(DA.spikeTimesInSamplingPeriod{i},repmat(i,length(DA.spikeTimesInSamplingPeriod{i})),'g.')
        plot(1000*DA.firstLick{i},i,'go')

end
for i = [DA.missInd DA.CRInd]
     plot(DA.spikeTimesInSamplingPeriod{i},repmat(i,length(DA.spikeTimesInSamplingPeriod{i})),'r.')

end
set(gca,'xlim',[0 2000])

%%
figure(11);cla; hold on
for i = [DA.hitInd]
    plot(DA.spikeTimesInWhiskSamplingPeriod{i},repmat(i,length(DA.spikeTimesInWhiskSamplingPeriod{i})),'b.')

    if ~isempty(DA.firstLick{i})
    plot(1000*DA.firstLick{i},i,'bo')
    end
    if ~isempty(DA.contactTimesInSamplingPeriod{i})
    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'bx','markerSize',10)

    end
end
for i = [DA.FAInd]
    plot(DA.spikeTimesInWhiskSamplingPeriod{i},repmat(i,length(DA.spikeTimesInWhiskSamplingPeriod{i})),'g.')
    
        if ~isempty(DA.firstLick{i})

    plot(1000*DA.firstLick{i},i,'go')
        end
            if ~isempty(DA.contactTimesInSamplingPeriod{i})

    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'gx','markerSize',10)

    end
end
for i = [DA.CRInd]
     plot(DA.spikeTimesInWhiskSamplingPeriod{i},repmat(i,length(DA.spikeTimesInWhiskSamplingPeriod{i})),'r.')
    if ~isempty(DA.firstLick{i})
    plot(1000*DA.firstLick{i},i,'bo')
    end
    if ~isempty(DA.contactTimesInSamplingPeriod{i})
    plot(DA.contactTimesInSamplingPeriod{i}(1),i,'rx','markerSize',10)

    end
end
set(gca,'xlim',[0 2000])