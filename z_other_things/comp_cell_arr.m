function [logical_output] = comp_cell_arr(cell_arr,in)
% compares every element of a cell array against an input and outputs a
% logical array same size of cell_arr

logical_output = zeros(size(cell_arr,1),size(cell_arr,2));
for i = 1:numel(cell_arr)
  if isequaln(in,cell_arr{i})
    logical_output(i) = 1;
  end
end
end

