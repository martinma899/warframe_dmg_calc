% a function execution script intended to test multiple things. 

% completed: 

%% house keeping
clear;close all;init_seq;
%close all;
%% user inputs
weapon_name = 'Sonicor'; % weapon name, same as weapon folder name
mod_input_file_name = 'mod_selection_2.txt'; % mod selection input file name
enemy_name = 'heavy_gunner'; % enemy name, same as enemy file name

%% load and process weapon file
weapon_path = ['.\weapons\' weapon_name];
addpath(weapon_path); 
wpb = read_weapon_xlsx([weapon_name '.xlsx']);
fprintf('Weapon name: %s\n',weapon_name);
disp(wpb);

%% load mods and display them on screen
[mods,mods_ind,comments] = read_mod_selection(mod_input_file_name);
print_mods(mods,mods_ind,comments,1)

%% load enemy file
enemy = read_enemy_file([enemy_name '.xlsx'],'default');
enemy = enemy{1};
enemy = enemy_scaler(enemy,160)

%% compute all weapon moddings
[wpm_quantum,wpm] = mod_weapon(wpb,mods(mods_ind.mandatory));
% disp(wpm);
% [avgdps, burstdps, htm, htmeff] = wp_dps_calc(wpm,enemy,dmghtm)

%% test dealDamageToEnemy

% damage.type = 'toxin';
% damage.value = 100;
% enemy_out = dealDamageToEnemy(enemy,damage,dmghtm)

%% test sim_combat

hold on
for i = 1:100
[enemy_arr,tarr] = sim_combat(wpm_quantum,enemy,dmghtm);
% plot(tarr,[enemy_arr.shield]+enemy.health,'b-')
plot(tarr,[enemy_arr.health],'b.-')
plot(tarr,[enemy_arr.armor],'y-')
fprintf('trial %d\n',i)
end


%% clean up

wrap_up;

