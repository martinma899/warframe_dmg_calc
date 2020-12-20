init_seq;
clear

inputs = {...
'vigilante armaments',...
'speed trigger',...
'magazine warp',...
'ammo drum',...
'hunter munitions',...
'continuous misery',...
}
%'serration',...
%'point strike',...
%'vital sense',...
%'stormbringer',...
%'infected clip',...
%'primed bane of grineer',...
%'primed bane of corpus',...
%'primed bane of infested',...
%'primed bane of corrupted',...
%'rifle aptitude',...
%'fast hands',...
%'crash course',...
%'piercing caliber',...
%'fanged fusillade',...

wpb = read_weapon_xlsx('lenz');

mod = read_and_combine_mods(inputs,'rifle')

wpm = mod_weapon2(wpb,mod,false)

wrap_up;