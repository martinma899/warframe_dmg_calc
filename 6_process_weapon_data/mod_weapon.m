function [wpm_quantum,wpm] = mod_weapon(wpb, mods)
% takes in a series of mods and an unmodded weapon object, and mod it
% 
% input 1: wpb, the struct of an unmodded weapon
% 
% input 2: mod
% the combined mod object of all the mods and buffs applied to this weapon

wpm = wpb; % create the modded weapon object

% First Step
% create additive multiplier array to keep track of all multipliers
% order: FR, MAG, AMMO, RLS, CC, CM, SC, MS, BD, impact, 
% puncture, slash, cold, electricity, heat, toxin
mtplr_names = {'BD' 'FR' 'CH' 'MAG' 'AMMO' 'RLS' 'CC' 'CM' 'SC' 'MS' 'SD'...
  'impact' 'puncture' 'slash' 'cold' 'electricity' 'heat' 'toxin' ...
  'grineer' 'corpus' 'infested' 'corrupted'};
% numerical array keeping track of all corresponding numerical total
% multipliers
mtplr_values = zeros(1,numel(mtplr_names));

% an array with four elemental name strings
mtplr_elemental_arr = {'cold' 'electricity' 'heat' 'toxin'};
all_elemental_fieldnames = {'cold' 'electricity' 'heat' 'toxin' 'blast' ...
  'corrosive' 'gas' 'magnetic' 'radiation' 'viral'};

% get weapon field name list
wpfields = fields(wpm);
% get the index array that tells which fields are damage type arrays
% typically has the value 13:25
dmg_type_ind = get_dmg_type_ind(wpfields);
elemental_dmg_type_ind = get_elemental_dmg_type_ind(wpfields);

% fix weapon type interactions
% if strcmp(wpb.trigger,'held')
%   wpm.MAG = wpm.MAG*2;
% end

% iterate through every single mod and assign proper multipliers to
% mtplr_arr
% at the same time do the elemental combination procedure

% temporary housing arrays used for elemental combination algorithm
modded_elemental_names = [];
modded_elemental_mtplrs = [];

for i = 1:numel(mods)
  thismod = mods{i};
  mod_fields = fields(thismod); % first, extract all field names of this mod
  mod_fields(1) = []; % take out the first field which is 'name', the rest are modifiers
  for j = 1:numel(mod_fields) % iterate through every modifier field of the mod
    % now check if this is an elemental. if so, keep track of it and do not
    % add it to the main damage multipler array yet. 
    if any(strcmp(mod_fields{j},mtplr_elemental_arr))
      modded_elemental_names = [modded_elemental_names mod_fields(j)];
      modded_elemental_mtplrs = [modded_elemental_mtplrs thismod.(mod_fields{j})];
    else % else, add the multipler to main multiplier array and keep track of it
    mtplr_values(strcmp(mod_fields{j},mtplr_names)) = ...
      mtplr_values(strcmp(mod_fields{j},mtplr_names))+thismod.(mod_fields{j}); 
    end
  end
end

% apply modifiers including 'BD' 'FR' 'MAG' 'AMMO' 'RLS' 'CC' 'CM' 'SC' 'MS' ...
%  'grineer' 'corpus' 'infested' 'corrupted'

