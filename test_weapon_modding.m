%% house keeping
clear;init_seq;

%% read in mods
%'0/1/23/1/1/578/0/0/0'
%'2/0/3/0/0/0/0/1/13'
mods_array = get_mods_array_from_build_v3...
  ('0/1/23/1/1/578/0/0/0','/','rifle','mod_database_v3.xlsx');

[mod, elemental_names, elemental_modifiers] = combine_mods(mods_array)

%% read in weapon
wp = read_weapon_xlsx_v2('ogris','kuva max toxin','','guns')

%% mod weapon
wpm = mod_weapon3(wp,mod,elemental_names, elemental_modifiers,false)

%% extract an enemy
% enemy = read_enemy_xlsx('comba','fog','')



%% clean up
% wrap_up;
