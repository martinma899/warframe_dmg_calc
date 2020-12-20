% temporary function used to convert mod_database.xlsx into a text format

clc;clear
init_seq;

% read xls mod database
[~,~,all] = xlsread('mod_database_2.xlsx','archgun','A1:AA28');
% create blank new text mod database
fid = fopen('archgun_mods','w');

mod_stat_names = all(1,2:end)
mod_names = all(2:end,1)
stat_array = all(2:end,2:end);

for i = 1:size(stat_array,1) % iterate through all mod names
    this_mod_name = mod_names{i};
    this_mod_name(this_mod_name==' ') = '_'; % replace space with _
    fprintf(fid,'%26s ',this_mod_name); % print this mod's name
    this_mod_stats = all(i,2:end);
    for j = 1:size(stat_array,2) % iterate through all stat entries of this mod
        this_stat = stat_array{i,j};
        if ~isnan(this_stat) % if this stat is not nan
            fprintf(fid, '%15s ', mod_stat_names{j}); % print mod stat name
            fprintf(fid, '%5.2f ', this_stat); % print stat itself
        end
    end
    fprintf(fid,'\n'); % start new line
end

fclose('all');
wrap_up;