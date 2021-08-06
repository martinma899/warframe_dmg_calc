function [mods] = get_mods_array_from_build_v3 (build_str,delim,weapon_type,database_filename)
% take a string representing a build and then extract all the mods
% build_str: string, in the format representing a build
% weapon_type: string, 
% database_filename: string, filename of v3 database
% mods: output a cell array of mod objects

% read excel database 
[~,~,data] = xlsread(database_filename,weapon_type);
data = strip_nans(data);

% get each mod from build_str

% a column of data which is the designation of the mods in the build in order
designation_vec = split(build_str,delim); 

% check if we have the correct number of categories
if numel(designation_vec)~=9
  error('build string does not have 9 categories')
end

mods = [];

% iterate through every category and extract mods
for i = 1:numel(designation_vec)
  this_des_str = designation_vec{i};
  % first check if there is any mod in this category
  % if this mod designation is not 0 or empty
  if ~(strcmp(this_des_str,'0') || isempty(this_des_str))
    % iterate through every mod in this category
    for j = 1:numel(this_des_str)
      this_des = this_des_str(j);
      this_mod = get_mod_v3(i,this_des,data);
      mods = [mods;{this_mod}];
    end
  end
end

end