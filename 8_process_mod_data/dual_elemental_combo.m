function out = dual_elemental_combo (in)
if strcmp(in{1},'COLD')
  if strcmp(in{2},'ELECTRICITY')
    out = 'MAGNETIC';
  elseif strcmp(in{2},'TOXIN')
    out = 'VIRAL';
  elseif strcmp(in{2},'HEAT')
    out = 'BLAST';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'ELECTRICITY')
  if strcmp(in{2},'COLD')
    out = 'MAGNETIC';
  elseif strcmp(in{2},'TOXIN')
    out = 'CORROSIVE';
  elseif strcmp(in{2},'HEAT')
    out = 'RADIATION';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'TOXIN')
  if strcmp(in{2},'COLD')
    out = 'VIRAL';
  elseif strcmp(in{2},'ELECTRICITY')
    out = 'CORROSIVE';
  elseif strcmp(in{2},'HEAT')
    out = 'GAS';
  else
    error('incorrect elemental input types for elemental combo')
  end
elseif strcmp(in{1},'HEAT')
  if strcmp(in{2},'COLD')
    out = 'BLAST';
  elseif strcmp(in{2},'ELECTRICITY')
    out = 'RADIATION';
  elseif strcmp(in{2},'TOXIN')
    out = 'GAS';
  else
    error('incorrect elemental input types for elemental combo')
  end
else
  error('incorrect elemental input types for elemental combo')
end
end