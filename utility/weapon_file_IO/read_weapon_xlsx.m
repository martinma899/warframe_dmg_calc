function [wpb] = read_weapon_xlsx(filename)
% filename is weapon_name.xlsx
[~,~,data] = xlsread(filename);
% make a cell array of field names
field_names = data(:,1);
% find index of field name "damage_phase"
damage_phase_field_index = strcmp('damage_phase',field_names);
% find damage phase
damage_phase = data{damage_phase_field_index,2};

% the loop through all the fields
for i = 1:size(data,1)
  % the loop through all damage phases
  field_vec = [];
  for j = 2:(2+damage_phase-1)
    if ~isnan(data{i,j})
    field_vec = [field_vec data{i,j}];
    else
      break;
    end
  end
  wpb.(data{i,1}) = field_vec;
end