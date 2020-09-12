function print_mods (mods,mods_ind,comments,fid)

% mandatory mods
fprintf(fid,'--> Mandatory Mods <--\n\n');
print_mod_array(mods(mods_ind.mandatory),fid)
fprintf(fid,'\n');

% flexible mods
fprintf(fid,'--> Flexible Mods <--\n\n');
print_mod_array(mods(mods_ind.flexible),fid)
fprintf(fid,'\n');

% excluded mods
fprintf(fid,'--> Excluded Mods <--\n\n');
print_mod_array(mods(mods_ind.excluded),fid)
fprintf(fid,'\n');

% comments
fprintf(fid,'--> Comments <--\n\n');
if ~isempty(comments)
  for i = 1:numel(comments)
    fprintf(fid,'%s\n',comments{i});
  end
end
fprintf(fid,'\n');

end