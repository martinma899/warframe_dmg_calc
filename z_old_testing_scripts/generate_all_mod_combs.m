function [all_builds] = generate_all_mod_combs(mods_ind,num_modslots)

num_mandatory_mods = numel(mods_ind.mandatory);
num_flexible_mods = numel(mods_ind.flexible);
num_open_mod_slots = num_modslots-num_mandatory_mods;

% if there's no flexible mods, just return all mandatory mods. 
if num_flexible_mods == 0
  all_builds = mods_ind.mandatory;
else
  num_builds = nchoosek(num_flexible_mods,num_open_mod_slots);
  
  fprintf('\nNumber of builds to be calculated: %d\n',num_builds)
  inp = input('continue? y/n\n','s');
  switch inp
    case 'y'
      fprintf('\nproceeding to compute build stats\n\n')
    otherwise
      error('mission aborted.')
  end
  
  all_remaining_mods_combs = combnk(mods_ind.flexible,num_open_mod_slots);
  all_builds = [];
  for i = 1:num_builds
    all_builds = [all_builds;[mods_ind.mandatory all_remaining_mods_combs(i,:)]];
  end
  all_builds = sort(all_builds,2);
end

end