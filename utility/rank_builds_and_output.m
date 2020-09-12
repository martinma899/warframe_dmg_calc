%% rank builds

switch sort_criteria
  case 'average'
    avg_dps_arr = [wp_arr.avg_dps]'; % extract average dps arr
    [avg_dps_arr,ind] = unique(avg_dps_arr); % unique avg_dps_arr and wp_arr
    wp_arr = wp_arr(ind);
    [avg_dps_arr,ind] = sort(avg_dps_arr,'descend'); % sort avg_dps_arr and wp_arr
    wp_arr = wp_arr(ind);
    dps_max = wp_arr(1).avg_dps;
  case 'burst'
    burst_dps_arr = [wp_arr.burst_dps]'; % extract average dps arr
    [burst_dps_arr,ind] = unique(burst_dps_arr); % unique avg_dps_arr and wp_arr
    wp_arr = wp_arr(ind);
    [burst_dps_arr,ind] = sort(burst_dps_arr,'descend'); % sort avg_dps_arr and wp_arr
    wp_arr = wp_arr(ind);
    dps_max = wp_arr(1).burst_dps;
  otherwise
    error('please enter ''average'' or ''burst'' for sort_criteria. This sorts the weapon by reload-accounting average or burst dps.')
end

% %% output top
% 
% i = 0;
% while true
%   i = i+1;
%   switch sort_criteria
%     case 'average'
%       dps_pct = wp_arr(i).avg_dps/dps_max;
%     case 'burst'
%       dps_pct = wp_arr(i).burst_dps/dps_max;
%   end
%   if dps_pct<dmg_threshold
%     break;
%   end
%   fprintf('\n--> Build Ranking #%d <--\n\n',i)
%   disp(mod_name_arr(wp_arr(i).build))
%   fprintf('\nAverage DPS: %10.2f\n',wp_arr(i).avg_dps);
%   fprintf('  Burst DPS: %10.2f\n',wp_arr(i).burst_dps);
%   fprintf('avg DPS as percent of top build: %5.2f%%\n\n',dps_pct*100);
% end
% 
% plot([wp_arr.avg_dps],'b.-')