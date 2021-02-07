function [modifier] = gethtm(st,ht,dmghtm)
modifier = dmghtm.matrix(strcmpi(st,dmghtm.st),strcmpi(ht,dmghtm.ht));
end