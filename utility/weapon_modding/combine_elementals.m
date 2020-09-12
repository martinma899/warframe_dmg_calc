function [elemental_names_out,elemental_values_out] = ...
  combine_elementals (elemental_names_in, elemental_values_in)
% initialize output variables
elemental_names_out = [];
elemental_values_out = [];
% use the unique function to pick out unique elemental types in that order
% and return index IC
[unique_elemental_names,~,IC] = unique(elemental_names_in,'stable');
% sum up all occurances of the same elemental type under the same variable
% in the array
uniquenumel = numel(unique_elemental_names);
for i = 1:uniquenumel
  unique_elemental_values(i,:) = sum(elemental_values_in(IC==i,:),1);
end
% now do the elemental combination algorithm
% first, run through the list and pick out combined elemental types

deleteind = [];
for i = 1:uniquenumel
  if ~any(strcmp(unique_elemental_names{i},{'cold' 'electricity' 'heat' 'toxin'}))
    deleteind = [deleteind i];
    elemental_names_out = [elemental_names_out unique_elemental_names(i)];
    elemental_values_out = [elemental_values_out ; unique_elemental_values(i,:)];
  end
end
unique_elemental_names(deleteind) = [];
unique_elemental_values(deleteind,:) = [];

% second, combine the list of base elementals left over and combine them
% into the output list
% if there is an odd number of base elementals then the last one is
% automatically left hanging and sent directly to the output pile
if mod(numel(unique_elemental_names),2)==1
  elemental_names_out = [unique_elemental_names(end) elemental_names_out];
  elemental_values_out = [unique_elemental_values(end,:) ; elemental_values_out];
  unique_elemental_names(end) = [];
  unique_elemental_values(end,:) = [];
end

% if there are base elementals left there to be combined
if ~isempty(unique_elemental_names)
n = 1;
while true
  % combine every two of them in order
  new_combined_type = dual_elemental_combo (unique_elemental_names(n:n+1));
  new_combined_value = sum(unique_elemental_values(n:n+1,:),1);
  % if this current type of combined elemental already exists
  if ismember(new_combined_type,elemental_names_out)
    elemental_values_out(strcmp(new_combined_type,elemental_names_out),:) = ...
    elemental_values_out(strcmp(new_combined_type,elemental_names_out),:) + ...
      new_combined_value;
  else
    elemental_names_out = [{new_combined_type} elemental_names_out];
    elemental_values_out = [new_combined_value ; elemental_values_out];
  end
  n = n+2;
  if n>numel(unique_elemental_names)
    break;
  end
end
end

end