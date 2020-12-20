function [wpm] = mod_weapon2(wpb,mod,quantum)
% wpb: base weapon. 
% mod: one big mod of all mods combined.
% quantum: true or false, indicating whether wpm will be quantized or not. 

wpm = wpb;

%% phase specific stats, phase 1

% critical chance
wpm.CC = wpb.CC*(1+mod.CC);
% critical damage
wpm.CM = wpb.CM*(1+mod.CM);
% status chance
wpm.SC = wpb.SC*(1+mod.SC);

% base damage mods
wpm.impact      = wpb.impact*(1+mod.base_damage);
wpm.puncture    = wpb.puncture*(1+mod.base_damage);
wpm.slash       = wpb.slash*(1+mod.base_damage);
wpm.cold        = wpb.cold*(1+mod.base_damage);
wpm.electricity = wpb.electricity*(1+mod.base_damage);
wpm.heat        = wpb.heat*(1+mod.base_damage);
wpm.toxin       = wpb.toxin*(1+mod.base_damage);
wpm.blast       = wpb.blast*(1+mod.base_damage);
wpm.corrosive   = wpb.corrosive*(1+mod.base_damage);
wpm.gas         = wpb.gas*(1+mod.base_damage);
wpm.magnetic    = wpb.magnetic*(1+mod.base_damage);
wpm.radiation   = wpb.radiation*(1+mod.base_damage);
wpm.viral       = wpb.viral*(1+mod.base_damage);

% calculate total base damage
total_base_damage = ...
wpm.impact      + ...
wpm.puncture    + ...
wpm.slash       + ...
wpm.cold        + ...
wpm.electricity + ...
wpm.heat        + ...
wpm.toxin       + ...
wpm.blast       + ...
wpm.corrosive   + ...
wpm.gas         + ...
wpm.magnetic    + ...
wpm.radiation   + ...
wpm.viral;

% might as well take care of physical damage mods here
wpm.impact = wpm.impact*(1+mod.impact);
wpm.puncture = wpm.puncture*(1+mod.puncture);
wpm.slash = wpm.slash*(1+mod.slash);

% take care of elemental mods

if ~isempty(mod.elemental_order)
% first find what elementals the weapon has innately
elemental_names = {
'cold'
'electricity'
'heat'
'toxin'
'blast'
'corrosive'
'gas'
'magnetic'
'radiation'
'viral'};
elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(elemental_names)
    if wpm.(elemental_names{i})~=0
        elemental_order = [elemental_order elemental_names(i)];
        elemental_values = [elemental_values ; wpm.(elemental_names{i})];
    end
end

% calculate all added elemental damage values from the mod and record them
% in correct order
elemental_values_from_mods = [];
for i = 1:numel(mod.elemental_order)
    elemental_values_from_mods = [elemental_values_from_mods ;...
        total_base_damage*(mod.(mod.elemental_order{i}))];
end

% concatenate together elemental damage from mods and weapon itself
elemental_order = [mod.elemental_order elemental_order];
elemental_values = [elemental_values_from_mods ; elemental_values];

% combine elements with existing subfunction
[elemental_order,elemental_values] = ...
  combine_elementals (elemental_order,elemental_values);

% put elementals where they should be
wpm.cold        = 0;
wpm.electricity = 0;
wpm.heat        = 0;
wpm.toxin       = 0;
wpm.blast       = 0;
wpm.corrosive   = 0;
wpm.gas         = 0;
wpm.magnetic    = 0;
wpm.radiation   = 0;
wpm.viral       = 0;

for i = 1:numel(elemental_order)
    wpm.(elemental_order{i}) = elemental_values(i);
end
end
%% phase specific stats, phase 2

if wpb.phase2_present=='Y'
% critical chance
wpm.CC2 = wpb.CC2*(1+mod.CC);
% critical damage
wpm.CM2 = wpb.CM2*(1+mod.CM);
% status chance
wpm.SC2 = wpb.SC2*(1+mod.SC);

