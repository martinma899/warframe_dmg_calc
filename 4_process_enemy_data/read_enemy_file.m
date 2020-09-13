function [enemy_struct_cell_array] = read_enemy_file (filename,read_type)
% filename is full file name to an enemy file
% an enemy file is an xlsx file with multiple enemies of the same type but
% different variations
% read_type is a cell array that specifies which variation of enemy in that
% list should be read in. 'default' specifies the default variation. 'all'
% specifies all variations.

% first read the excel worksheet into raw.
[~,~,raw] = xlsread(filename);
% the first row are the fieldnames.
fieldnames = raw(1,:);

% if read_type is a string input, then make it contained in a cell to make
% subsequent programming easier
if isstr(read_type)
  read_type = {read_type};
end

% initialize output structure array
enemy_struct_cell_array = [];

% find where the 'variant' column is so that we can easily access
% information in that colum
variant_ind = strcmp('variant',fieldnames);


% start to read in enemies according to read_type


if strcmp(read_type{1},'all')
  % if the first of read_type cell array is 'all'
  % simply read in all enemy types
  for i = 1:numel(raw(2:end,variant_ind))
    this_enemy = read_enemy_line(fieldnames,raw(i+1,:));
    enemy_struct_cell_array = [enemy_struct_cell_array {this_enemy}];
  end
  return;
end

for i = 1:numel(read_type)
  % extract the string of this enemy type of all specified
  this_read_type = read_type{i};
  % initialize a flag for whether this enemy type is actually listed
  % enemy_type_exist = false;
  % if this type is 'default', then find all cells in the variant column
  % that are nan and read those enemies in as the default enemy variant.
  if strcmp(this_read_type,'default')
    % because there isn't a function that can search out nan in cell
    % arrays, manually search it with a for loop.
    type_existence_flag = false;
    for k = 1:numel(raw(2:end,variant_ind))
      % if a nan in enemy type is found, read that line of data into
      % this_enemy
      if isnan(raw{k+1,variant_ind})
        this_enemy = read_enemy_line(fieldnames,raw(k+1,:));
        enemy_struct_cell_array = [enemy_struct_cell_array {this_enemy}];
        type_existence_flag = true;
        break;
      end
    end
    % if no nan is spotted
    if ~type_existence_flag
      fprintf('enemy type ''%12s'' for enemy ''%12s'' does not exist and is not read in.\n',this_read_type,raw{2,1});
    end
  else
    % if this type is not 'default'
    this_enemy_ind = find(strcmp(this_read_type,raw(2:end,variant_ind)));
    % if this enemy type is not found
    if isempty(this_enemy_ind)
      fprintf('enemy type ''%12s'' for enemy ''%12s'' does not exist and is not read in.\n',this_read_type,raw{2,1});
    else
      % if this enemy type is found, read it in
      this_enemy = read_enemy_line(fieldnames,raw(this_enemy_ind+1,:));
      enemy_struct_cell_array = [enemy_struct_cell_array {this_enemy}];
    end
  end
end

end