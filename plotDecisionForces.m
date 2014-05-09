cellnames=fieldnames(U);
figure
edges=linspace(-4e-7,4e-7,51);
cellnums=[7]
for k=1%length(cellnames);
    goForces=[];
    nogoForces=[];

    % for k=cat(2,find(cellfun(@(x)x.trialContactType,contacts)==2),find(cellfun(@(x)x.trialContactType,contacts)==1))
    % 
    %     goForces=cat(2,goForces,contacts{k}.meanM0{1});   
    % end
    % 
    % for k=cat(2,find(cellfun(@(x)x.trialContactType,contacts)==4),find(cellfun(@(x)x.trialContactType,contacts)==3))
    % 
    %     nogoForces=cat(2,nogoForces,contacts{k}.meanM0{1});   
    % end
    goForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(cat(2,find(cellfun(@(x)x.trialContactType,U.(cellnames{cellnums(k)}).contacts)==2)...
        ,find(cellfun(@(x)x.trialContactType,U.(cellnames{cellnums(k)}).contacts)==1)),:);
    goForces=goForces(~isnan(goForces));
    nogoForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(cat(2,find(cellfun(@(x)x.trialContactType,U.(cellnames{cellnums(k)}).contacts)==3)...
        ,find(cellfun(@(x)x.trialContactType,U.(cellnames{cellnums(k)}).contacts)==4)),:);
    nogoForces=nogoForces(~isnan(goForces));

    hitForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(find(U.(cellnames{cellnums(k)}).info.hitTrialInds),:);
    hitForces=hitForces(abs(hitForces)<1e-6);
    missForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(find(U.(cellnames{cellnums(k)}).info.missTrialInds),:);
    missForces=missForces(abs(missForces)<1e-6);
    falseAlarmForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(find(U.(cellnames{cellnums(k)}).info.falseAlarmTrialInds),:);
    falseAlarmForces=falseAlarmForces(abs(falseAlarmForces)<1e-6);
    correctRejectionForces=U.(cellnames{cellnums(k)}).C.decision.meanM0(find(U.(cellnames{cellnums(k)}).info.correctRejectionTrialInds),:);
    correctRejectionForces=correctRejectionForces(abs(correctRejectionForces)<1e-6);

        %goForces=goForces(~isnan(goForces))
   
    
    %hist(goForces(abs(goForces)<5e-7),100)
    hold on
    %hist(nogoForces(abs(nogoForces)<5e-7),100)

    % Normalized
    [n,bin]=histc(correctRejectionForces,edges);
    normmax=max(n);

    [n,bin]=histc(hitForces,edges);
    plot(edges,n,'b','LineWidth',0.5)
    normmax=max([normmax max(n)]);
 
    [n,bin]=histc(correctRejectionForces,edges);
    plot(edges,n./max(n).*normmax,'r','LineWidth',0.5)

    
% Un Normalized
    [n,bin]=histc(hitForces,edges);
    plot(edges,n,'b','LineWidth',3)
    plot(mean(hitForces(hitForces<0)),normmax*1.2,'bs','MarkerSize',5);
    plot([mean(hitForces(hitForces<0))-std(hitForces(hitForces<0)) mean(hitForces(hitForces<0))+std(hitForces(hitForces<0)) ],[normmax*1.2 normmax*1.2],'b-');

    
    [n,bin]=histc(correctRejectionForces,edges);
    plot(edges,n,'r','LineWidth',3)
    plot(mean(correctRejectionForces(correctRejectionForces<0)),normmax*1.1,'rs','MarkerSize',5);
    plot([mean(correctRejectionForces(correctRejectionForces<0))-std(correctRejectionForces(correctRejectionForces<0)) mean(correctRejectionForces(correctRejectionForces<0))+std(correctRejectionForces(correctRejectionForces<0)) ],[normmax*1.1 normmax*1.1],'r-');

   
    plot([0 0],[0 100],'k:')
  %  plot(mean(nogoForces(nogoForces<0)),10,'or')
   % plot(mean(goForces(goForces<0)),10,'ow')
   %set(gca,'XTickLabel',[])
   ylim([0 normmax*1.25])
   xlim([-2e-7, 2e-7])
   xlabel('Mean Contact Force (N*m)')
   ylabel('# of Contacts')
end


for k=1;
      hitForces=U.(cellnames{k}).C.decision.meanM0(find(U.(cellnames{k}).info.hitTrialInds),:);
        hitForcesMean(k,1)=nanmean(hitForces(hitForces<0));
        hitForcesMean(k,2)=nanmean(hitForces(hitForces>0));
        hitForcesMean(k,3)=nanstd(hitForces(hitForces<0));
        hitForcesMean(k,4)=nanstd(hitForces(hitForces>0));
        
        correctRejectionForces=U.(cellnames{k}).C.decision.meanM0(find(U.(cellnames{k}).info.correctRejectionTrialInds),:);
        correctRejectionForcesMean(k,1)=nanmean(correctRejectionForces(hitForces<0));
        correctRejectionForcesMean(k,2)=nanmean(correctRejectionForces(hitForces>0));
        correctRejectionForcesMean(k,3)=nanstd(correctRejectionForces(hitForces<0));
        correctRejectionForcesMean(k,4)=nanstd(correctRejectionForces(hitForces>0));
end