for i = 1:numel(mtplr_names)
  this_mtplr_name = mtplr_names{i};
  this_mtplr_value = mtplr_values(i);
  switch this_mtplr_name
    case {'cold' 'electricity' 'heat' 'toxin' 'impact' 'puncture' 'slash'} 
      % in case of IPS and elementals do nothing for right now
    case 'RLS'
      % reload speed modifier uses a slightly different formula
      wpm.RLT = wpm.RLT/(1+this_mtplr_value);
    case 'MS' % for multishot, do the beam weapon correction
      if strcmp(wpm.trigger,'held') % if it is beam weapon
        % then leave MS parameter intact and multiply base damage directly
        for j = dmg_type_ind
          % only do the damage calculation if that damage type is not 0 to
          % save computation
          if wpm.(wpfields{j})>0
            wpm.(wpfields{j}) = wpm.(wpfields{j})*(1+this_mtplr_value);
          end
        end
      else
        % otherwise do the regular thing to MS parameter
        wpm.(this_mtplr_name) = wpm.(this_mtplr_name)*(1+this_mtplr_value);
      end
    case 'BD'
      % base damage modifier modifies each damage type
      for j = dmg_type_ind
        % only do the damage calculation if that damage type is not 0 to
        % save computation 
        if wpm.(wpfields{j})>0
          wpm.(wpfields{j}) = wpm.(wpfields{j})*(1+this_mtplr_value);
        end
      end
    case 'FR' % for fire rate, modify both fire rate and charge rate.
      wpm.(this_mtplr_name) = wpm.(this_mtplr_name)*(1+this_mtplr_value); %FR
      wpm.CH = wpm.CH/(1+this_mtplr_value); %CH
    otherwise
      % otherwise just do the normal multiplier additions
      wpm.(this_mtplr_name) = wpm.(this_mtplr_name)*(1+this_mtplr_value);
  end
      
end

% compute total base damage of the weapon, tbd
tempcell = struct2cell(wpm);
tbd = sum(cell2mat(tempcell(dmg_type_ind)));

% compute a quantum of damage
quantum = tbd/16;

% after base damage mods have been applied, apply IPS modifiers
IPS_names_arr = {'impact' 'puncture' 'slash'};
for i = 1:3
  this_mtplr_name = IPS_names_arr{i};
  this_mtplr_value = mtplr_values(strcmp(this_mtplr_name,mtplr_names));
  wpm.(this_mtplr_name) = wpm.(this_mtplr_name)*(1+this_mtplr_value);
end

% keep track of multipliers that will later be used in dot status procs
wpm.slash_mtplr = sum(this_mtplr_value(strcmp('slash',this_mtplr_name)));
wpm.electricity_mtplr = ...
  sum(modded_elemental_mtplrs(strcmp('electricity',modded_elemental_names)));
wpm.heat_mtplr = ...
  sum(modded_elemental_mtplrs(strcmp('heat',modded_elemental_names)));
wpm.toxin_mtplr = ...
  sum(modded_elemental_mtplrs(strcmp('toxin',modded_elemental_names)));

% if there actually are any elemental mods,
if ~isempty(modded_elemental_names)
  
  % now compute the array of total modded elemental damage values
  modded_elemental_values = modded_elemental_mtplrs'*tbd;
  
  % run through unmodded weapon and find all base elemental types, and
  % concatenate those to the end of modded_elemental_names and
  % modded_elemental_values
  
  for i = elemental_dmg_type_ind
    if wpm.(wpfields{i})~=0
      modded_elemental_names = [modded_elemental_names wpfields(i)];
      modded_elemental_values = [modded_elemental_values ; wpm.(wpfields{i})];
    end
  end
  
  % implement an algorithm that correctly takes in modded_elemental_name and
  % modded_elemental_values and combines elemental types correctly and
  % re-assigns the elemental damages to the weapon
  
  [combined_elemental_names,combined_elemental_values] = ...
    combine_elementals (modded_elemental_names, modded_elemental_values);
  
  % clear out all elemental damage values of wpm
  for i = elemental_dmg_type_ind
    wpm.(wpfields{i}) = zeros(1,wpb.damage_phase);
  end
  
  % assign all elemental damage values back
  for i = 1:numel(combined_elemental_names)
    wpm.(combined_elemental_names{i}) = combined_elemental_values(i,:);
  end
  
end

% export a version of weapon that incorporates the damage quantum system of
% warframe
wpm_quantum = wpm;
for i = dmg_type_ind
  if wpm_quantum.(wpfields{i})~=0
    wpm_quantum.(wpfields{i})=round(wpm_quantum.(wpfields{i})./quantum).*quantum;
  end
end

end