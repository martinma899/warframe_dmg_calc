function [avgdps, burstdps, htm, htmeff] = wp_dps_calc(wp,enemy,dmghtm)
% input: 1. weapon object 2. enemy object
% enemy objects have 3 layers of health: shield, armor, health. 
% if the enemy has any shield, the output dps will be raw dps of the weapon
% not considering any status effect against shield. 
% if the enemy has no shield, the output dps will be raw dps of the weapon
% not considering any status effect against armor. 
% enemy object fields: 
% shield_type, shield, armor_type, armor, health_type,
% health

% get weapon fields
wpfields = fields(wp);
% get the index array that tells which fields are damage type arrays
% typically has the value 13:25
dmg_type_ind = get_dmg_type_ind(wpfields);

% compute total base damage of the weapon, tbd
tempcell = struct2cell(wp);
tbd = sum(cell2mat(tempcell(dmg_type_ind)));

% fix weapon type interactions
if strcmp(wp.trigger,'held')
  wp.MAG = wp.MAG*2;
end

% decide what dps to calculate
if enemy.shield>0
  health_type_general = 'shield';
else
  if enemy.armor>0
    health_type_general = 'armor+flesh';
  else
    health_type_general = 'flesh';
  end
end

dmg = 0; % initialize per shot damage
for i = dmg_type_ind % iterate through every non zero damage type of the weapon
  % and apply appropriate damage modifier
  switch health_type_general
    case 'shield'
      if wp.(wpfields{i})>0 % if this particular damage type is not 0
        % add this damage type modded with health type modifier
        dmg = dmg+wp.(wpfields{i})*...
          (1+gethtm(wpfields{i},enemy.shield_type,dmghtm));
      end
    case 'flesh'
      if wp.(wpfields{i})>0 % if this particular damage type is not 0
        % add this damage type modded with health type modifier
        dmg = dmg+wp.(wpfields{i})*...
          (1+gethtm(wpfields{i},enemy.health_type,dmghtm));
      end
    case 'armor+flesh'
      if wp.(wpfields{i})>0 % if this particular damage type is not 0
        % add this damage type modded with health type modifier
        % in the case of armor+flesh, perform the combined armor+flesh
        % formula
        dmg = dmg+wp.(wpfields{i})*...
          300/(300+enemy.armor*(1-gethtm(wpfields{i},enemy.armor_type,dmghtm)))*...
          (1+gethtm(wpfields{i},enemy.armor_type,dmghtm))*...
        (1+gethtm(wpfields{i},enemy.health_type,dmghtm));
      end
  end
end
% compute actual health/armor/shield type multiplier
htm = dmg/tbd;
% compute effective multiplier. Meaning if there is armor, how the weapon
% does comparing to unity modifier damage against the same armor. 
htmeff = htm/(300/(300+enemy.armor));

% take into account effect of multishot, crit and faction damage mod
dmg = dmg*wp.MS*(1+(wp.CM-1)*wp.CC)*wp.(enemy.faction); 
% compute burst dps and average dps according to formula
burstdps = dmg*wp.FR;
avgdps = dmg/(1/wp.FR+1/(1/wp.RLT+wp.MAG));
end