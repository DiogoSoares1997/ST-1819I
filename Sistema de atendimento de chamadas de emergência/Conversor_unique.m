function [ End ] = Conversor_unique( HandlingTime, Start)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    
    if HandlingTime > 60
      minutes = fix(HandlingTime/60);
      sec= rem(HandlingTime,60);
      Start(1,6)=Start(1,6)+sec;
      if Start(1,6) > 60
          minutes = fix(Start(1,6)/60);
          Start(1,6)=rem(Start(1,6),60);
          Start(1,5)=Start(1,5)+minutes;
      end    
      
      Start(1,5)=Start(1,5)+minutes;
      if Start(1,5) > 60
          hours = fix(Start(1,5)/60);
          Start(1,5)=rem(Start(1,5),60);
          Start(1,4)=Start(1,4)+hours;
      end    
    else
        Start(6)=Start(6)+HandlingTime;
      if Start(6) > 60
          minutes = fix(Start(6)/60);
          Start(6)=rem(Start(6),60);
          Start(5)=Start(5)+minutes;
      end    
      
      if Start(5) > 60
          hours = fix(Start1(5)/60);
          Start(5)=rem(Start(5),60);
          Start(4)=Start(4)+hours;
      end    
    end
End=Start;
end



