function [schedule] = create_master_schedule(weapon,varargin)

% master function that uses all the sub-functions to create one final
% firing schedule. 

%{
input "weapon" is the modded weapon object. 
input "varagin" specify what is the termination condition for the schedule.
left blank, the schedule will terminate at 30 seconds or weapon running out
 of ammo, whichever one comes first. exit_cond = 0
input 'time', <termination time> specifies how long to fire. exit_cond = 1 
input 'round', <total rounds> specifies how many rounds to fire. exit_cond
= 2
input 'magazine', <total magazine> specifies how many magazines to fire.
exit_cond = 3
input 'all' specifies termination when weapon is completely out of ammo.
exit_cond = 4
%}

% determine termination condition
if isempty(varargin)
    exit_cond = 0;
    tf = 30;
    rf = weapon.AMMO;
    mf = nan;
else
    exit_cond_type = varargin{1};
    switch exit_cond_type
        case 'time'
            exit_cond = 1;
            tf = varargin{2};
            rf = nan;
            mf = nan;
        case 'round'
            exit_cond = 2;
            tf = nan;
            rf = varargin{2};
            mf = nan;
        case 'magazine'
            exit_cond = 3;
            tf = nan;
            rf = nan;
            mf = varargin{2};
        case 'all'
            exit_cond = 4;
            tf = nan;
            rf = weapon.AMMO;
            mf = nan;
        otherwise
            exit_cond = 0;
            tf = 30;
            rf = weapon.AMMO;
            mf = nan;
    end
end


firing_schedule = create_firing_schedule(weapon,exit_cond, tf, rf, mf);

multishot_schedule = create_multishot_schedule(weapon, firing_schedule);

damage_phase_schedule = create_damage_phases(weapon, multishot_schedule);

crit_schedule = create_crit_schedule(weapon, damage_phase_schedule);

schedule = create_status_schedule(weapon, crit_schedule);

end