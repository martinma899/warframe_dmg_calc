full_output_file_name = fullfile(weapon_name,output_file_name);
if isfile(full_output_file_name)
  tempstr = sprintf('Output file %s already exists in folder %s. Overwrite? y/n\n',output_file_name,weapon_name);
  inp = input(tempstr,'s');
  switch inp
    case 'y'
      fprintf('\nproceeding to load weapons and mods\n')
    otherwise
      error('mission aborted.')
  end
end