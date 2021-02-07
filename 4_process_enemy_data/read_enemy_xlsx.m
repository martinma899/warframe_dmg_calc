function [enemy] = read_enemy_xlsx(name,variant1,variant2)
% reads the enemy_database.xlsx
% outputs enemy object

% name: enemy name, enemy_database.xlsx column 1
% variant1: enemy variant 1, enemy_database.xlsx column 2
% variant2: enemy variant 2, enemy_database.xlsx column 3

% read the entire database
[~,~,data] = xlsread('enemy_database.xlsx');

data = strip_nans(data);

% extract field names
fieldnames = data(1,:);

% iterate through the entire database and look for the enemy
% initialize boolean flags
namematch = false;
variant1match = false;
variant2match = false;
finalbool = false;
for i = 2:size(data,1)
    % check namematch
    namematch = strcmp(data{i,1},name);
    % check variant1 match
    if isempty(variant1)
        if isnan(data{i,2})
            variant1match = true;
        end
    else
        variant1match = strcmp(data{i,2},variant1);
    end
    % check variant2 match
    if isempty(variant2)
        if isnan(data{i,3})
            variant2match = true;
        end
    else
        variant2match = strcmp(data{i,3},variant2);
    end
    
    finalbool = all([namematch,variant1match,variant2match]);
    if finalbool
        enemy = cell2struct(data(i,:),fieldnames,2);
        break;
    else
        namematch = false;
        variant1match = false;
        variant2match = false;
        finalbool = false;
    end
end

if ~finalbool
    error('enemy %s %s %s not found',name,variant1,variant2);
end

end

