function [wpb] = read_weapon_xlsx(weapon_name)
% read entire weapon database
[~,~,data] = xlsread('weapon_database.xlsx');

% make a cell array of all weapon names
all_weapon_names = data(1,:);
% find the column index of the weapon
weapon_ind = find(strcmp(data(1,:),weapon_name));
% if weapon does not exist
if isempty(weapon_ind)
    str = sprintf('Weapon named %s is not found in database',weapon_name);
    error(str);
end

% make a cell array of field names
field_names = data(:,1);

% fill data from database to weapon
for i = 1:numel(field_names)
wpb.(field_names{i})=data{i,weapon_ind};
end

end