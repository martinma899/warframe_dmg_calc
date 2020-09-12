function [wp_quantum_arr,wp_arr] = compute_all_builds(wpb,mods,all_builds,output)

wp_quantum_arr = [];
wp_arr = [];

for i = 1:size(all_builds,1)
  fprintf('Computing Build %d @xxxx[{::::::::::::::::::::::::::::::::::> \n\n',i)
  [wp_quantum,wp] = mod_weapon(wpb,mods(all_builds(i,:)));
  wp_quantum_arr = [wp_quantum_arr wp_quantum];
  wp_arr = [wp_arr wp];
  if output
    print_mod_array(mods(all_builds(i,:)),1);fprintf('\n')
    disp(wp);fprintf('\n')
  end
end
end