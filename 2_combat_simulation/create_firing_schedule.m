function [schedule] = create_firing_schedule(weapon,exit_cond, tf, rf, mf)
%{
This function produces a firing schedule for a weapon. 
output "schedule" denotes the times at which shots are fired. 
Can take care of burst weapons and weapons that consume multiple rounds per
shot.
In theory a list of time stamps will do, but we will also record which
round this shot is in the magazine, and which magazine this shot is from. 
These may be useful later down the line. 
"schedule" is an nx3 array. Each row has the following format:

firing time, round #, magazine #

It may look something like this:

  0 1 1
0.1 2 1
0.2 3 1
0.4 4 1
2.4 1 2
2.5 2 2
...

%}

firing_delay = weapon.BURST_COUNT/weapon.FR; % compute firing delay

magc = 1; % initialize mag count
roundc = 1; % initialize overall round count
roundcmag = 1; % initialize round count in magazine
round_left_in_mag = weapon.MAG; % initialize rounds left in mag

t = 0;

schedule = [];

while true
    t = t+weapon.CHARGE_TIME; % wait for charge
    for i = 1:weapon.BURST_COUNT % iterate through firing burst weapon rounds
        schedule = [schedule;[t roundcmag magc]]; % record weapon fire
        roundc = roundc+1; % add to total round count
        roundcmag = roundcmag+weapon.AMMO_CONS; % increment round ID in this mag
        round_left_in_mag = round_left_in_mag-weapon.AMMO_CONS; % subtract from rounds left in mag
        if round_left_in_mag == 0 % if no rounds left
            break; % then break out of burst firing loop and go to reload
        end
    end
    t = t+firing_delay; % firing delay
    
    
    % check if mag is empty
    if round_left_in_mag < weapon.AMMO_CONS % if empty
        roundcmag = 1; % reset round ID
        magc = magc+1; % add to mag ID
        round_left_in_mag = weapon.MAG; % fill magazine
        t = t+weapon.RLT; % add to reload time
    end
    
        % check exit condition
    switch exit_cond
        case 0
            if t>=tf||roundc>rf
                break
            end
        case 1 
            if t>=tf
                break
            end
        case 2
            if roundc>rf
                break
            end
        case 3
            if magc>mf
                break
            end
        case 4 
            if roundc>rf
                break
            end
    end
    
end








































end