function [mods,mods_ind,comments] = read_mod_selection(mod_input_file_name)

% reads mods selection from a text file of a certain format. 
% input 1: mod_input_file_name is the complete file name to the text input
% mod selection file. 
% output: mods is the entire mod arsenal. 
% mods_ind is a struct with fields: mandatory, flexible and excluded. 
% comments is just a cell array of some comment strings. 

fid = fopen(mod_input_file_name);

line = [];

mods = [];
mod_count = 0;

mods_ind.mandatory = [];
mods_ind.flexible = [];
mods_ind.excluded = [];

comments = [];

current_input_type = [];
bad_characters = char([10 13]); % weird tabs and spaces are not allowed
% blank_mod = struct('name','','DM',0,'EM',0,'IM',0,'PM',0,'SM',0,'MM',0,'FDM',0,'FRM',0,...
%   'CCM',0,'CMM',0,'RLSM',0,'mM',0);

while true
  line = fgetl(fid); % get the line for this iteration
  if line==-1
    break; % if we've reached the end of the file then break out of the loop
  end
  if isempty(line)
    continue; % if a line has nothing but end of line characters then discount it
  end
  tempstr = line; tempstr(tempstr==' ') = [];
  if strcmp(tempstr,'-->MandatoryMods<--')
    current_input_type = 'm';continue;
  elseif strcmp(tempstr,'-->FlexibleMods<--')
    current_input_type = 'f';continue;
  elseif strcmp(tempstr,'-->ExcludedMods<--')
    current_input_type = 'e';continue;
  elseif strcmp(tempstr,'-->Comments<--')
    current_input_type = 'c';continue;
  elseif isempty(tempstr)
    continue; % if a line has only spaces then discount it
  end
  
  if current_input_type~='c' % if we are not in comment mode
    % break up the line. Format: modname multiplier value multiplier value
    % ... etc etc
    this_mod_str_arr = strsplit(line,' '); % split the line into individual strings
%     if isempty(this_mod_str_arr{1})
%       this_mod_str_arr(1) = [];
%     end
%     if isempty(this_mod_str_arr{end})
%       this_mod_str_arr(end) = [];
%     end
    % take away empty string entries
    this_mod_str_arr(strcmp('',this_mod_str_arr)) = [];
    this_mod = []; % make a copy of this mod
    this_mod.name = this_mod_str_arr{1}; % give this mod a name
    for i = 2:2:(numel(this_mod_str_arr)) % assign all of the multipliers
      this_mod.(this_mod_str_arr{i}) = str2double(this_mod_str_arr{i+1});
    end
    mod_count = mod_count+1; % +1 to mod count
    mods = [mods {this_mod}]; % put this into the total mod arsenal cell array regardless
    % and record the mod count index for each category
    switch current_input_type
      case 'm'
        %mandatory_mods_arr = [mandatory_mods_arr this_mod];
        mods_ind.mandatory = [mods_ind.mandatory mod_count];
      case 'f'
        %flexible_mods_arr = [flexible_mods_arr this_mod];
        mods_ind.flexible = [mods_ind.flexible mod_count];
      case 'e'
        %excluded_mods_arr = [excluded_mods_arr this_mod];
        mods_ind.excluded = [mods_ind.excluded mod_count];
    end
  else % if we are in comment mode
    comments = [comments;{line}];
  end
end

fclose(fid);

end