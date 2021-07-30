function [wpb] = read_weapon_xlsx_v2(weapon_name,variant_name,alt_fire,sheet_name)
% read entire weapon database
[~,~,data] = xlsread('weapon_database_v2.xlsx',sheet_name);

% remove nans
data = strip_nans(data);

% make a cell array of all weapon names
all_weapon_names = data(:,1);

% find the index of rows with the same weapon name
weapon_name_ind = comp_cell_arr(data(:,1),weapon_name);
% find the index of rows with the same weapon variant name
if isempty(variant_name); variant_name = nan; end
variant_name_ind = comp_cell_arr(data(:,2),variant_name);
% find the index of rows with the same alt fire
if isempty(alt_fire); alt_fire = nan; end
alt_fire_name_ind = comp_cell_arr(data(:,3),alt_fire);
% combine for a possible weapon index
weapon_ind = find(weapon_name_ind&variant_name_ind&alt_fire_name_ind);

% if weapon does not exist
if isempty(weapon_ind)
    str = sprintf('Weapon named %s is not found in database',weapon_name);
    error(str);
elseif size(weapon_ind)>1
  error('more than one weapon match criteria, specify correct variant_name and alt_fire');
end

% get the row of weapon data
weapon_data = data(weapon_ind,:);
% make a cell array of field names
field_names = data(1,:);

% iterate through and find field name that is lower case. Do not put this
% in the weapon struct.
exclude_ind = [];
for i = 1:numel(field_names)
  this_field_name = field_names{i};
  if any(this_field_name>=97 & this_field_name<=122)
    exclude_ind = [exclude_ind i];
  end
end
weapon_data(exclude_ind) = [];
field_names(exclude_ind) = [];

% fill data from database to weapon
for i = 1:numel(field_names)
wpb.(field_names{i})=weapon_data{i};
end

end