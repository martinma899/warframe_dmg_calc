function [outcome] = rollRandVariable(in)
% takes discrete random variable in with entries in.x and probability in.p
% in.x can be a cell array of objects or a numerical array
% in.p needs to be probabilities that sum to 1
if numel(in.p)==1
  outcome = in.x;
else
  n = rand(1); % draw random number
  cdf = cumsum(in.p);
  for i = 1:numel(cdf)
    if n <= cdf(i)
      outcome = in.x(i);
      if iscell(outcome)
        outcome = outcome{1};
      end
      return;
    end
  end
end
end