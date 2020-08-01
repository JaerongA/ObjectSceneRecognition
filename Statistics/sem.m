function y = sem(x,dim)

%% calculates the standard error of the mean (SEM) of vector x by AJR 2013/06/25

y = nanstd(x,dim) / sqrt(numel(x));
end