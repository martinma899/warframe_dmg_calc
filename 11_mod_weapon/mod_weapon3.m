function [wpm] = mod_weapon3(wpb,mod,elemental_names, elemental_modifiers,quantum)
% wpb: base weapon.
% mod: one big mod of all mods combined, except for elementals.
% elemental_names: names of all elemental stats from the mods, in correct
% order.
% elemental_modifiers: bonus modifiers of all elemental damage from the
% mods, in correct order.
% quantum: true or false, indicating whether wpm will be quantized or not.

wpm = wpb;

% boolean variables indicating if we have damage phase 2 and 3
isp2 = strcmp(wpb.PHASE2,'Y');
isp3 = strcmp(wpb.PHASE3,'Y');

% name of all elemental types
all_elemental_names = {...
  'COLD',...
  'ELECTRICITY',...
  'HEAT',...
  'TOXIN',...
  'VIRAL',...
  'RADIATION',...
  'MAGNETIC',...
  'GAS',...
  'CORROSIVE',...
  'BLAST'};
% initialize the fields we will add to the weapon
wpm.FACTION = 0; % all kinds of faction mods piled together
wpm.ENHANCE_CRIT = 0; % enhance crit
wpm.SLASH_ON_CRIT = 0; % slash on crit
wpm.STATUS_DURATION_MOD = 0; % status duration modifier
wpm.HSM_MOD = 0; % head shot multiplier modifier
wpm.TOXIN_MOD = 0; % toxin modifier
wpm.ELECTRICITY_MOD = 0; % electricity modifier
wpm.HEAT_MOD = 0; % heat modifier

%% critical chance
if isfield(mod,'CC')
  wpm.CC1 = wpb.CC1*(1+mod.CC);
  if isp2;wpm.CC2 = wpb.CC2*(1+mod.CC);end
  if isp3;wpm.CC3 = wpb.CC3*(1+mod.CC);end
end

%% critical damage
if isfield(mod,'CM')
  wpm.CM1 = wpb.CM1*(1+mod.CM);
  if isp2;wpm.CM2 = wpb.CM2*(1+mod.CM);end
  if isp3;wpm.CM3 = wpb.CM3*(1+mod.CM);end
end

%% status chance
if isfield(mod,'SC')
  wpm.SC1 = wpb.SC1*(1+mod.SC);
  if isp2;wpm.SC2 = wpb.SC2*(1+mod.SC);end
  if isp3;wpm.SC3 = wpb.SC3*(1+mod.SC);end
end

%% multishot
if isfield(mod,'MS');wpm.MS = wpb.MS*(1+mod.MS);end

%% fire rate
if isfield(mod,'FR')
  wpm.FR = wpb.FR*(1+mod.FR);
  wpm.CHARGE_TIME = wpb.CHARGE_TIME/(1+mod.FR);
end

%% take care of RLS and RLT
if isfield(mod,'RLS');wpm.RLS = wpb.RLS*(1+mod.RLS);wpm.RLT = 1/wpm.RLS;end

%% take care of MAG
if isfield(mod,'MAG');wpm.MAG = round(wpb.MAG*(1+mod.MAG));end

%% cake care of AMMO
if isfield(mod,'AMMO');wpm.AMMO = round(wpb.AMMO*(1+mod.AMMO));end

%% take care of faction stats
if isfield(mod,'GRINEER');wpm.FACTION = wpm.FACTION+mod.GRINEER;end
if isfield(mod,'CORPUS');wpm.FACTION = wpm.FACTION+mod.CORPUS;end
if isfield(mod,'INFESTED');wpm.FACTION = wpm.FACTION+mod.INFESTED;end
if isfield(mod,'CORRUPTED');wpm.FACTION = wpm.FACTION+mod.CORRUPTED;end

%% Chance to enhance crit
if isfield(mod,'ENHANCE_CRIT');wpm.ENHANCE_CRIT = mod.ENHANCE_CRIT;end

%% Chance to apply slash on crit
if isfield(mod,'SLASH_ON_CRIT');wpm.SLASH_ON_CRIT = mod.SLASH_ON_CRIT;end

%% Status douration
if isfield(mod,'STATUS_DURATION')
  wpm.STATUS_DURATION_MOD = mod.STATUS_DURATION;
end

%% Headshot multiplier
if isfield(mod,'HSM');wpm.HSM_MOD = mod.HSM;end

