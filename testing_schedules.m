clc;clear;
init_seq;

weapon = read_weapon_xlsx('lenz');

weapon.MS = 2.5;

firing_schedule = create_firing_schedule(weapon,'magazine',3);
multishot_schedule = create_multishot_schedule(weapon, firing_schedule);