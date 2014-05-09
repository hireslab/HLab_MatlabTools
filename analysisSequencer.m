
params.displayType='all'

filterfamily(T,contacts,params);
buildfits;
U.AH24.fits.all=family;

params.displayType='arbitrary'
params.arbTimes={'0';'.75'}
filterfamily(T,contacts,params);
buildfits;
U.AH24.fits.prePole=family;


params.displayType='poleToDecision'
filterfamily(T,contacts,params);
buildfits;
summarizeContacts(T,contacts,params);
U.AH24.C.decision=C;
U.AH24.fits.decision=family;

