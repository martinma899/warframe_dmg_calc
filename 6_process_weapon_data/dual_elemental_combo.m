function out = dual_elemental_combo (in)
if strcmp(in{1},'cold')
  if strcmp(in{2},'electricity')
    out = 'magnetic';
  elseif strcmp(in{2},'toxin')
    out = 'viral';
  elseif strcmp(in{2},'heat')
    out = 'blast';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'electricity')
  if strcmp(in{2},'cold')
    out = 'magnetic';
  elseif strcmp(in{2},'toxin')
    out = 'corrosive';
  elseif strcmp(in{2},'heat')
    out = 'radiation';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'toxin')
  if strcmp(in{2},'cold')
    out = 'viral';
  elseif strcmp(in{2},'electricity')
    out = 'corrosive';
  elseif strcmp(in{2},'heat')
    out = 'gas';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'heat')
  if strcmp(in{2},'cold')
    out = 'blast';
  elseif strcmp(in{2},'electricity')
    out = 'radiation';
  elseif strcmp(in{2},'toxin')
    out = 'gas';
  else
    error('incorrect elemental input types for elemental combo')
  end
else
  error('incorrect elemental input types for elemental combo')
end
end