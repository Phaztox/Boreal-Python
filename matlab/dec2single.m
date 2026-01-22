function [val] = dec2single(a)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% test=([dec2bin(a(4),8) dec2bin(a(3),8) dec2bin(a(2),8) dec2bin(a(1),8)]);
% V = test-'0'; % convert to numeric
% frc = 1+sum(V(10:32).*2.^(-1:-1:-23));
% pow = sum(V(2:9).*2.^(7:-1:0))-127;
% sgn = (-1)^V(1);
% val = sgn * frc * 2^pow;

% a=a.';
test=([dec2bin(a(:,4),8) dec2bin(a(:,3),8) dec2bin(a(:,2),8) dec2bin(a(:,1),8)]);
V = test-'0'; % convert to numeric
frc = 1+sum(V(:,10:32).*2.^repmat((-1:-1:-23),size(a,1),1),2);
pow = sum(V(:,2:9).*2.^repmat((7:-1:0),size(a,1),1),2)-127;
sgn = (-1).^V(:,1);
val = sgn.* frc.* 2.^pow;

% val=val.';
end