% base damage mods
wpm.impact2      = wpb.impact2*(1+mod.base_damage);
wpm.puncture2    = wpb.puncture2*(1+mod.base_damage);
wpm.slash2       = wpb.slash2*(1+mod.base_damage);
wpm.cold2        = wpb.cold2*(1+mod.base_damage);
wpm.electricity2 = wpb.electricity2*(1+mod.base_damage);
wpm.heat2        = wpb.heat2*(1+mod.base_damage);
wpm.toxin2       = wpb.toxin2*(1+mod.base_damage);
wpm.blast2       = wpb.blast2*(1+mod.base_damage);
wpm.corrosive2   = wpb.corrosive2*(1+mod.base_damage);
wpm.gas2         = wpb.gas2*(1+mod.base_damage);
wpm.magnetic2    = wpb.magnetic2*(1+mod.base_damage);
wpm.radiation2   = wpb.radiation2*(1+mod.base_damage);
wpm.viral2       = wpb.viral2*(1+mod.base_damage);

% calculate total base damage
total_base_damage2 = ...
wpm.impact2      + ...
wpm.puncture2    + ...
wpm.slash2       + ...
wpm.cold2        + ...
wpm.electricity2 + ...
wpm.heat2        + ...
wpm.toxin2       + ...
wpm.blast2       + ...
wpm.corrosive2   + ...
wpm.gas2         + ...
wpm.magnetic2    + ...
wpm.radiation2   + ...
wpm.viral2;

% might as well take care of physical damage mods here
wpm.impact2 = wpm.impact2*(1+mod.impact);
wpm.puncture2 = wpm.puncture2*(1+mod.puncture);
wpm.slash2 = wpm.slash2*(1+mod.slash);

% take care of elemental mods

if ~isempty(mod.elemental_order)
% first find what elementals the weapon has innately

elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(elemental_names)
    if wpm.([elemental_names{i} '2'])~=0
        elemental_order = [elemental_order elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([elemental_names{i} '2'])];
    end
end

% calculate all added elemental damage values from the mod and record them
% in correct order
elemental_values_from_mods = [];
for i = 1:numel(mod.elemental_order)
    elemental_values_from_mods = [elemental_values_from_mods ;...
        total_base_damage2*(mod.(mod.elemental_order{i}))];
end

% concatenate together elemental damage from mods and weapon itself
elemental_order = [mod.elemental_order elemental_order];
elemental_values = [elemental_values_from_mods ; elemental_values];

% combine elements with existing subfunction
[elemental_order,elemental_values] = ...
  combine_elementals (elemental_order,elemental_values);

% put elementals where they should be
wpm.cold2        = 0;
wpm.electricity2 = 0;
wpm.heat2        = 0;
wpm.toxin2       = 0;
wpm.blast2       = 0;
wpm.corrosive2   = 0;
wpm.gas2         = 0;
wpm.magnetic2    = 0;
wpm.radiation2   = 0;
wpm.viral2       = 0;

for i = 1:numel(elemental_order)
    wpm.([elemental_order{i} '2']) = elemental_values(i);
end
end
end

%% phase specific stats, phase 2

if wpb.phase3_present=='Y'
% critical chance
wpm.CC3 = wpb.CC3*(1+mod.CC);
% critical damage
wpm.CM3 = wpb.CM3*(1+mod.CM);
% status chance
wpm.SC3 = wpb.SC3*(1+mod.SC);

% base damage mods
wpm.impact3      = wpb.impact3*(1+mod.base_damage);
wpm.puncture3    = wpb.puncture3*(1+mod.base_damage);
wpm.slash3       = wpb.slash3*(1+mod.base_damage);
wpm.cold3        = wpb.cold3*(1+mod.base_damage);
wpm.electricity3 = wpb.electricity3*(1+mod.base_damage);
wpm.heat3        = wpb.heat3*(1+mod.base_damage);
wpm.toxin3       = wpb.toxin3*(1+mod.base_damage);
wpm.blast3       = wpb.blast3*(1+mod.base_damage);
wpm.corrosive3   = wpb.corrosive3*(1+mod.base_damage);
wpm.gas3         = wpb.gas3*(1+mod.base_damage);
wpm.magnetic3    = wpb.magnetic3*(1+mod.base_damage);
wpm.radiation3   = wpb.radiation3*(1+mod.base_damage);
wpm.viral3       = wpb.viral3*(1+mod.base_damage);