%% Keep track of toxin, electricity, and heat mod stats
% only used later in proc damage calculation, this is not part of actual
% weapon damage calculation
if isfield(mod,'TOXIN');wpm.TOXIN_MOD = mod.TOXIN;end
if isfield(mod,'ELECTRICITY');wpm.ELECTRICITY_MOD = mod.ELECTRICITY;end
if isfield(mod,'HEAT');wpm.HEAT_MOD = mod.HEAT;end

%% Physical damage types
if isfield(mod,'IMPACT')
  wpm.IMPACT1 = wpm.IMPACT1*(1+mod.IMPACT);
  if isp2;wpm.IMPACT2 = wpm.IMPACT2*(1+mod.IMPACT);end
  if isp3;wpm.IMPACT3 = wpm.IMPACT3*(1+mod.IMPACT);end
end

if isfield(mod,'PUNCTURE')
  wpm.PUNCTURE1 = wpm.PUNCTURE1*(1+mod.PUNCTURE);
  if isp2;wpm.PUNCTURE2 = wpm.PUNCTURE2*(1+mod.PUNCTURE);end
  if isp3;wpm.PUNCTURE3 = wpm.PUNCTURE3*(1+mod.PUNCTURE);end
end

if isfield(mod,'SLASH')
  wpm.SLASH1 = wpm.SLASH1*(1+mod.SLASH);
  if isp2;wpm.SLASH2 = wpm.SLASH2*(1+mod.SLASH);end
  if isp3;wpm.SLASH3 = wpm.SLASH3*(1+mod.SLASH);end
end

%% phase specific stats, phase 1

% base damage mods
if isfield(mod,'BD')
  wpm.BONUS_DAMAGE1= wpb.BONUS_DAMAGE1*(1+mod.BD);
  wpm.IMPACT1      = wpb.IMPACT1*(1+mod.BD);
  wpm.PUNCTURE1    = wpb.PUNCTURE1*(1+mod.BD);
  wpm.SLASH1       = wpb.SLASH1*(1+mod.BD);
  wpm.COLD1        = wpb.COLD1*(1+mod.BD);
  wpm.ELECTRICITY1 = wpb.ELECTRICITY1*(1+mod.BD);
  wpm.HEAT1        = wpb.HEAT1*(1+mod.BD);
  wpm.TOXIN1       = wpb.TOXIN1*(1+mod.BD);
  wpm.BLAST1       = wpb.BLAST1*(1+mod.BD);
  wpm.CORROSIVE1   = wpb.CORROSIVE1*(1+mod.BD);
  wpm.GAS1         = wpb.GAS1*(1+mod.BD);
  wpm.MAGNETIC1    = wpb.MAGNETIC1*(1+mod.BD);
  wpm.RADIATION1   = wpb.RADIATION1*(1+mod.BD);
  wpm.VIRAL1       = wpb.VIRAL1*(1+mod.BD);
end

% calculate total base damage
wpm.TOTAL_DAMAGE1 = ...
  wpm.BONUS_DAMAGE1+...
  wpm.IMPACT1      + ...
  wpm.PUNCTURE1    + ...
  wpm.SLASH1       + ...
  wpm.COLD1        + ...
  wpm.ELECTRICITY1 + ...
  wpm.HEAT1        + ...
  wpm.TOXIN1       + ...
  wpm.BLAST1       + ...
  wpm.CORROSIVE1   + ...
  wpm.GAS1         + ...
  wpm.MAGNETIC1    + ...
  wpm.RADIATION1   + ...
  wpm.VIRAL1;

% take care of elemental mods
if ~isempty(elemental_names) % if we have elemental mods
  
  elemental_order = []; % row cell array
  elemental_values = []; % column vector
  
  % find all innate elementals of the weapon and record them
  for i = 1:numel(all_elemental_names)
    if wpm.([all_elemental_names{i} '1'])~=0
      elemental_order = [elemental_order all_elemental_names(i)];
      elemental_values = [elemental_values ; wpm.([all_elemental_names{i} '1'])];
    end
  end
  
  % calculate all added elemental damage values from the mod
  elemental_values_from_mods = elemental_modifiers*wpm.TOTAL_DAMAGE1;
  
  % concatenate together elemental damage from mods and weapon itself
  elemental_order = [elemental_names elemental_order];
  elemental_values = [elemental_values_from_mods  elemental_values];
  
  % concatenate bonus damage at the end
  if wpm.BONUS_DAMAGE1>0
    elemental_order = [elemental_order upper(wpm.BONUS_ELEMENT)];
    elemental_values = [elemental_values wpm.BONUS_DAMAGE1];
  end
  
  % combine elements with existing subfunction
  [elemental_order,elemental_values] = ...
    combine_elementals (elemental_order,elemental_values);
  
  % put elementals where they should be
  wpm.COLD1        = 0;
  wpm.ELECTRICITY1 = 0;
  wpm.HEAT1        = 0;
  wpm.TOXIN1       = 0;
  wpm.BLAST1       = 0;
  wpm.CORROSIVE1   = 0;
  wpm.GAS1         = 0;
  wpm.MAGNETIC1    = 0;
  wpm.RADIATION1   = 0;
  wpm.VIRAL1       = 0;
  
  for i = 1:numel(elemental_order)
    wpm.([elemental_order{i} '1']) = elemental_values(i);
  end
  
