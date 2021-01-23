clc;clear;
init_seq;

weapon = read_weapon_xlsx('lenz');

weapon.MS=1.9;
weapon.CC = 2;weapon.CC2 = 2;weapon.CC3 = 2;
weapn.CM = 3.2;
weapon.SLASH_ON_CRIT = 0.3;
%weapon.ENHANCE_CRIT = 0.3;
weapon.SC = 4.2;

schedule = create_master_schedule(weapon,'round',20);
print_firing_schedule(schedule);
