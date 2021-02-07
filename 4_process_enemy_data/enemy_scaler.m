function [enemy_out] = enemy_scaler(base_enemy,level,SP)

% base_enemy is the base enemy object
% level is the level to scale the enemy to
% SP is whether the enemy is steel path or not

if level<base_enemy.level % if level is less than base level
    error('level is lower than base level')
end

enemy_out = base_enemy; % initialize enemy_out
enemy_out.level = level; % assign final enemy level


if base_enemy.shield>0 % if enemy has any shield
    f1 = 1+0.0075*(level-base_enemy.level)^2;
    f2 = 1+1.6*(level-base_enemy.level)^0.75;
    f3 = min(1,(max(level,70+base_enemy.level)-(70+base_enemy.level))/15);
    enemy_out.shield = ...
        base_enemy.shield*(1+(f1-1)*(1-f3)+(f2-1)*f3);
    if SP
        enemy_out.shield = enemy_out.shield*2.5;
    end
end

if base_enemy.armor>0
    f1 = 1+0.005*(level-base_enemy.level)^1.75;
    f2 = 1+0.4*(level-base_enemy.level)^0.75;
    f3 = min(1,(max(level,60+base_enemy.level)-(60+base_enemy.level))/20);
    enemy_out.armor = ...
        base_enemy.armor*(1+(f1-1)*(1-f3)+(f2-1)*f3);
    if SP
        enemy_out.armor = enemy_out.armor*2.5;
    end
end
if base_enemy.health>0
    f1 = 1+0.015*(level-base_enemy.level)^2;
    f2 = 1+10.7332*(level-base_enemy.level)^0.5;
    f3 = min(1,(max(level,70+base_enemy.level)-(70+base_enemy.level))/15);
    enemy_out.health = ...
        base_enemy.health*(1+(f1-1)*(1-f3)+(f2-1)*f3);
    if SP
        enemy_out.health = enemy_out.health*2.5;
    end
end
if base_enemy.affinity>0
    enemy_out.affinity = floor(base_enemy.affinity*(1+0.1425*level^0.5));
end
end