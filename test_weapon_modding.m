%% house keeping
clear;init_seq;

%% read in mods
mod_names = {'serration','split_chamber','infected_clip','speed_trigger','primed_cryo_rounds'};
mods = read_mod_text_database(mod_names,'rifle_mods');

[mod, elemental_names, elemental_modifiers]...
    = combine_mods(mods)

%% read in weapon
lenz = read_weapon_xlsx('lenz')

%% mod weapon
[lenz] = mod_weapon3(lenz,mod,elemental_names, elemental_modifiers,false)

%% extract an enemy
enemy = read_enemy_xlsx('comba','fog','')
figure(1); hold on ;

semilogx(i,enemy_out.armor,'y.');


%% clean up
wrap_up;
