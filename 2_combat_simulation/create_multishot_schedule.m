function [schedule] = create_multishot_schedule(weapon, firing_schedule)
%{
This function takes a firing schedule that looks like: 

firing time, round #, magazine #
...

and produces an enhanced schedule where each round fired is expanded into
multiple rounds based on multishot property of the weapon. 
The process is random, therefore each time the function is run, the output
schedule will be different. 

input "weapon" is weapon object. We only use the MS property. 

firing_schedule is the output produced by create_firing_schedule function. 

output "schedule" adds an additional row which is multishot # of one round.

firing time, round #, magazine #, multishot #, 
...

%}

schedule = [];

MS = weapon.MS; 

for i = 1:size(firing_schedule,1) %iterate through every element of firing schedule
    % roll multishot random variable
    high_roll = ceil(MS); % high multishot roll
    low_roll = floor(MS); % low multishot roll

    P_high = MS-low_roll; % probability of a high roll
    P_low = 1-P_high; % probability of a low roll
    % construct rollRandVariable input struct
    in.x = [high_roll low_roll];
    in.p = [P_high P_low];
    
    % roll this MS
    this_MS = rollRandVariable(in);
    
    % schedule as many projectiles as this_MS for a single round fired
    for j = 1:this_MS
        schedule = [schedule; [firing_schedule(i,:) j]];
    end
    
end

end