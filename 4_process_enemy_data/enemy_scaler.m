function [enemy_out] = enemy_scaler(base_enemy,level)
enemy_out = base_enemy;
enemy_out.level = level;
if base_enemy.shield>0
  enemy_out.shield = ...
    base_enemy.shield*(1+(level-base_enemy.level)^2*0.0075);
end
if base_enemy.armor>0
  enemy_out.armor = ...
    base_enemy.armor*(1+(level-base_enemy.level)^1.75*0.005);
end
if base_enemy.health>0
  enemy_out.health = ...
    base_enemy.health*(1+(level-base_enemy.level)^2*0.015);
end
end