function [ result ] = NCHOOSEK( n,k )
%NCHOOSEK Summary of this function goes here
%   Detailed explanation goes here
[row,col] = size(n);
len = 0;
if row == 1
   len = col;
else
   len = row;
end
result = zeros(1,len);
for j = 1:len
   result(j) = nchoosek(n(j),k); 
end
end

