figure
cla
hold on
plot(repmat([0 1],length(b.hitTrialNums),1)',[b.hitTrialNums', b.hitTrialNums']','b')
plot(repmat([1 2],length(b.correctRejectionTrialNums),1)',[b.correctRejectionTrialNums', b.correctRejectionTrialNums']','r')
plot(repmat([2 3],length(b.missTrialNums),1)',[b.missTrialNums', b.missTrialNums']','k')
plot(repmat([3 4],length(b.falseAlarmTrialNums),1)',[b.falseAlarmTrialNums', b.falseAlarmTrialNums']','g')
