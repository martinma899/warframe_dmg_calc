function combined_mod = read_and_combine_mods (mods_arr,weapon_type)
% a function that reads a selection of mods by their name from the central
% mod database and combines them into a single mod object for use in later
% weapon modding. 
% mods_arr: a cell array of mod names
% combined_mod: the final big combined mod 
% weapon_type: string. rifle, pistol, shotgun, archgun

% read mod database
[~,~,data] = xlsread('mod_database.xlsx',weapon_type);

% get mod names
mod_names = data(:,1);

% iterate through all mods and locate them in "data"
for i = 1:numel(mods_arr)
    % get the name of this mod
    this_mod_name = mods_arr{i};
    % get the index of this mod in mod database
    this_mod_index = find(strcmp(mod_names,this_mod_name));
    % if this mod is not found, error
    if isempty(this_mod_index)
        str = sprintf('Mod named %s is not found in database',this_mod_name);
        error(str);
    end
    % add the index of this mod to array
    this_mod_index_arr(i) = this_mod_index;
end

% produce a numerical array called all_mod_stats that contains all stats of
% all mods
% most of the stats will be 0 as most mods have 1 or 2 stats
all_mod_stats = cell2mat(data(this_mod_index_arr,2:end));
all_mod_stats(isnan(all_mod_stats)) = 0;

% record the order of elemental mods
% (note that the logic cannot discern order of elementals if multiple ones
% are present on a mod, like a riven
% currently rivens like that need to be implemented as several mods
% this needs to be improved in the future)

% create list of elemental damage name
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

% get mod field names
mod_fieldnames = data(1,:);

% create cell array called elemental_order
elemental_order = [];

for i = 1:numel(mods_arr) % iterate through every mod
    for j = 1:numel(elemental_names) % iterate through every element
        % get this element name
        this_element_name = elemental_names{j};
        % get the index of this element in all_mod_stats array
        this_element_index = find(strcmp(mod_fieldnames,this_element_name))-1;
        % check if this element of this mod is greater than 0
        element_present = all_mod_stats(i,this_element_index)>0;
        % if element is present, add it to elemental_order array only if it
        % has not appeared before
        if element_present 
            if isempty(find(strcmp(elemental_order,this_element_name)))
            elemental_order = [elemental_order {this_element_name}];
            end
        end
    end
end

% combine all mods into a big mod
mod_stats_combined = sum(all_mod_stats,1);


% combined mod
for i = 1:numel(mod_stats_combined)
    combined_mod.(mod_fieldnames{i+1})=mod_stats_combined(i);
end
% add elemental order in there

combined_mod.elemental_order = elemental_order;
end