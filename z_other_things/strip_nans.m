function [dataout] = strip_nans(data)
% strips extra rows of nans from a cell array by finding the first row and
% column of the cell array where all entries are nans, and removing all of
% the rest of the rows and columns. 

% full case:  
%              |                                       |
%              V                                       V 
%     NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN 
%     NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN 
%  -> NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%  -> NAN NAN  1   2   3   4   5   6  NAN NAN  7  NAN  8  NAN NAN 
%     NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN 
%     NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN NAN 

% this gets cleaned up to:
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8
% 1   2   3   4   5   6  NAN NAN  7  NAN  8

% check all rows from the front and find the first row that is not all nans
row_count = 1;
while true
    thisrow = data(row_count,:); % extract this row
    isnanlogicalarray = zeros(1,numel(thisrow)); % initialize logical array
    for j = 1:numel(thisrow) % iterate through all elements of that row and fill logical array
        isnanlogicalarray(j) = any(isnan(thisrow{j}));
    end
    % check if this row is all nan
    if all(isnanlogicalarray) % if a row is all nan
        row_count = row_count+1; % increment row count
    else % if a row is not all nan
        content_row_ind_front = row_count;
        break;
    end
    % check if we are at the end of the cell array
    if row_count > size(data,1)
        break; % if so, break out of loop
    end
end

% check all rows from the back and find the first row that is not all nans
row_count = size(data,1);
while true
    thisrow = data(row_count,:); % extract this row
    isnanlogicalarray = zeros(1,numel(thisrow)); % initialize logical array
    for j = 1:numel(thisrow) % iterate through all elements of that row and fill logical array
        isnanlogicalarray(j) = any(isnan(thisrow{j}));
    end
    % check if this row is all nan
    if all(isnanlogicalarray) % if a row is all nan
        row_count = row_count-1; % increment row count
    else % if a row is not all nan
        content_row_ind_back = row_count;
        break;
    end
    % check if we are at the end of the cell array
    if row_count == 0
        break; % if so, break out of loop
    end
end


col_count = 1;
while true
    thiscol = data(:,col_count); % extract this col
    isnanlogicalarray = zeros(1,numel(thisrow)); % initialize logical array
    for j = 1:numel(thiscol) % iterate through all elements of that col and fill logical array
        isnanlogicalarray(j) = any(isnan(thiscol{j}));
    end
    % check if this col is all nan
    if all(isnanlogicalarray) % if a col is all nan
        col_count = col_count+1; % increment col count
    else % if a col is not all nan
        content_col_ind_front = col_count;
        break;
    end
    % check if we are at the end of the cell array
    if col_count > size(data,2)
        break; % if so, break out of loop
    end
end

% check all cols from the back and find the first col that is not all nans
col_count = size(data,2);
while true
    thiscol = data(:,col_count); % extract this col
    isnanlogicalarray = zeros(1,numel(thiscol)); % initialize logical array
    for j = 1:numel(thiscol) % iterate through all elements of that col and fill logical array
        isnanlogicalarray(j) = any(isnan(thiscol{j}));
    end
    % check if this col is all nan
    if all(isnanlogicalarray) % if a col is all nan
        col_count = col_count-1; % increment col count
    else % if a col is not all nan
        content_col_ind_back = col_count;
        break;
    end
    % check if we are at the end of the cell array
    if col_count == 0
        break; % if so, break out of loop
    end
end

dataout = data(content_row_ind_front:content_row_ind_back,...
  content_col_ind_front:content_col_ind_back);

end

