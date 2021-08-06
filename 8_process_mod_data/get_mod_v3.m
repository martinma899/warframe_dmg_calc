function [mod] = get_mod_v3 (mod_category,mod_designation,database_cell)
% this function gets a mod from mod_database_v3.xlsx
% input: 
% mod_category: double, mod category
% mod_designation: char, mod designation within the category
% weapon_type: char, name of the sheet in the xlsx that designates weapon
% type
% database_name : char, filename of weapon database v3 spreadsheet

% get database category column
category_vec = cell2mat(database_cell(:,1));

% get database designation column
designation_vec = database_cell(:,2);
% make all designation_vec entries characters
for i = 1:numel(designation_vec)
  if ~ischar(designation_vec{i})
    designation_vec{i} = num2str(designation_vec{i});
  end
end

% find the row index of the mod
row_ind = (category_vec==mod_category)&strcmp(mod_designation,designation_vec);

% get everything for the mod object
% get data row
mod_data_row = database_cell(row_ind,:);
% get rid of nans possibly at the end of this row
mod_data_row = strip_nans(mod_data_row);

% populate the data into mod structure
% first record the name of the mod
mod.name = mod_data_row{4};
% record the category and designation of the mod
mod.category = mod_data_row{1};
mod.designation = mod_data_row{2};
% record mod comment
mod.comment = mod_data_row{3};

% record every stat of the weapon

for i = 5:2:(numel(mod_data_row)-1)
  mod.(mod_data_row{i})=mod_data_row{i+1};
end


end
