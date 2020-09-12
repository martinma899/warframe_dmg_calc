function [enemy] = read_enemy_line(fieldnames,enemy_data)
% fieldnames is a cell array of fieldnames of the enemy
% enemy_data is a cell array of corresponding enemy data
for i = 1:numel(fieldnames)
  enemy.(fieldnames{i})=enemy_data{i};
end
end