function [val] = dec2double(a)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% test=([dec2bin(a(8),8) dec2bin(a(7),8) dec2bin(a(6),8) dec2bin(a(5),8) dec2bin(a(4),8) dec2bin(a(3),8) dec2bin(a(2),8) dec2bin(a(1),8)]);
% V = test-'0'; % convert to numeric
% frc = 1+sum(V(13:64).*2.^(-1:-1:-52));
% pow = sum(V(2:12).*2.^(10:-1:0))-1023;
% sgn = (-1)^V(1);
% val = sgn * frc * 2^pow;

% a=a.';
test=([dec2bin(a(:,8),8) dec2bin(a(:,7),8) dec2bin(a(:,6),8) dec2bin(a(:,5),8) dec2bin(a(:,4),8) dec2bin(a(:,3),8) dec2bin(a(:,2),8) dec2bin(a(:,1),8)]);
V = test-'0'; % convert to numeric
frc = 1+sum(V(:,13:64).*2.^repmat((-1:-1:-52),size(a,1),1),2);
pow = sum(V(:,2:12).*2.^repmat((10:-1:0),size(a,1),1),2)-1023;
sgn = (-1).^V(:,1);
val = sgn.* frc.* 2.^pow;

% val=val.';
end

