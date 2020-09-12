function [] = print_mod_array(mods,fid)
% takes in the cell array of mods
% prints them on screen
for i = 1:numel(mods)
  thismod = mods{i};
  fprintf(fid,'%25s',thismod.name);
  fieldnames = fields(thismod);
  for j = 2:numel(fieldnames)
    fprintf(fid,' %12s ',fieldnames{j});
    fprintf(fid,' %5.2f ',thismod.(fieldnames{j}));
  end
  fprintf(fid,'\n');
end
end