% calculate total base damage
total_base_damage3 = ...
wpm.impact3      + ...
wpm.puncture3    + ...
wpm.slash3       + ...
wpm.cold3        + ...
wpm.electricity3 + ...
wpm.heat3        + ...
wpm.toxin3       + ...
wpm.blast3       + ...
wpm.corrosive3   + ...
wpm.gas3         + ...
wpm.magnetic3    + ...
wpm.radiation3   + ...
wpm.viral3;

% might as well take care of physical damage mods here
wpm.impact3 = wpm.impact3*(1+mod.impact);
wpm.puncture3 = wpm.puncture3*(1+mod.puncture);
wpm.slash3 = wpm.slash3*(1+mod.slash);

% take care of elemental mods

if ~isempty(mod.elemental_order)
% first find what elementals the weapon has innately

elemental_order = [];
elemental_values = []; % column vector

% find all innate elementals of the weapon and record them
for i = 1:numel(elemental_names)
    if wpm.([elemental_names{i} '3'])~=0
        elemental_order = [elemental_order elemental_names(i)];
        elemental_values = [elemental_values ; wpm.([elemental_names{i} '3'])];
    end
end

% calculate all added elemental damage values from the mod and record them
% in correct order
elemental_values_from_mods = [];
for i = 1:numel(mod.elemental_order)
    elemental_values_from_mods = [elemental_values_from_mods ;...
        total_base_damage3*(mod.(mod.elemental_order{i}))];
end

% concatenate together elemental damage from mods and weapon itself
elemental_order = [mod.elemental_order elemental_order];
elemental_values = [elemental_values_from_mods ; elemental_values];

% combine elements with existing subfunction
[elemental_order,elemental_values] = ...
  combine_elementals (elemental_order,elemental_values);

% put elementals where they should be
wpm.cold3        = 0;
wpm.electricity3 = 0;
wpm.heat3        = 0;
wpm.toxin3       = 0;
wpm.blast3       = 0;
wpm.corrosive3   = 0;
wpm.gas3         = 0;
wpm.magnetic3    = 0;
wpm.radiation3   = 0;
wpm.viral3       = 0;

for i = 1:numel(elemental_order)
    wpm.([elemental_order{i} '3']) = elemental_values(i);
end
end
end

%% non phase specific stats

% take care of multishot
wpm.MS = wpb.MS*(1+mod.MS);

% take care of fire rate
wpm.FR = wpb.FR*(1+mod.FR);
wpm.charge_time = wpb.charge_time/(1+mod.FR);

% take care of RLS and RLT
wpm.RLS = wpb.RLS*(1+mod.RLS);
wpm.RLT = 1/wpm.RLS;

% take care of MAG
wpm.MAG = round(wpb.MAG*(1+mod.MAG));

% cake care of AMMO
wpm.AMMO = round(wpb.AMMO*(1+mod.AMMO));

% take care of faction stats
wpm.grineer = mod.grineer;
wpm.corpus = mod.corpus;
wpm.infested = mod.infested;
wpm.corrupted = mod.corrupted;
wpm.sentient = mod.sentient;

% take care of a few other non phase dependent stats
wpm.chance_to_enhance_crit = mod.chance_to_enhance_crit;
wpm.slash_on_crit = mod.slash_on_crit;

%% quantization calculation
if quantum % if quantization of weapon is enabled
    q = total_base_damage/16; % compute a quantum
    wpm.impact      = round(wpm.impact/q)*q;
    wpm.puncture    = round(wpm.puncture/q)*q;
    wpm.slash       = round(wpm.slash/q)*q;
    wpm.cold        = round(wpm.cold/q)*q;
    wpm.electricity = round(wpm.electricity/q)*q;
    wpm.heat        = round(wpm.heat/q)*q;
    wpm.toxin       = round(wpm.toxin/q)*q;
    wpm.blast       = round(wpm.blast/q)*q;
    wpm.corrosive   = round(wpm.corrosive/q)*q;
    wpm.gas         = round(wpm.gas/q)*q;
    wpm.magnetic    = round(wpm.magnetic/q)*q;
    wpm.radiation   = round(wpm.radiation/q)*q;
    wpm.viral       = round(wpm.viral/q)*q;
end

end