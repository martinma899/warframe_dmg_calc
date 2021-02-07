function [dataout] = strip_nans(data)
% strips extra rows of nans from a cell array by finding the first row and
% colum of the cell array where all entries are nans, and removing all of
% the rest of the rows and columns. 

% check all rows
row_count = 1;
while true
    thisrow = data(row_count,:); % extract this row
    isnanlogicalarray = zeros(1,numel(thisrow)); % initialize logical array
    for j = 1:numel(thisrow) % iterate through all elements of that row and fill logical array
        isnanlogicalarray(j) = any(isnan(thisrow{j}));
    end
    % check if this row is all nan
    if all(isnanlogicalarray) % if a row is all nan
        data(row_count,:) = []; % remove that row, do not increment row count
    else % if row not removed,
        row_count = row_count+1; % increment row count
    end
    % check if we are at the end of the cell array
    if row_count > size(data,1)
        break; % if so, break out of loop
    end
end

% check all columns
column_count = 1;
while true
    thiscolumn = data(:,column_count); % extract this column
    isnanlogicalarray = zeros(numel(thiscolumn),1); % initialize logical array
    for j = 1:numel(thiscolumn) % iterate through all elements of that column and fill logical array
        isnanlogicalarray(j) = any(isnan(thiscolumn{j}));
    end
    % check if this row is all nan
    if all(isnanlogicalarray) % if a row is all nan
        data(:,column_count) = []; % remove that row, do not increment row count
    else % if row not removed,
        column_count = column_count+1; % increment row count
    end
    % check if we are at the end of the cell array
    if column_count > size(data,2)
        break; % if so, break out of loop
    end
end

dataout = data;

end

