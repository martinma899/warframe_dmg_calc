% do things before the execution of script

% add all sub folders so the source codes there can be accessed
D = dir('*');
names = {D.name};
isdirs = [D.isdir];
names = names(isdirs);

for name = names
addpath(name{1});
end


load('dmghtm.mat');

