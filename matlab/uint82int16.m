function [val2] = uint82int16(q1,q2)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
test=[dec2bin(q1,8) dec2bin(q2,8)];
test=test-'0';
n2=find(test==0);
test2=zeros(size(test,1),size(test,2));
test2(n2)=1;
val2=-(sum(test2.*2.^(repmat(15:-1:0,size(test2,1),1)),2)+1);
n1=find(test(:,1)==0);
val2(n1)=sum(test(n1,:).*2.^(repmat(15:-1:0,size(test(n1,:),1),1)),2);
end

