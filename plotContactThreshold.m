function plotContactThreshold(array, contacts, params)
whiskerTIN  = find(array.whiskerTrialInds);
hitTIN      = intersect(whiskerTIN,find(array.hitTrialInds))
CRTIN       = intersect(whiskerTIN,find(array.correctRejectionTrialInds))
edges       = -.2:.001:.5;
onTrim      = mean(cellfun(@(x)x,pinDescentOnsetTime(whiskerTIN))) + params.poleOffset;
offTrim     = min(cellfun(@(x)x,pinAscentOnsetTime(whiskerTIN)));

n   = zeros(length(CRTIN),length(edges));
n2  = zeros(length(CRTIN),length(edges));
    
hfig_contactThresh = figure(5)

for k=hitTIN
    y = distanceToPoleCenter{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    y2 =  kappa{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
       n(k,:) = histc(y,edges);
       n2(k,:) = histc(y-2*(abs(y2)-5*y2.^2),edges);
       
       
end 

subplot(2,1,1);cla;hold on
       plot(edges+.0005,mean(n))
       plot(edges+.0005,mean(n2),'r')
       
n   = zeros(length(CRTIN),length(edges));
n2  = zeros(length(CRTIN),length(edges));
for k=CRTIN
    y = distanceToPoleCenter{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    y2 =  kappa{k}(time{k} > onTrim & time{k} < pinAscentOnsetTime{k} + params.poleEndOffset);
    edges = -.2:.001:.5;
    edges2 = -.2:.001:.5;
       n(k,:) = histc(y,edges);
       n2(k,:) = histc(y-2*(abs(y2)-5*y2.^2),edges);
       
       
end 
       
subplot(2,1,2);cla;
hold on;
plot(edges+.0005,mean(n))
plot(edges2+.0005,mean(n2),'r')