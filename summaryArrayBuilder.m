S=struct;
S.T=T;
S.params=params;
S.C=C;
S.contacts=contacts;
S.STA=STA;
save([S.T.mouseName '-' S.T.cellNum '-summary' '.mat'], 'S')