 d=dir('*.measurements')
 bytes = [d.bytes];
 figure(1);clf
 killIdx = find(bytes<mean(bytes)-3*std(bytes));
 hist(bytes,50);
 hold on
 plot([mean(bytes)-3.5*std(bytes)]*[1 1],[0 30],'r:')
 for i = killIdx
      endIdx = regexp(d(i).name,'\.measurements')-1;
      namePrefix = d(i).name(1:endIdx);
     delete([namePrefix '.*']);
 end
 
 
 