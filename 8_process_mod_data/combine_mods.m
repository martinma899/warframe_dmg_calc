function [mod_rest_of_stats_combined, elemental_names, elemental_modifiers]...
    = combine_mods(mods)
% combine a cell array of mod objects into a compiled mod with all stats 
% other than elemental damage stats

% mods: cell array of mod objects
% mod_rest_of_stats_combined: combined large mod of all the mods, with
% exception of elemental mods. 
% elemental_names: cell array of all the elemental names that appeared, in
% the input order
% elemental_modifiers: numerical array of all the elemental modifiers that
% appeared, in the input order

% initialize everything
mod_rest_of_stats_combined = struct(); 
elemental_names = [];
elemental_modifiers = [];

% a list of all elemental names used to identify such modifiers
all_elemental_names = {...
    'COLD',...
    'ELECTRICITY',...
    'HEAT',...
    'TOXIN',...
    'VIRAL',...
    'RADIATION',...
    'MAGNETIC',...
    'GAS',...
    'CORROSIVE',...
    'BLAST'};

for i = 1:numel(mods) % iterate through every mod
    fields_of_big_mod = fieldnames(mod_rest_of_stats_combined); % get field names that currently the combined mod has
    this_mod = mods{i}; % get this mod
    this_mod = rmfield(this_mod,'name'); % remove name field for ease of processing
    fields_of_this_mod = fieldnames(this_mod); % get field names of this mod
    for j = 1:numel(fields_of_this_mod) % iterate through every field this mod has
        this_field_name = fields_of_this_mod{j};
        % first check if this is an elemental stat
        if any(strcmp(this_field_name,all_elemental_names))
            % if this is an elemental stat
            % put the elemental name in elemenal_names
            elemental_names = [elemental_names {this_field_name}];
            % put the elemental stat in elemental_modifiers
            elemental_modifiers = [elemental_modifiers this_mod.(this_field_name)];
        else
            if any(strcmp(this_field_name,fields_of_big_mod))
                % if this stat is already logged by the big mod
                % then add this stat to it
                mod_rest_of_stats_combined.(this_field_name) = ...
                mod_rest_of_stats_combined.(this_field_name)+this_mod.(this_field_name);
            else % if this stat is not logged
                % add the new stat to the mod
                mod_rest_of_stats_combined.(this_field_name) = this_mod.(this_field_name);
            end
        end
    end
end

end

