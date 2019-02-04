function [ End ] = Conversor( HandlingTime1, Start)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for  i=1:length(HandlingTime1)
    
    Start(i) = Start(i)+HandlingTime1(i);
    

end
End=Start;

%%datestr(seconds(HandlingTime1(i)),'MM:SS')