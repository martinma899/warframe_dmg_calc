function [schedule] = create_damage_phases(weapon, multishot_schedule)
%{
This function that takes a multishot schedule that looks like: 

firing time, round #, magazine #, multishot #, 
...

and splits damage phase instances on top of it, creating an enhanced damage
phase schedule that looks like:

firing time, round #, magazine #, multishot #, damage phase #
...

the schedule will be sorted by time. 

%}

% boolean variables to tell if weapon has phase 2 or 3 damage
phase2bool = weapon.PHASE2 == 'Y';
phase3bool = weapon.PHASE3 == 'Y';

if ~phase2bool && ~phase3bool % if weapon has neither phase 2 nor 3
    schedule = [multishot_schedule ones(size(multishot_schedule,1),1)]; % add damage phase # which is all 1's
    return; 
end

schedule = []; % initialize empty schedule output

for i = 1:size(multishot_schedule,1) % iterate through every row
    damage_element = multishot_schedule(i,:); % extract this damage element
    % add first damage phase
    schedule = [schedule; [damage_element 1]];
    % add stage 2 delay
    damage_element(1) = damage_element(1)+weapon.DELAY2;
    % add stage 2
    schedule = [schedule; [damage_element 2]];
    % check if there is a stage 3 
    if phase3bool
        % add stage 3 delay
        damage_element(1) = damage_element(1)+weapon.DELAY3;
        % add stage 3
        schedule = [schedule; [damage_element 3]];
    end
end

[~,sortID] = sort(schedule(:,1),'ascend');
schedule = schedule(sortID,:);

end