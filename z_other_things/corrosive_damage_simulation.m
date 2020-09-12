clear;close all
figure(1);hold on; figure(2);hold on;
% simulates firing an automatic non-reloading weapon at an armored target. 

% base weapon
wpb.CC = 0.2; % critical chance
wpb.CM = 2.0; % critical multiplier
wpb.ST = 0.1; % corrosive status chance
wpb.MS = 2.5; % multishot
wpb.FR = 20; % fire rate
wpb.d = 1000; % base damage

% base enemy
enb.lv = 8; % base level
enb.h = 300; % base health
enb.a = 500; % base armor
enb.ht = 'ferrite'; % base health type

% scaled enemy
en = enb;
en.lv = 110; % enemy level
en.h = enb.h*(1+(en.lv-enb.lv)^2*0.015);
en.a = enb.a*(1+(en.lv-enb.lv)^2*0.0075);

% per shot projectile count random variable
MS_r.x = [ceil(wpb.MS) floor(wpb.MS)];
MS_r.p = [wpb.MS-floor(wpb.MS) 1-wpb.MS+floor(wpb.MS)];

% per shot crit multi random variable
CM.x = [wpb.CM 1];
CM.p = [wpb.CC 1-wpb.CC];

% per shot corrosive status
CST.x = [1 0];
CST.p = [wpb.ST 1-wpb.ST];

kill_time = [];

for j = 1:1000

% scaled enemy
en = enb;
en.lv = 110; % enemy level
en.h = enb.h*(1+(en.lv-enb.lv)^2*0.015);
en.a = enb.a*(1+(en.lv-enb.lv)^2*0.0075);

time = 0; % initial time. time will be made into an array.
corrosiveProcs = 0; % initial number of corrosive procs
tps = 1/wpb.FR; % time per trigger pulled

while true
  if en.h(end) <= 0
    break;
  end
  MS = rollRandVariable(MS_r); % roll the number of projectiles for this pull of trigger
  thisShotCorrosiveProcs = 0; 
  thisShotDamage = 0;
  for i = 1:MS % roll crit and status for every projectile
    thisShotDamage = thisShotDamage+wpb.d*rollRandVariable(CM);
    thisShotCorrosiveProcs = thisShotCorrosiveProcs+rollRandVariable(CST);
  end
  % calculate damage and armor strip
  en.h = [en.h en.h(end)-thisShotDamage*(1-en.a(end)/(en.a(end)+300))];
  corrosiveProcs = [corrosiveProcs corrosiveProcs(end)+thisShotCorrosiveProcs];
  en.a = [en.a en.a(end)*0.75^thisShotCorrosiveProcs];
  if en.a(end)<=1
    en.a(end) = 0;
  end
  time = [time time(end)+tps];
end

figure(1)
plot(time,en.h,'r')
figure(2)
plot(time,en.a,'b')

kill_time = [kill_time time(end)];
end

