d=dir('*_Cluster*');
for i=1:length(d)
    load(d(i).name);
    S.filename{i} = d(i).name
    S.anm{i} = d(i).name(1:9);
    S.session{i} = d(i).name(11:16);
    S.shank{i} = str2num(d(i).name(23));
    S.clust{i} = str2num(d(i).name(32));
    
    tmp=[]; 

    for j=1:8
        
        tmp(:,:,j) = sortrows(clust.waves(:,:,j),21);
    end
    
    size(tmp,1)
    a=(squeeze(mean(tmp(round(size(tmp,1)/10):round(size(tmp,1)/2),:,:))));

    amax = find(abs(a(21,:)) == max(abs(a(21,:))));

    norma = (a(:,amax)-mean(a(1:10,amax)))./ (a(21,amax)-mean(a(1:10,amax)))-.5;

    upinds   = [find(sign(norma)==1,1,'first')-1 find(sign(norma)==1,1,'first')];
    downinds = [find(sign(norma)==1,1,'last') find(sign(norma)==1,1,'last')+1];

    swidth = (downinds(1)-upinds(2) +...
    norma(upinds(2))   / (norma(upinds(2))   - norma(upinds(1))) + ...
    norma(downinds(2)) / (norma(downinds(2)) - norma(downinds(1)))) / 19530 * 1000;

    
    S.padmax{i} = amax;
    S.clustwidth{i} = swidth;
end

figure(9)

hist(cellfun(@(x)x,S.clustwidth),30)
xlabel('Spike Width (ms)')
ylabel('Count')


depthCorr = [162 122 82 42 22 62 102 142]
