function [schedule] = create_crit_schedule(weapon, damage_phase_schedule)
%{
This function takes a damage phase schedule that looks like: 

firing time, round #, magazine #, multishot #, damage phase #
...

and adds one more data column to the schedule which is the crit 
tier. 

If the weapon has any slash on crit stat, the function will add one more
colum that indicates a slash status type (3) or no status proc (0). 

New schedule looks like:
firing time, round #, magazine #, multishot #, damage phase #, crit tier,
(slash) status
...


%}

schedule = [];

for i = 1:size(damage_phase_schedule,1) % iterate through every row
    this_damage_instance = damage_phase_schedule(i,:); % get this row of damage instance
    
    % get correct information from weapon
    switch this_damage_instance(5)
        case 1
            CC = weapon.CC;
            CM = weapon.CM;
            SC = weapon.SC;
            damage_breakdown = ...
                [weapon.IMPACT ...
                weapon.PUNCTURE ...
                weapon.SLASH ...
                weapon.COLD ...
                weapon.ELECTRICITY ...
                weapon.HEAT ...
                weapon.TOXIN ...
                weapon.BLAST ...
                weapon.CORROSIVE ...
                weapon.GAS ...
                weapon.MAGNETIC ...
                weapon.RADIATION ...
                weapon.VIRAL];
        case 2
            CC = weapon.CC2;
            CM = weapon.CM2;
            SC = weapon.SC2;
            damage_breakdown = ...
                [weapon.IMPACT2 ...
                weapon.PUNCTURE2 ...
                weapon.SLASH2 ...
                weapon.COLD2 ...
                weapon.ELECTRICITY2 ...
                weapon.HEAT2 ...
                weapon.TOXIN2 ...
                weapon.BLAST2 ...
                weapon.CORROSIVE2 ...
                weapon.GAS2 ...
                weapon.MAGNETIC2 ...
                weapon.RADIATION2 ...
                weapon.VIRAL2];
        case 3
            CC = weapon.CC3;
            CM = weapon.CM3;
            SC = weapon.SC3;
            damage_breakdown = ...
                [weapon.IMPACT3 ...
                weapon.PUNCTURE3 ...
                weapon.SLASH3 ...
                weapon.COLD3 ...
                weapon.ELECTRICITY3 ...
                weapon.HEAT3 ...
                weapon.TOXIN3 ...
                weapon.BLAST3 ...
                weapon.CORROSIVE3 ...
                weapon.GAS3 ...
                weapon.MAGNETIC3 ...
                weapon.RADIATION3 ...
                weapon.VIRAL3];
    end
    
    % construct crit random variable
    crit_high_tier = ceil(CC); % high crit roll
    crit_low_tier = floor(CC); % low crit roll

    P_high = CC-crit_low_tier; % probability of a high roll
    P_low = 1-P_high; % probability of a low roll
    
    crit.x = [crit_high_tier crit_low_tier];
    crit.p = [P_high P_low];
    
    % roll crit tier 
    crit_tier_outcome = rollRandVariable(crit);
    
    % if it's a crit
    if crit_tier_outcome > 0
        % construct crit enhancement random variable
        crit_enh.x = [0 1];
        crit_enh.p = [1-weapon.ENHANCE_CRIT weapon.ENHANCE_CRIT];
        
        % roll crit enhancement
        crit_enh_outcome = rollRandVariable(crit_enh);
        
        % add crit enhancement (0 or 1) to crit tier
        crit_tier_outcome = crit_tier_outcome + crit_enh_outcome;
    end
    
    % concatenate crit tier field to this_damage_instance
    this_damage_instance = [this_damage_instance crit_tier_outcome];
    
    % If weapon is a primary, slash on crit stat is not 0
    if strcmp(weapon.SLOT,'primary') && weapon.SLASH_ON_CRIT~=0
        if crit_tier_outcome>0 % if this is a crit
        % add one more status field for possible slash on crit
        % construct slash on crit random variable
        slash_on_crit.x = [0 3];
        slash_on_crit.p = [1-weapon.SLASH_ON_CRIT weapon.SLASH_ON_CRIT];
        
        % roll slash on crit, outcome is 0 or 3
        slash_on_crit_outcome = rollRandVariable(slash_on_crit);
        
        else
            slash_on_crit_outcome = 0;
        end
        % concatenate slash on crit outcome (0 or 3) to
        % this_damage_instance
        this_damage_instance = [this_damage_instance slash_on_crit_outcome];
    end
    
    
    
    % put them in the final schedule
    schedule = [schedule; this_damage_instance];
end

end

















