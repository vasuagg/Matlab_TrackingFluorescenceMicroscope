% AUG2C Convert complex to augmented vector/matrix
%   c_out = aug2c(aug_in) returns a complex vector/matrix, the size of
%   which is half the size of aug_in in both dimensions. The function
%   returns an error message if aug_in does not contain an even number of
%   elements in any of the necessary dimensions.
function c_out = aug2c(aug_in);

if length(size(aug_in)) ~= 2,
    error('I do not understand.');
end;

if size(aug_in, 2) == 1,
    if mod(size(aug_in, 1), 2) ~= 0,
        error('Invalid augmented vector.');
    end;
    
    c_out = aug_in(1:end/2) + i*aug_in(end/2+1:end);
    return;
end;

if size(aug_in, 1) == 1,
    if mod(size(aug_in, 2), 2) ~= 0,
        error('Invalid augmented vector.');
    end;
    
    c_out = aug_in(1:end/2) + i*aug_in(end/2+1:end);
    return;
end;

if mod(size(aug_in, 1), 2) ~= 0 | mod(size(aug_in, 2), 2) ~= 0,
    error('Invalid augmented matrix.');
end;

c_out = aug_in(1:end/2, 1:end/2) - i*aug_in(1:end/2, end/2+1:end);

return;