% calculate final base damage
wpm.TOTAL_DAMAGE1 = ...
  wpm.IMPACT1      + ...
  wpm.PUNCTURE1    + ...
  wpm.SLASH1       + ...
  wpm.COLD1        + ...
  wpm.ELECTRICITY1 + ...
  wpm.HEAT1        + ...
  wpm.TOXIN1       + ...
  wpm.BLAST1       + ...
  wpm.CORROSIVE1   + ...
  wpm.GAS1         + ...
  wpm.MAGNETIC1    + ...
  wpm.RADIATION1   + ...
  wpm.VIRAL1;
  
end

%% phase specific stats, phase 2

if isp2
  % base damage mods
  if isfield(mod,'BD')
    wpm.BONUS_DAMAGE2= wpb.BONUS_DAMAGE2*(1+mod.BD);
    wpm.IMPACT2      = wpb.IMPACT2*(1+mod.BD);
    wpm.PUNCTURE2    = wpb.PUNCTURE2*(1+mod.BD);
    wpm.SLASH2       = wpb.SLASH2*(1+mod.BD);
    wpm.COLD2        = wpb.COLD2*(1+mod.BD);
    wpm.ELECTRICITY2 = wpb.ELECTRICITY2*(1+mod.BD);
    wpm.HEAT2        = wpb.HEAT2*(1+mod.BD);
    wpm.TOXIN2       = wpb.TOXIN2*(1+mod.BD);
    wpm.BLAST2       = wpb.BLAST2*(1+mod.BD);
    wpm.CORROSIVE2   = wpb.CORROSIVE2*(1+mod.BD);
    wpm.GAS2         = wpb.GAS2*(1+mod.BD);
    wpm.MAGNETIC2    = wpb.MAGNETIC2*(1+mod.BD);
    wpm.RADIATION2   = wpb.RADIATION2*(1+mod.BD);
    wpm.VIRAL2       = wpb.VIRAL2*(1+mod.BD);
  end
  
  % calculate total base damage
  wpm.TOTAL_DAMAGE2 = ...
    wpm.BONUS_DAMAGE2+...
    wpm.IMPACT2      + ...
    wpm.PUNCTURE2    + ...
    wpm.SLASH2       + ...
    wpm.COLD2        + ...
    wpm.ELECTRICITY2 + ...
    wpm.HEAT2        + ...
    wpm.TOXIN2       + ...
    wpm.BLAST2       + ...
    wpm.CORROSIVE2   + ...
    wpm.GAS2         + ...
    wpm.MAGNETIC2    + ...
    wpm.RADIATION2   + ...
    wpm.VIRAL2;
  
  % take care of elemental mods
  if ~isempty(elemental_names) % if we have elemental mods
    
    elemental_order = []; % row cell array
    elemental_values = []; % column vector
    
    % find all innate elementals of the weapon and record them
    for i = 1:numel(all_elemental_names)
      if wpm.([all_elemental_names{i} '2'])~=0
        elemental_order = [elemental_order all_elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([all_elemental_names{i} '2'])];
      end
    end
    
    % calculate all added elemental damage values from the mod
    elemental_values_from_mods = elemental_modifiers*wpm.TOTAL_DAMAGE2;
    
    % concatenate together elemental damage from mods and weapon itself
    elemental_order = [elemental_names elemental_order];
    elemental_values = [elemental_values_from_mods  elemental_values];
    
    % concatenate bonus damage at the end
    if wpm.BONUS_DAMAGE2>0
      elemental_order = [elemental_order upper(wpm.BONUS_ELEMENT)];
      elemental_values = [elemental_values wpm.BONUS_DAMAGE2];
    end
    
    % combine elements with existing subfunction
    [elemental_order,elemental_values] = ...
      combine_elementals (elemental_order,elemental_values);
    
    % put elementals where they should be
    wpm.COLD2        = 0;
    wpm.ELECTRICITY2 = 0;
    wpm.HEAT2        = 0;
    wpm.TOXIN2       = 0;
    wpm.BLAST2       = 0;
    wpm.CORROSIVE2   = 0;
    wpm.GAS2         = 0;
    wpm.MAGNETIC2    = 0;
    wpm.RADIATION2   = 0;
    wpm.VIRAL2       = 0;
    
    for i = 1:numel(elemental_order)
      wpm.([elemental_order{i} '2']) = elemental_values(i);
    end

    % calculate final base damage
    wpm.TOTAL_DAMAGE2 = ...
      wpm.IMPACT2      + ...
      wpm.PUNCTURE2    + ...
      wpm.SLASH2       + ...
      wpm.COLD2        + ...
      wpm.ELECTRICITY2 + ...
      wpm.HEAT2        + ...
      wpm.TOXIN2       + ...
      wpm.BLAST2       + ...
      wpm.CORROSIVE2   + ...
      wpm.GAS2         + ...
      wpm.MAGNETIC2    + ...
      wpm.RADIATION2   + ...
      wpm.VIRAL2;
  end
