driftDirs ={'/Volumes/MONOLITH/Silicon/Mouse/ANM140536/110822/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM140536/110823/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM140536/110824/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM140536/110825/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM140536/110826/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144441/110809/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144441/110810/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144441/110815/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144441/110816/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144442/110810/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144442/110812/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144442/110813/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144442/110814/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110811/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110812/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110813/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110814/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110815/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110816/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144443/110818/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144444/110823/', ...
    '/Volumes/MONOLITH/Silicon/Mouse/ANM144444/110824/'}



    for i = 1:22
    d2{i} = measureDrift(driftDirs{i},[1 length(dir([driftDirs{i} '*DG*']))]);

    
    end
    
    
