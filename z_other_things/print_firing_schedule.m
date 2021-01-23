function print_firing_schedule(schedule)
% Prints a compact firing schedule.

% Input schedule is a mxn array where each row is a damage instance and
% every column is a property field of that damage instance. 
% Columns (from left to right) are:

% 1. Time
% 2. Round number in magazine
% 3. Magazine number we are currently on
% 4. Number of multishot projectile in this shot
% 5. Damage phase of this projectile
% 6. Crit tier of this damage instance
% 7. Status effect 1
% 8. Status effect 2
% .. Status effect .. 

% Schedule doesn't have to have all columns. For as many columns as it has,
% the function will title them in the above order while skipping the rest.

% generate the appropriate array of title strings based on how many columns
% we actually have
title_array = {'     t' 'ROUN' ' MAG' '  MS' 'PHAS' 'CRIT'};
num_cols = size(schedule,2);
if num_cols < 6
    title_array = title_array(1:num_cols);
elseif num_cols > 6
    count = 1;
    for i = 1:(num_cols-6)
        this_title = sprintf(' SE%d',count);
        title_array = [title_array {this_title}];
        count = count+1;
    end
end

% print title array
for i = 1:num_cols
    fprintf('%s ',title_array{i});
end
fprintf('\n');

% start printing every row
for i = 1:size(schedule,1) % for every fow
    for j = 1:num_cols % iterate through every column and print
    switch j
        case 1 % if column is 1, print special time format
        fprintf('%6.2f ',schedule(i,j));
        otherwise % for all others print integer format
        fprintf('%4d ',schedule(i,j));
    end
    end
    fprintf('\n');
end






end

