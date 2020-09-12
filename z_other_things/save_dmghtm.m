clc;clear
% damage health type modifier
% source type
dmghtm.st = {'impact' 'puncture' 'slash' 'cold' 'electricity' ...
  'heat' 'toxin' 'blast' 'corrosive' 'gas' 'magnetic' 'radiation'...
  'viral' 'true' 'void'};
% health type
dmghtm.ht = {'flesh' 'cloned_flesh' 'fossilized' 'infested'...
  'infested_flesh' 'infested_sinew' 'machinery' 'robotic' ...
  'object' 'shield' 'proto_shield' 'ferrite_armor' 'alloy_armor'};
% modifier matrix
dmghtm.matrix = ...
  [-0.25 -0.25 0 0 0 0 +0.25 0 0 +0.5 +0.25 0 0;
  0 0 0 0 0 +0.25 0 +0.25 0 -0.2 -0.5 +0.5 +0.15;
  +0.25 +0.25 +0.15 +0.25 +0.5 0 0 -0.25 0 0 0 -0.15 -0.5;
  0 0 -0.25 0 -0.5 +0.25 0 0 0 +0.5 0 0 +0.25;
  0 0 0 0 0 0 +0.5 +0.5 0 0 0 0 -0.5;
  0 +0.25 0 +0.25 +0.5 0 0 0 0 0 -0.5 0 0;
  +0.5 0 -0.5 0 0 0 -0.25 -0.25 0 nan nan +0.25 0;
  0 0 +0.5 0 0 -0.5 +0.75 0 0 0 0 -0.25 0;
  0 0 +0.75 0 0 0 0 0 0 0 -0.5 +0.75 0;
  -0.25 -0.5 0 +0.75 +0.5 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 +0.75 +0.75 0 -0.5;
  0 0 -0.75 -0.5 0 +0.5 0 +0.25 0 -0.25 0 0 +0.75;
  +0.5 +0.75 0 -0.5 0 0 -0.25 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 nan nan;
  0 -0.5 -0.5 0 0 0 -0.5 0 0 0 0 0 0];