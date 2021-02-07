function [enemy,damage_out] = dealDamageToEnemy(enemy_in,damage,headshot,shieldgate,dmghtm)
% enemy_in: an enemy struct coming in
% damage: a damage object coming in
% damage object has the following fields:
% damage.type is a cell array of all damage types
% damage.value is a numerical array of all the damage values
% ? damage.t is the time of that damage instance
% ? damage.flag is whether this damage instance has been executed or not
% headshot: boolean variable of whether the hit is headshot or not
% shieldgate: whether the enemy's shieldgate is active or not
% dmghtm: damage health type modifier array

% there cannot be duplicate damage types

% enemy: enemy after taking damage
% damage_out: struct recording total damage dealt to the shield and health
% of that enemy for analysis purposes
% damage_out.shield: damage dealt to the shield of that enemy
% damage_out.health: damage dealt to the health of that enemy

% initialize enemy
enemy = enemy_in;

% initialize damage_out struct
damage_out.shield = 0;
damage_out.shield_display = 0;
damage_out.health = 0;

% if headshot, then multiply damage
if headshot
  damage.value = damage.value*enemy.headshot_multiplier;
end

% initialize damage bleed through shield flag
use_damage_to_health_struct = false;

% initialize enemy dead bool flag
dead = false;

% number of elements in the damage object
n = numel(damage.type);

% 2. index toxin damage if there are any
toxinind = strcmpi(damage.type,'toxin');
istoxin = any(toxinind); % if there's any toxin

% 3. index true damage if there are any
trueind = strcmpi(damage.type,'true');
istrue = any(trueind); % if there's any toxin

% deal damage to shield or shieldgate

% first, if the enemy has shields or shield gate is active
if enemy.shield>0||shieldgate
  
  % get shield HTM array (SM)
  SM = zeros(1,n);
  for i = 1:n
    SM(i)=1+gethtm(damage.type{i},enemy.shield_type,dmghtm);
  end
  
  % compute damage to be dealt to shield
  shield_dmg = sum((SM(~toxinind)).*damage.value(~toxinind));
  
  % if the shot is not capable of taking out all shields
  if shield_dmg <= enemy.shield
    
    % take out shield values 
    enemy.shield = enemy.shield-shield_dmg;
    
    % record damage_out for display purposes
    damage_out.shield = shield_dmg;
    damage_out.shield_display = shield_dmg;
    
    % if there's no toxin damage
    if ~istoxin
      return; % end program because nothing else needs to be done
    else % otherwise construct damage to health struct to apply toxin damage in the next step
      damage_to_health.type = {'toxin'};
      damage_to_health.value = damage.value(toxinind);
      use_damage_to_health_struct = true;
    end 
  
  else 
    % set use damage to health struct
    use_damage_to_health_struct = true;
    
    % if the shot is capable of taking out all shields, 
    % we do either regular shield damage formula or shield gate formula
    % we take out all the shield
    % and compute the remaining damage object 
    
    % 1.compute the damage dealt to shield but without HTM
    % 1.1 compute equivalent total shield type modifier
    SMeq = sum(damage.value(~toxinind).*(SM(~toxinind)))/sum(damage.value(~toxinind));
    % 1.2 divide total shield damage dealt (enemy shield) by SMeq
    shield_dmg_reverse = enemy.shield/SMeq;
    % 2.1 compute the damage left without HTM
    health_dmg_reverse = sum(damage.value(~toxinind))-shield_dmg_reverse;
    % 2.2 if shieldgate happened, then this is multiplied by 0.05
    if (~headshot)&&shieldgate
      health_dmg_reverse = health_dmg_reverse*0.05;
    end
    % 3 we need to construct a new damage object of the remaining damage
    % 3.1 initialize the object
    damage_to_health = damage;
    % 3.2 take out toxin
    damage_to_health.type(toxinind) = [];
    damage_to_health.value(toxinind) = [];
    % 3.3 compute damage ratio
    damage_ratio = damage_to_health.value/sum(damage_to_health.value);
    % 3.4 assign correct shieldgated damages to the object
    damage_to_health.value = health_dmg_reverse*damage_ratio;
    % 4 add toxin damage back in damage_to_health if applicable
    if istoxin
      damage_to_health.type = [damage_to_health.type {'toxin'}];
      damage_to_health.value = [damage_to_health.value damage.value(toxininx)];
    end
    
    % 5 assign damage_out for display purposes
    damage_out.shield = enemy.shield;
    if (~headshot)&&shieldgate
      damage_out.shield_display = (sum(damage.value(~toxinind))-health_dmg_reverse)*SMeq;
    else
      damage_out.shield_display = damage_out.shield;
    end
    
    % 6 deplete enemy shield
    enemy.shield = 0;
    
  end
end



% continute to perform health/armor combo damage tick
% if we have damage through shield, replace the damage struct with
% damage_to_health struct

if use_damage_to_health_struct
  damage = damage_to_health;
  % calculate n again
  n = numel(damage.type);
end

% get armor HTM array (AM)
AM = zeros(1,n);
if enemy.armor>0
  for i = 1:n
    AM(i)=1+gethtm(damage.type{i},enemy.armor_type,dmghtm);
  end
end

% get health HTM array (HM)
HM = zeros(1,n);
for i = 1:n
  HM(i)=1+gethtm(damage.type{i},enemy.health_type,dmghtm);
end

if enemy.armor > 0 % if enemy has armor
  
  % get total armor/health modifier
  AHM_total = zeros(1,n);
  for i = 1:n
    if ~strcmpi(damage.type{i},'true')
      AHM_total(i) = 300/(300+enemy.armor*(2-AM(i)))*(AM(i))*(HM(i));
    else
      AHM_total(i) = damage.value*(1+HM(i));
    end
  end
  % deal damage
  health_dmg = sum(damage.value.*AHM_total);
  enemy.health = enemy.health-health_dmg;
else % if enemy does not have armor or damage is true damage
  % deal damage
  health_dmg = sum(damage.value.*HM);
  enemy.health = enemy.health-health_dmg;
end

damage_out.health = health_dmg;

damage_out.shield = round(damage_out.shield);
damage_out.shield_display = round(damage_out.shield_display);
damage_out.health = round(damage_out.health);

% if enemy is dead, set health to 0 rather than negative

if enemy.health <= 0
  dead = true;
end

if dead
  enemy.health = 0;
end


end