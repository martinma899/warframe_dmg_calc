function [enemy_arr,comment_arr,tarr] = sim_combat_2(wp,enemy,dmghtm)
% input 1: wp, a weapon struct according to the convention of this project.
% The weapon should be fully modded.
% input 2: enemy, an enemy struct according to the convention of this
% project. The enemy should already be leveled properly. 
% output 1: out_struct, a struct of enemies at each time snapshot
% field 1: t, the time stamps. 
% field 2: enemy, a struct array of the enemy at every time stamp. 
% field 3: event, a string cell array describing what is happening at each
% time stamp. 

% emergency: in the mod weapon function, add toxin, electricity, heat,
% slash multipliers for status dot application calculation. 

% notes to self: 
% damage object arrays separated by elemental types in main schedules 
% 1st index direction is always shot by shot direction
% 2nd index direction is always damage type direction

% initialize outputs
enemy_arr = enemy;
tarr = 0;
comment_arr = {'initial enemy'};

% get weapon fiel ds
wpfields = fields(wp);
% get the index array that tells which fields are damage type arrays
dmg_type_ind = get_dmg_type_ind(wpfields);



end