histogram([wp_arr.avg_dps])
titlestr = sprintf('%s %s dps distribution subject to mod selection %s',...
  weapon_name,sort_criteria,mod_input_file_name);
title(titlestr,'interpreter','none');