function [enemy_arr,tarr] = sim_combat(wp,enemy,dmghtm)
% input 1: wp, a weapon struct according to the convention of this project.
% The weapon should be fully modded.
% input 2: enemy, an enemy struct according to the convention of this
% project. The enemy should already be leveled properly. 
% output 1: out_struct, a struct of enemies at each time snapshot
% field 1: t, the time stamps. 
% field 2: enemy, a struct array of the enemy at every time stamp. 
% field 3: event, a string cell array describing what is happening at each
% time stamp. 

% emergency: in the mod weapon function, add toxin, electricity, heat,
% slash multipliers for status dot application calculation. 

% notes to self: 
% damage object arrays separated by elemental types in main schedules 
% 1st index direction is always shot by shot direction
% 2nd index direction is always damage type direction

% enemy is not dead;
enemy_dead = false;

% initialize outputs
enemy_arr = enemy;
tarr = 0;

% get weapon fiel ds
wpfields = fields(wp);
% get the index array that tells which fields are damage type arrays
dmg_type_ind = get_dmg_type_ind(wpfields);
                                           
% do stuff do stuff before stuff begin
clip_schedule = [];
% electricity_procs = [];
% heat_procs = [];
% toxin_procs = [];
% slash_procs = [];
% corrosive_procs = [];
% viral_procs = [];

% start time
start_time = 0;

wp_currrent_mag = wp.MAG;
wp_firing_dt = 1/wp.FR;

% find faction multiplier (total)
faction_multi = wp.(wpfields{strcmp(wpfields,enemy.faction)});

% take care of multishot RNG work
if ceil(wp.MS)==floor(wp.MS)
  MS = wp.MS;
  MSRand = false;
else
  MSRandVar.x = [floor(wp.MS) ceil(wp.MS)];
  MSRandVar.p = [1-(wp.MS-floor(wp.MS)) wp.MS-floor(wp.MS)];
  MSRand = true;
end

% take care of crit RNG work
base_crit_tier = floor(wp.CC);
CritRandVar.x = [1 0];
CritRandVar.p = [wp.CC-floor(wp.CC) 1-(wp.CC-floor(wp.CC))];

% take care of status RNG work
StatusRandomVar = genStatusRandomVar(wp);

% viral end object
viral_on = false;
viral_procs_end = [];

% main loop that iterates every clip
while true
  
  % Create the main damage ticks sequence of the next clip
  % iterate through every shot in the next clip
  
  % if the clip schedule is empty, then schedule the next clip
  if isempty(clip_schedule)
  
  % first create a shot by shot time vector
  clip_time_vec = linspace(start_time,start_time+(wp.MAG-1)/wp.FR,wp.MAG);
  % update start time, add reload time
  start_time = start_time+wp.MAG/wp.FR+wp.RLT;
  for i = 1:wp.MAG
    
    % first roll multishot rng for this shot
    if MSRand
      MS = rollRandVariable(MSRandVar);
    end
    
    % for every projectile
    for j = 1:MS
      % roll crit chance rng
      crit_tier = base_crit_tier+rollRandVariable(CritRandVar);
      crit_multi = 1+crit_tier*(wp.CM-1);
      % record main projectile final damages as separated by elemental types
      % iterate through all nonzero element types
      this_projectile_dmg_arr = [];
      for k = dmg_type_ind
        if wp.(wpfields{k})>0
          this_damage.type = wpfields{k};
          this_damage.value = wp.(wpfields{k})*faction_multi*crit_multi;
          this_damage.time = clip_time_vec(i);
          this_damage.flag = false;
          this_projectile_dmg_arr = [this_projectile_dmg_arr this_damage];
        end
      end
      clip_schedule = [clip_schedule;this_projectile_dmg_arr];
    end
    
  end
  
  end
  
  % main dynamic event execution loop
  % status effects are done in here
  
  while true
    % search the earliest time entries of all event schedules
    % find all with the same earliest time
    % schedule the events in order of: main projectile damage ticks,
    % corrosive and viral, and then all other dot ticks.
    % flag these events for having been executed.
    while ~isempty(clip_schedule)
      
      % sort through the first damage object among all scheduled events and
      % determine which one to execute. 
      % lists involve clip_schedule(:,1), electricity, heat, toxin, slash,
      % and viral. 
      
      % apply all events scheduled at this instant one by one.
      % first, roll status random variable
      status_effect = rollRandVariable(StatusRandomVar);
      
      % apply viral status effect if present
      if strcmp(status_effect,'viral')
        % if currently the enemy does not have a viral effect
        if ~viral_on
          enemy.health = enemy.health*0.5;
          viral_procs_end.damage = -enemy.health*0.5;
          viral_procs_end.type = 'true';
        end
        % refresh the viral proc end time 
        % present clip schedule time +6 secs
        viral_procs_end.t = clip_schedule(1,1).t+6;
      end
      
      % deal per shot damage to the enemy, element by element
      for j = 1:size(clip_schedule,2)
        enemy = dealDamageToEnemy(enemy,clip_schedule(1,j),dmghtm);
      end
      % apply corrosive status effect
      if strcmp(status_effect,'corrosive')
        enemy.armor = enemy.armor*0.75;
        if enemy.armor < 1
          enemy.armor = 0;
        end
      end
      
      enemy_arr = [enemy_arr;enemy];
      tarr = [tarr;clip_schedule(1,1).time];
      clip_schedule(1,:) = [];
      % if enemy is dead
      if enemy.health<=0
        return;
      end
    end
    % if we are at the end of the current main event schedule,
    if isempty(clip_schedule)
      break; % break and loop back and schedule the next main shot
    end
  end
  
end

end