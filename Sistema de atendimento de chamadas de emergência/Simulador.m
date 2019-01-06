clear all;
close all;


[Start1,Type1,HandlingTime1] = importfile('Dados G31.txt',2, 1465);


Start=zeros(length(Start1),6);
for i=1:length(Start1)
    Start(i,:)=datevec(Start1(i));
end

[ End ] = Conversor( HandlingTime1,Start);

End1=zeros(length(Start1),1); 
for i=1:length(Start1)
    End1(i)=datenum(End(i,:));
end

[tfim_ord , idx_tfim]=sort(End1);