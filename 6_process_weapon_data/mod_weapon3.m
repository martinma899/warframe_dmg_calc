function [wpm] = mod_weapon3(wpb,mod,elemental_names, elemental_modifiers,quantum)
% wpb: base weapon. 
% mod: one big mod of all mods combined, except for elementals.
% elemental_names: names of all elemental stats from the mods, in correct
% order. 
% elemental_modifiers: bonus modifiers of all elemental damage from the
% mods, in correct order.
% quantum: true or false, indicating whether wpm will be quantized or not. 

wpm = wpb;

%% phase specific stats, phase 1

% critical chance
if isfield(mod,'CC')
wpm.CC = wpb.CC*(1+mod.CC);
end
% critical damage
if isfield(mod,'CM')
wpm.CM = wpb.CM*(1+mod.CM);
end
% status chance
if isfield(mod,'SC')
wpm.SC = wpb.SC*(1+mod.SC);
end

% base damage mods
if isfield(mod,'BD')
wpm.IMPACT      = wpb.IMPACT*(1+mod.BD);
wpm.PUNCTURE    = wpb.PUNCTURE*(1+mod.BD);
wpm.SLASH       = wpb.SLASH*(1+mod.BD);
wpm.COLD        = wpb.COLD*(1+mod.BD);
wpm.ELECTRICITY = wpb.ELECTRICITY*(1+mod.BD);
wpm.HEAT        = wpb.HEAT*(1+mod.BD);
wpm.TOXIN       = wpb.TOXIN*(1+mod.BD);
wpm.BLAST       = wpb.BLAST*(1+mod.BD);
wpm.CORROSIVE   = wpb.CORROSIVE*(1+mod.BD);
wpm.GAS         = wpb.GAS*(1+mod.BD);
wpm.MAGNETIC    = wpb.MAGNETIC*(1+mod.BD);
wpm.RADIATION   = wpb.RADIATION*(1+mod.BD);
wpm.VIRAL       = wpb.VIRAL*(1+mod.BD);
end

% calculate total base damage
total_base_damage = ...
wpm.IMPACT      + ...
wpm.PUNCTURE    + ...
wpm.SLASH       + ...
wpm.COLD        + ...
wpm.ELECTRICITY + ...
wpm.HEAT        + ...
wpm.TOXIN       + ...
wpm.BLAST       + ...
wpm.CORROSIVE   + ...
wpm.GAS         + ...
wpm.MAGNETIC    + ...
wpm.RADIATION   + ...
wpm.VIRAL;

% might as well take care of physical damage mods here
if isfield(mod,'IMPACT')
wpm.IMPACT = wpm.IMPACT*(1+mod.IMPACT);
end
if isfield(mod,'PUNCTURE')
wpm.PUNCTURE = wpm.PUNCTURE*(1+mod.PUNCTURE);
end
if isfield(mod,'SLASH')
wpm.SLASH = wpm.SLASH*(1+mod.SLASH);
end

% take care of elemental mods
% if we have elemental mods
if ~isempty(elemental_names)
% first find what elementals the weapon has innately
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
elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(all_elemental_names)
    if wpm.(all_elemental_names{i})~=0
        elemental_order = [elemental_order all_elemental_names(i)];
        elemental_values = [elemental_values ; wpm.(all_elemental_names{i})];
    end
end

% calculate all added elemental damage values from the mod 
elemental_values_from_mods = elemental_modifiers*total_base_damage;

% concatenate together elemental damage from mods and weapon itself
elemental_order = [elemental_names elemental_order];
elemental_values = [elemental_values_from_mods  elemental_values];

% combine elements with existing subfunction
[elemental_order,elemental_values] = ...
  combine_elementals (elemental_order,elemental_values);

% put elementals where they should be
wpm.COLD        = 0;
wpm.ELECTRICITY = 0;
wpm.HEAT        = 0;
wpm.TOXIN       = 0;
wpm.BLAST       = 0;
wpm.CORROSIVE   = 0;
wpm.GAS         = 0;
wpm.MAGNETIC    = 0;
wpm.RADIATION   = 0;
wpm.VIRAL       = 0;

for i = 1:numel(elemental_order)
    wpm.(elemental_order{i}) = elemental_values(i);
end
end
%% phase specific stats, phase 2

if wpb.PHASE2=='Y'
% critical chance
if isfield(mod,'CC')
wpm.CC2 = wpb.CC2*(1+mod.CC);
end
% critical damage
if isfield(mod,'CM')
wpm.CM2 = wpb.CM2*(1+mod.CM);
end
% status chance
if isfield(mod,'SC')
wpm.SC2 = wpb.SC2*(1+mod.SC);
end

% base damage mods
if isfield(mod,'BD')
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
total_base_damage2 = ...
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

% might as well take care of physical damage mods here
if isfield(mod,'IMPACT')
wpm.IMPACT2 = wpm.IMPACT2*(1+mod.IMPACT);
end
if isfield(mod,'PUNCTURE')
wpm.PUNCTURE2 = wpm.PUNCTURE2*(1+mod.PUNCTURE);
end
if isfield(mod,'SLASH')
wpm.SLASH2 = wpm.SLASH2*(1+mod.SLASH);
end

% take care of elemental mods

