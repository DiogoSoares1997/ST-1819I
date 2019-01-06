function [ End ] = Conversor( HandlingTime1, Start)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for  i=1:length(HandlingTime1)
    
    if HandlingTime1(i)> 60
      minutes = fix(HandlingTime1(i) /60);
      sec= rem(HandlingTime1(i),60);
      Start(i,6)=Start(i,6)+sec;
      if Start(i,6) > 60
          minutes = fix(Start(i,6)/60);
          Start(i,6)=rem(Start(i,6),60);
          Start(i,5)=Start(i,5)+minutes;
      end    
      
      Start(i,5)=Start(i,5)+minutes;
      if Start(i,5) > 60
          hours = fix(Start(i,5)/60);
          Start(i,5)=rem(Start(i,5),60);
          Start(i,4)=Start(i,4)+hours;
      end    
    else
        Start(i,6)=Start(i,6)+HandlingTime1(i);
      if Start(i,6) > 60
          minutes = fix(Start(i,6)/60);
          Start(i,6)=rem(Start(i,6),60);
          Start(i,5)=Start(i,5)+minutes;
      end    
      
      if Start(i,5) > 60
          hours = fix(Start(i,5)/60);
          Start(i,5)=rem(Start(i,5),60);
          Start(i,4)=Start(i,4)+hours;
      end    
    end

end
End=Start;

%%datestr(seconds(HandlingTime1(i)),'MM:SS')