end

%% phase specific stats, phase 2

if isp3
  % base damage mods
  if isfield(mod,'BD')
    wpm.BONUS_DAMAGE3= wpb.BONUS_DAMAGE3*(1+mod.BD);
    wpm.IMPACT3      = wpb.IMPACT3*(1+mod.BD);
    wpm.PUNCTURE3    = wpb.PUNCTURE3*(1+mod.BD);
    wpm.SLASH3       = wpb.SLASH3*(1+mod.BD);
    wpm.COLD3        = wpb.COLD3*(1+mod.BD);
    wpm.ELECTRICITY3 = wpb.ELECTRICITY3*(1+mod.BD);
    wpm.HEAT3        = wpb.HEAT3*(1+mod.BD);
    wpm.TOXIN3       = wpb.TOXIN3*(1+mod.BD);
    wpm.BLAST3       = wpb.BLAST3*(1+mod.BD);
    wpm.CORROSIVE3   = wpb.CORROSIVE3*(1+mod.BD);
    wpm.GAS3         = wpb.GAS3*(1+mod.BD);
    wpm.MAGNETIC3    = wpb.MAGNETIC3*(1+mod.BD);
    wpm.RADIATION3   = wpb.RADIATION3*(1+mod.BD);
    wpm.VIRAL3       = wpb.VIRAL3*(1+mod.BD);
  end
  
  % calculate total base damage
  wpm.TOTAL_DAMAGE3 = ...
    wpm.BONUS_DAMAGE3+...
    wpm.IMPACT3      + ...
    wpm.PUNCTURE3    + ...
    wpm.SLASH3       + ...
    wpm.COLD3        + ...
    wpm.ELECTRICITY3 + ...
    wpm.HEAT3        + ...
    wpm.TOXIN3       + ...
    wpm.BLAST3       + ...
    wpm.CORROSIVE3   + ...
    wpm.GAS3         + ...
    wpm.MAGNETIC3    + ...
    wpm.RADIATION3   + ...
    wpm.VIRAL3;
  
  % take care of elemental mods
  if ~isempty(elemental_names) % if we have elemental mods
    
    elemental_order = []; % row cell array
    elemental_values = []; % column vector
    
    % find all innate elementals of the weapon and record them
    for i = 1:numel(all_elemental_names)
      if wpm.([all_elemental_names{i} '3'])~=0
        elemental_order = [elemental_order all_elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([all_elemental_names{i} '3'])];
      end
    end
    
    % calculate all added elemental damage values from the mod
    elemental_values_from_mods = elemental_modifiers*wpm.TOTAL_DAMAGE3;
    
    % concatenate together elemental damage from mods and weapon itself
    elemental_order = [elemental_names elemental_order];
    elemental_values = [elemental_values_from_mods  elemental_values];
    
    % concatenate bonus damage at the end
    if wpm.BONUS_DAMAGE3>0
      elemental_order = [elemental_order upper(wpm.BONUS_ELEMENT)];
      elemental_values = [elemental_values wpm.BONUS_DAMAGE3];
    end
    
    % combine elements with existing subfunction
    [elemental_order,elemental_values] = ...
      combine_elementals (elemental_order,elemental_values);
    
    % put elementals where they should be
    wpm.COLD3        = 0;
    wpm.ELECTRICITY3 = 0;
    wpm.HEAT3        = 0;
    wpm.TOXIN3       = 0;
    wpm.BLAST3       = 0;
    wpm.CORROSIVE3   = 0;
    wpm.GAS3         = 0;
    wpm.MAGNETIC3    = 0;
    wpm.RADIATION3   = 0;
    wpm.VIRAL3       = 0;
    
    for i = 1:numel(elemental_order)
      wpm.([elemental_order{i} '3']) = elemental_values(i);
    end

    % calculate final base damage
    wpm.TOTAL_DAMAGE3 = ...
      wpm.IMPACT3      + ...
      wpm.PUNCTURE3    + ...
      wpm.SLASH3       + ...
      wpm.COLD3        + ...
      wpm.ELECTRICITY3 + ...
      wpm.HEAT3        + ...
      wpm.TOXIN3       + ...
      wpm.BLAST3       + ...
      wpm.CORROSIVE3   + ...
      wpm.GAS3         + ...
      wpm.MAGNETIC3    + ...
      wpm.RADIATION3   + ...
      wpm.VIRAL3;
  end