if ~isempty(elemental_modifiers)
% first find what elementals the weapon has innately

elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(all_elemental_names)
    if wpm.([all_elemental_names{i} '2'])~=0
        elemental_order = [elemental_order all_elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([all_elemental_names{i} '2'])];
    end
end

% calculate all added elemental damage values from the mod and record them
% in correct order
elemental_values_from_mods = elemental_modifiers*total_base_damage2;

% concatenate together elemental damage from mods and weapon itself
elemental_order = [elemental_names elemental_order];
elemental_values = [elemental_values_from_mods  elemental_values];

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
end
end

%% phase specific stats, phase 2

if wpb.PHASE3=='Y'
% critical chance
if isfield(mod,'CC')
wpm.CC3 = wpb.CC3*(1+mod.CC);
end
% critical damage
if isfield(mod,'CD')
wpm.CM3 = wpb.CM3*(1+mod.CM);
end
% status chance
if isfield(mod,'SC')
wpm.SC3 = wpb.SC3*(1+mod.SC);
end

% base damage mods
if isfield(mod,'BD')
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
total_base_damage3 = ...
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

% might as well take care of physical damage mods here
if isfield(mod,'IMPACT')
wpm.IMPACT3 = wpm.IMPACT3*(1+mod.IMPACT);
end
if isfield(mod,'PUNCTURE')
wpm.PUNCTURE3 = wpm.PUNCTURE3*(1+mod.PUNCTURE);
end
if isfield(mod,'SLASH')
wpm.SLASH3 = wpm.SLASH3*(1+mod.SLASH);
end

% take care of elemental mods

if ~isempty(elemental_modifiers)
% first find what elementals the weapon has innately

elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(all_elemental_names)
    if wpm.([all_elemental_names{i} '3'])~=0
        elemental_order = [elemental_order all_elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([all_elemental_names{i} '3'])];
    end
end

% calculate all added elemental damage values from the mod and record them
% in correct order
elemental_values_from_mods = elemental_modifiers*total_base_damage3;

% concatenate together elemental damage from mods and weapon itself
elemental_order = [elemental_names elemental_order];
elemental_values = [elemental_values_from_mods  elemental_values];

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
end
end

%% non phase specific stats

% take care of multishot
if isfield(mod,'MS')
wpm.MS = wpb.MS*(1+mod.MS);
end

% take care of fire rate
if isfield(mod,'FR')
wpm.FR = wpb.FR*(1+mod.FR);
wpm.CHARGE_TIME = wpb.CHARGE_TIME/(1+mod.FR);
end

% take care of RLS and RLT
if isfield(mod,'RLS')
wpm.RLS = wpb.RLS*(1+mod.RLS);
wpm.RLT = 1/wpm.RLS;
end

% take care of MAG
if isfield(mod,'MAG')
wpm.MAG = round(wpb.MAG*(1+mod.MAG));
end

% cake care of AMMO
if isfield(mod,'AMMO')
wpm.AMMO = round(wpb.AMMO*(1+mod.AMMO));
end

% take care of faction stats
if isfield(mod,'GRINEER');wpm.GRINEER = mod.GRINEER;end
if isfield(mod,'CORPUS');wpm.CORPUS = mod.CORPUS;end
if isfield(mod,'INFESTED');wpm.INFESTED = mod.INFESTED;end
if isfield(mod,'CORRUPTED');wpm.CORRUPTED = mod.CORRUPTED;end

% take care of a few other non phase dependent stats
if isfield(mod,'ENHANCE_CRIT')
wpm.ENHANCE_CRIT = mod.ENHANCE_CRIT;
end
if isfield(mod,'SLASH_ON_CRIT')
wpm.SLASH_ON_CRIT = mod.SLASH_ON_CRIT;
end
if isfield(mod,'STATUS_DURATION')
    wpm.STATUS_DURATION = wpm.STATUS_DURATION*(1+mod.STATUS_DURATION);
end

%% quantization calculation
if quantum % if quantization of weapon is enabled
    q = total_base_damage/16; % compute a quantum
    wpm.IMPACT      = round(wpm.IMPACT/q)*q;
    wpm.PUNCTURE    = round(wpm.PUNCTURE/q)*q;
    wpm.SLASH       = round(wpm.SLASH/q)*q;
    wpm.COLD        = round(wpm.COLD/q)*q;
    wpm.ELECTRICITY = round(wpm.ELECTRICITY/q)*q;
    wpm.HEAT        = round(wpm.HEAT/q)*q;
    wpm.TOXIN       = round(wpm.TOXIN/q)*q;
    wpm.BLAST       = round(wpm.BLAST/q)*q;
    wpm.CORROSIVE   = round(wpm.CORROSIVE/q)*q;
    wpm.GAS         = round(wpm.GAS/q)*q;
    wpm.MAGNETIC    = round(wpm.MAGNETIC/q)*q;
    wpm.RADIATION   = round(wpm.RADIATION/q)*q;
    wpm.VIRAL       = round(wpm.VIRAL/q)*q;
if wpb.PHASE2=='Y'
    q = total_base_damage2/16; % compute a quantum
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
if wpb.PHASE3=='Y'
    q = total_base_damage3/16; % compute a quantum
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

end