for i = 1 :148
m0mod(i,1)=log2(S.M0ConCurves{i}{2}(1)/nanmean(S.baselineSR{i}));
m0mod(i,2)=log2(S.M0ConCurves{i}{2}(7)/nanmean(S.baselineSR{i}));


end

mp = find(abs(m0mod(:,1))>1);
mr = find(abs(m0mod(:,2))>1);

numel(mp)
numel(mr)

numel(unique([mp;mr]))
for i=1:5
ar(:,i) = cellfun(@(x)x(i,1),S.adaptationSR)
end

arm=nanmean(ar(:,2:5),2)
ari=find(arm<.5)

arn=intersect(ari,unique([mp;mr]))