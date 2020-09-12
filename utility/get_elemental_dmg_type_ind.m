function [dmg_type_ind] = get_elemental_dmg_type_ind(fields)
% this function takes a cell array 'fields' which is all field names of a
% weapon object and returns an index array dmg_type_ind that is the index
% ordering damage types from impact to viral in the following order: 
% impact puncture slash cold electricity heat toxin blast corrosive gas
% magnetic radiation viral
ordered_damage_type_name_field = {'cold'...
  'electricity' 'heat' 'toxin' 'blast' 'corrosive' 'gas' 'magnetic' ...
  'radiation' 'viral'};
dmg_type_ind = zeros(1,10);
for i = 1:10
  dmg_type_ind(i) = find(strcmp(ordered_damage_type_name_field{i},fields));
end

end