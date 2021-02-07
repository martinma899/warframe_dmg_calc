%% house keeping
clear;init_seq;

%% read in enemy
enemy = read_enemy_xlsx('lancer','','');

%% construct damage object

damage.type = {'IMPACT' 'PUNCTURE' 'SLASH' 'MAGNETIC'};
damage.value = [103.5 103.5 207 750.375]*5.88;

damage_on_health_calc = [];
damage_on_shield_calc = [];

level = 5:5:120;

for i = level
[enemy2] = enemy_scaler(enemy,i,false);
[enemy_out,damage_out] = dealDamageToEnemy(enemy2,damage,false,false,dmghtm)

end