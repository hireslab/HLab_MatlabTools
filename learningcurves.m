for i=5:56

fn = strcat('/Users/sahires/Lab/Whisker Project/Mouse/JF35892/Behavior/',a(i).name);
b = Solo.BehavTrialArray(fn, a(i).name(21:34)); b.trim = [1 1];
d{i-4}=b.trialCorrects;

end

figure;hold on
t=1

for i=1:length(d)
    t=(1:length(d{i}))+t(end)+100;
    tmp=smooth(d{i},50);
    tmp([1:25 length(tmp)-25:length(tmp)])=NaN
    plot(t,tmp,'Color',[mod(i,5)/5 mod(i,4)/4 mod(i,3)/3])
end
ylim([0.4 1.0])