function out = genStatusRandomVar (wp)
% takes wp object according to standard convention
% produces out which is a discrete random variable
% out.x is a string cell array of proc types, including 'nan' which is not
% procing anything
% out.p is the probability of each situation occuring
% out.p must sum to 1

% get weapon fields
wpfields = fields(wp);
% get the index array that tells which fields are damage type arrays
dmg_type_ind = get_dmg_type_ind(wpfields);

damages = [];
out.x = [];
out.p = [];
for i = dmg_type_ind
  if wp.(wpfields{i})>0
    out.x = [out.x wpfields(i)];
    switch wpfields{i}
      case {'impact' 'puncture' 'slash'}
        damages = [damages wp.(wpfields{i})*4];
      otherwise
        damages = [damages wp.(wpfields{i})];
    end
  end
end
out.x = [{'nan'} out.x];
out.p = [1-wp.SC wp.SC*damages/sum(damages)];
end