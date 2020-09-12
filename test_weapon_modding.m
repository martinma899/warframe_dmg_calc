%% house keeping
clear;init_seq;

%% user inputs
weapon_name = 'Sonicor'; % weapon name, same as weapon folder name
mod_input_file_name = 'mod_selection_2.txt'; % mod selection input file name
output_file_name = 'output_5.txt'; % write build outputs to which file
enemy_name = 'heavy_gunner'; % enemy name, same as enemy file name
% sort_criteria = 'average'; % sort by average or burst dps
% dmg_threshold = 0.7; % output builds that are within 70% of top average dps

%% load mods and base weapon
% if the output file exists, asks if intend to overwrite it
query_file_overwrite; 
% load and process weapon file
weapon_path = ['.\weapons\' weapon_name];
addpath(weapon_path); 
wpb = read_weapon_xlsx([weapon_name '.xlsx']);
fprintf('Weapon name: %s\n',weapon_name);
disp(wpb);
% load mods and display them on screen
mod_input_file_name = [weapon_path '\' mod_input_file_name];
[mods,mods_ind,comments] = read_mod_selection(mod_input_file_name);
print_mods(mods,mods_ind,comments,1)


%% mod weapon
[wpm_quantum,wpm] = mod_weapon(wpb,mods(mods_ind.mandatory));
disp(wpm)

%% clean up
wrap_up;
