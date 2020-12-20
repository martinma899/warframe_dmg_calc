function [mod_array] = read_mod_text_database(database_file_name)

%{
This function is an attempt at remaking how mod database is stored and
handled. 
Saving mods as an excel array is difficult to edit without having
microsoft product. The current way excel arrays store mods also cannot
distinguish the order of two elemental stats on the same mod (in the case
of rivens). 
The new format of mod library is as follows:
the library is a text file. 
every line has the following format:
<no space mod name> <space> <stat 1 name> <space> <stat value> <space> 
<stat 2 name> <space> <stat 2 value> ...

Basically space delimits within a line and new line delimits a new mod. 

"%" sign will be used as comment symbol. 
If this sign is found in a line, the rest of the line is not read by the
code. 
If first character of a line is "%" then the entire line is skipped. 

%}

mod_array = []; % initialize mod array as an empty cell array.

% open mod database file
fid = fopen(database_file_name,'r');

line  =fgetl(fid); % get first line
while line~=-1 % while we have not run out of lines to read
    % determine if there are comments, and take comment out
    comment_sign_id = find(line=='%');
    if ~isempty(comment_sign_id) % if %s are found
        comment_sign_id = comment_sign_id(1); % take the index of first %
        line(comment_sign_id:end) = []; % take away the comment bits
    end
    
    if isempty(line)||all(line == ' ') % if entire line is empty (before or after taking away comment)
        line = fgetl(fid);
        continue
    end
    
    % initialize mod object
    mod = [];
    % get mod name
    [mod.name, line] = strtok(line,' ');
    % get all mod stats and values
    while ~(isempty(line)||all(line == ' '))
        [attribute, line] = strtok(line,' ');
        [stat, line] = strtok(line,' ');
        stat = str2double(stat);
        mod.(attribute) = stat;
    end
    
    % put mod into mod_array
    mod_array = [mod_array {mod}];
    % get new line
    line = fgetl(fid);
end


end