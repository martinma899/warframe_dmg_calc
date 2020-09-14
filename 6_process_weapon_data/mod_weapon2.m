function [wpm] = mod_weapon2(wpb,mod,quantum)
% wpb: base weapon. 
% mod: one big mod of all mods combined.
% quantum: true or false, indicating whether wpm will be quantized or not. 

% First step: 
% start applying everything but elemental mods

% base damage mods
wpm = wpb;
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
wpm.impact = wpm.impact+total_base_damage*mod.impact;
wpm.puncture = wpm.puncture+total_base_damage*mod.puncture;
wpm.slash = wpm.impact+total_base_damage*mod.slash;

% take care of elemental mods
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

% quantization calculation
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