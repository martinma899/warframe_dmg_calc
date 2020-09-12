% write builds of weapons to text file
% part of the old workflow, should be changed

i = 0;
while true
  i = i+1;
  switch sort_criteria
    case 'average'
      dps_pct = wp_arr(i).avg_dps/dps_max;
    case 'burst'
      dps_pct = wp_arr(i).burst_dps/dps_max;
  end
  if dps_pct<dmg_threshold
    break;
  end
  fprintf(fid,'--> Build Ranking #%d <--\n\n',i);
  temp = {mods(wp_arr(i).build).name}';
  fprintf(fid,'    %22s\n',temp{:});
  fprintf(fid,'\nAverage DPS: %10.2f\n',wp_arr(i).avg_dps);
  fprintf(fid,'  Burst DPS: %10.2f\n',wp_arr(i).burst_dps);
  fprintf(fid,'avg DPS as percent of top build: %5.2f%%\n\n',dps_pct*100);
end

fclose('all');