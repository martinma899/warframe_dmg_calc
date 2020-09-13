function enemy_out = dealDamageToEnemy(enemy_in,damage,dmghtm)
% enemy_in: an enemy struct coming in
% damage: a damage object coming in
% damage object has the following fields: 
% damage.type is a cell array of all damage types
% damage.value is a numerical array of all the damage values
% damage.t is the time of that damage instance
% damage.flag is whether this damage instance has been executed or not

enemy_out = enemy_in;
dead = false;

% first, if the enemy has shields
% and the damage is not toxin or true
if enemy_out.shield>0 && ~strcmp(damage.type,'toxin') && ~strcmp(damage.type,'true')
  % compute modified shield damage
  SM = gethtm(damage.type,enemy_out.shield_type,dmghtm);
  shield_dmg = (1+SM)*damage.value;
  % if the shot is not capable of taking out all shields
  if shield_dmg <= enemy_out.shield
    % simply take out shield values and end program
    enemy_out.shield = enemy_out.shield-shield_dmg;
    return;
  else % if the shot is capable of taking out all shields
    % subtract the amount of damage that took off the shield from damage object
    damage.value = damage.value-enemy_out.shield/(1+SM);
    % take out all shields
    enemy_out.shield = 0;
  end
end

% continute to perform health/armor combo damage tick
% get health modifier
HM = gethtm(damage.type,enemy_out.health_type,dmghtm);
if enemy_out.armor > 0 && ~strcmp(damage.type,'true')% if enemy has armor and damage is not true damage
  % get armor modifier and total armor damage reduction modifier
  AM = gethtm(damage.type,enemy_out.armor_type,dmghtm);
  armor_modifier = 300/(300+enemy_out.armor*(1-AM))*(1+AM)*(1+HM);
  % deal damage
  armor_dmg = damage.value*armor_modifier;
  enemy_out.health = enemy_out.health-armor_dmg;
else % if enemy does not have armor or damage is true damage
  % deal damage
  health_dmg = damage.value*(1+HM);
  enemy_out.health = enemy_out.health-health_dmg;
end

% if enemy is dead, set health to 0 rather than negative

if enemy_out.health <= 0
  dead = true;
end

if dead
  enemy_out.health = 0;
end


end