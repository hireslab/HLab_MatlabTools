hitcontactnumber=[]
FAcontactnumber=[]
CRcontactnumber=[]

for j=[1:6 8:15 17:20];
    hitcontactnumber=cat(1,hitcontactnumber,sum(isfinite(U.(names{j}).C.decision.time(U.(names{j}).info.hitTrialInds,:)),2));
    FAcontactnumber=cat(1,FAcontactnumber,sum(isfinite(U.(names{j}).C.decision.time(U.(names{j}).info.falseAlarmTrialInds,:)),2));
    CRcontactnumber=cat(1,CRcontactnumber,sum(isfinite(U.(names{j}).C.decision.time(U.(names{j}).info.correctRejectionTrialInds,:)),2));

end

