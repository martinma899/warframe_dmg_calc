function [modifier] = gethtm(st,ht,dmghtm)
modifier = dmghtm.matrix(strcmp(st,dmghtm.st),strcmp(ht,dmghtm.ht));
end