end

%% quantization calculation
if quantum % if quantization of weapon is enabled
  q = wpm.TOTAL_DAMAGE1/16; % compute a quantum
  wpm.IMPACT1      = round(wpm.IMPACT1/q)*q;
  wpm.PUNCTURE1    = round(wpm.PUNCTURE1/q)*q;
  wpm.SLASH1       = round(wpm.SLASH1/q)*q;
  wpm.COLD1        = round(wpm.COLD1/q)*q;
  wpm.ELECTRICITY1 = round(wpm.ELECTRICITY1/q)*q;
  wpm.HEAT1        = round(wpm.HEAT1/q)*q;
  wpm.TOXIN1       = round(wpm.TOXIN1/q)*q;
  wpm.BLAST1       = round(wpm.BLAST1/q)*q;
  wpm.CORROSIVE1   = round(wpm.CORROSIVE1/q)*q;
  wpm.GAS1         = round(wpm.GAS1/q)*q;
  wpm.MAGNETIC1    = round(wpm.MAGNETIC1/q)*q;
  wpm.RADIATION1   = round(wpm.RADIATION1/q)*q;
  wpm.VIRAL1       = round(wpm.VIRAL1/q)*q;
  if isp2
    q = wpm.TOTAL_DAMAGE2/16; % compute a quantum
    wpm.IMPACT2      = round(wpm.IMPACT2/q)*q;
    wpm.PUNCTURE2    = round(wpm.PUNCTURE2/q)*q;
    wpm.SLASH2       = round(wpm.SLASH2/q)*q;
    wpm.COLD2        = round(wpm.COLD2/q)*q;
    wpm.ELECTRICITY2 = round(wpm.ELECTRICITY2/q)*q;
    wpm.HEAT2        = round(wpm.HEAT2/q)*q;
    wpm.TOXIN2       = round(wpm.TOXIN2/q)*q;
    wpm.BLAST2       = round(wpm.BLAST2/q)*q;
    wpm.CORROSIVE2   = round(wpm.CORROSIVE2/q)*q;
    wpm.GAS2         = round(wpm.GAS2/q)*q;
    wpm.MAGNETIC2    = round(wpm.MAGNETIC2/q)*q;
    wpm.RADIATION2   = round(wpm.RADIATION2/q)*q;
    wpm.VIRAL2       = round(wpm.VIRAL2/q)*q;
  end
  if isp3
    q = wpm.TOTAL_DAMAGE3/16; % compute a quantum
    wpm.IMPACT3      = round(wpm.IMPACT3/q)*q;
    wpm.PUNCTURE3    = round(wpm.PUNCTURE3/q)*q;
    wpm.SLASH3       = round(wpm.SLASH3/q)*q;
    wpm.COLD3        = round(wpm.COLD3/q)*q;
    wpm.ELECTRICITY3 = round(wpm.ELECTRICITY3/q)*q;
    wpm.HEAT3        = round(wpm.HEAT3/q)*q;
    wpm.TOXIN3       = round(wpm.TOXIN3/q)*q;
    wpm.BLAST3       = round(wpm.BLAST3/q)*q;
    wpm.CORROSIVE3   = round(wpm.CORROSIVE3/q)*q;
    wpm.GAS3         = round(wpm.GAS3/q)*q;
    wpm.MAGNETIC3    = round(wpm.MAGNETIC3/q)*q;
    wpm.RADIATION3   = round(wpm.RADIATION3/q)*q;
    wpm.VIRAL3       = round(wpm.VIRAL3/q)*q;
  end
end

if isp2
  wpm.TOTAL_DAMAGE = wpm.TOTAL_DAMAGE1+wpm.TOTAL_DAMAGE2;
elseif isp3
  wpm.TOTAL_DAMAGE = wpm.TOTAL_DAMAGE1+wpm.TOTAL_DAMAGE2+wpm.TOTAL_DAMAGE3;
end
end