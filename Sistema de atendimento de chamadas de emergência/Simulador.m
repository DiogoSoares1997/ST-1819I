clear all;
close all;
%% Parametros de Simulação
config.nLines112=157;
config.nLinesINEM=107;
config.nOperators112=25;
config.nOperatorsINEM=74;
config.ReferenceTime=30;

Lines112=zeros(config.nLines112,1);
LinesINEM=zeros(config.nLinesINEM,1);
Operators112=zeros(config.nOperators112,1);
OperatorsINEM=zeros(config.nOperatorsINEM,1);
FilaDeEspera112=zeros((config.nLines112-config.nOperators112),1);
FilaDeEsperaINEM=zeros((config.nLinesINEM-config.nOperatorsINEM),1);
FEINEM112=zeros((config.nLines112-config.nOperators112),1);
wait_timeINEM=zeros(1500,1);
wait_time112=zeros(1500,1);
n_cham_FE112=zeros(1463,1);
n_cham_FEINEM=zeros(1463,1);
n_cham_FE112INEM=zeros(1463,1);
%% Estado da simulação
stateData.occupiedLines112 = 0;      % Linhas ocupadas do 112
stateData.occupiedLinesINEM = 0;      % Linhas ocupadas do INEM
stateData.totalCalls = 0;         % Numero total de chamadas
stateData.totalCalls112 = 0;         % Numero total de chamadas
stateData.totalCallsINEM = 0;         % Numero total de chamadas
stateData.bloquedCalls =0;            % Numero de Chamadas bloqueadas no global
stateData.bloquedCallsINEM = 0;       % Chamadas bloqueadas do INEM
stateData.bloquedCalls112 = 0;       % Chamadas bloqueadas do 112
stateData.reqServiceTime112 = 0;     % Tempo total de oferta
stateData.reqServiceTimeINEM = 0;
stateData.carriedServiceTime112 = 0; % Tempo total de transporte
stateData.carriedServiceTimeINEM = 0;
%stateData.waitOccupiedLines=0;  % Nº Linhas ocupadas na fila de espera
stateData.calltowait=0;         % Nº de chamadas que foram para fila de espera no 112
stateData.calltowaitINEM=0;     %Nº de chamadas que foram para a fila de espera no INEM
stateData.occupiedOpe112=0; % Nº de operadores ocupados do 112
stateData.occupiedOpeINEM=0; % Nº de operadores ocupados do 112

%% Simulação
[Start1,Type1,HandlingTime1] = importfile('Dados G31.txt',2, 1465);
Start=zeros(length(Start1),1);
for i=1:length(Start1)
    Start(i)=Start1(i).* (24*60*60);
end


[ End ] = Conversor( HandlingTime1,Start);

% End1=zeros(length(Start1),1);
% for i=1:length(Start1)
%     End1(i)=datenum(End(i,:));
% end

[tfim_ord , idx_tfim]=sort(End);

idx_S=1;
idx_R=1;
while ( idx_S < length(Start1) )
    % Verifica o tipo de evento SETUP ou RELEASE
    if ( Start(idx_S) < tfim_ord(idx_R) )
        [Operators112 ,OperatorsINEM, Lines112,LinesINEM,FilaDeEspera112,FilaDeEsperaINEM,FEINEM112,not_attended,call_idx,idx_line, stateData]=setup(Operators112,...
            OperatorsINEM, ...
            Lines112, ...
            LinesINEM, ...
            FilaDeEspera112, ...
            FilaDeEsperaINEM, ...
            FEINEM112, ...
            Type1, ...
            idx_S, ...
            HandlingTime1(idx_S), ...
            stateData, ...
            config);
        if(not_attended==true)
            x = find(idx_tfim == call_idx);
            idx_tfim(x)=0;
            End(call_idx)=NaN;
        end
        idx_S=idx_S+1;
        tlinha(idx_S,1)=idx_line;
       
    else
        % RELEASE (Fim de chamada)
        % Verifica se o evento de fim de chamada e valido
        % Valido para tempo do fim de chamada superior a zero
        if(idx_tfim(idx_R)~=0)
            % Caso seja valido
            [tfim_ord,idx_tfim,Operators112,OperatorsINEM,Lines112,LinesINEM,FilaDeEspera112,FilaDeEsperaINEM,FEINEM112,stateData,wait,End,Start,last,wait_timeINEM,wait_time112]=release(Operators112, ...
                OperatorsINEM, ...
                Lines112, ...
                LinesINEM,...
                FilaDeEspera112, ...
                FilaDeEsperaINEM, ...
                FEINEM112, ...
                Type1, ...
                idx_tfim(idx_R), ...
                stateData,tfim_ord,idx_tfim,End,HandlingTime1,Start,wait_timeINEM,wait_time112, config);
            if(wait==1)
                idx_R=find(idx_tfim == last);
            end
            
        end
        % Incrementa o indice do proximo evento de Fim de chamada
        idx_R=idx_R+1;
        
    end
    n_cham_FE112(idx_S)=length(find(FilaDeEspera112>0));
    n_cham_FEINEM(idx_S)=length(find(FilaDeEsperaINEM>0));
    n_cham_FE112INEM(idx_S)=length(find(FEINEM112>0));
end
%% Resultados

% x=[Start End];
% y=[1:length(Start1) 1:length(Start1)];
% figure;
% plot(Start1,1:length(Start1),'.k')
% hold on;
% plot(End1,1:length(End1),'*r')
% hold off;
%

% figure;
% line([Start; End],[tlinha; tlinha],...
%     'Linewidth',3,...
%     'Color',[0 0 1]);

%%
%Resultados
%Ritmo de chamadas de cada tipo
Bhca112=stateData.totalCalls112/(Start(length(Start))-Start(1));
BhcaINEM=stateData.totalCallsINEM/(Start(length(Start))-Start(1));

%Distribuição do tipo de chamadas
Type=zeros(length(Type1),1);
for i=1:length(Type1)
    if strcmp(Type1(i),'112')
        Type(i)=1;
    else
        Type(i)=2;
    end
end
figure1 = figure; 
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on',...
    'Position',[0.105964312960161 0.166666666666667 0.875812452415693 0.804964539007092]);
ylim(axes1,[0.5 2.5]);
box(axes1,'on');
hold(axes1,'on');
plot(Type,'MarkerSize',3,'Marker','.','LineStyle','none','Color',[1 0 0]);

% Create xlabel
xlabel('Nº de Eventos');

% Create ylabel
ylabel('Chamadas do 112 (1) e INEM (2) ');
figure (2)
histogram(Type)

%Caracterização estatística para a duração das chamadas
HoldTimeGlobal=mean(HandlingTime1);
HoldTime112=stateData.reqServiceTime112/stateData.totalCalls112;
HoldTimeINEM=stateData.reqServiceTimeINEM/stateData.totalCallsINEM;

%Probabilidade de bloqueio Global e de cada sistema
B_real112=stateData.bloquedCalls112/stateData.totalCalls112;
B_realINEM=stateData.bloquedCallsINEM/stateData.totalCallsINEM;
B_realGlobal=stateData.bloquedCalls/stateData.totalCalls;

%Probabilidade de Espera no centro 112 e INEM
%INEM
tempINEM = find(wait_timeINEM > 0);
Prob_Espera_INEM=length(tempINEM)/stateData.totalCallsINEM;
% wait_timeINEM(wait_timeINEM==0)=NaN;
% wTimeINEM_real_exp=mean(wait_timeINEM,'omitnan');
% wTimeINEM_real=datevec(wTimeINEM_real_exp/(24*60*60));

%112
temp112 = find(wait_time112 > 0);
Prob_Espera_112=length(temp112)/stateData.totalCalls112;
% wait_time112(wait_time112==0)=NaN;
% wTime112_real_exp=mean(wait_time112,'omitnan');
% wTime112_real=datevec(wTime112_real_exp/(24*60*60));

% Número médio de chamadas em espera em cada sistema
%112
Num_Espera_112=mean(n_cham_FE112, 'omitnan');
%INEM
Num_Espera_INEM=mean(n_cham_FEINEM, 'omitnan');
%112INEM
Num_Espera_112INEM=mean(n_cham_FE112INEM, 'omitnan');

%Distribuição do tempo de espera
%112
wait_time112(wait_time112==0)=NaN;
figure (3)
plot(wait_time112)

%INEM
wait_timeINEM(wait_timeINEM==0)=NaN;
figure (4)
plot(wait_timeINEM)

%Probabilidade de espera superior ao tempo de referência
%112
temp=find(wait_time112>config.ReferenceTime);
waitTimeProbRef112_real=length(temp)/length(temp112);

%INEM
tempx=find(wait_timeINEM>config.ReferenceTime);
waitTimeProbRefINEM_real=length(tempx)/length(tempINEM);

% % % Tráfego Oferecido
% % A_real=stateData.reqServiceTime/tinicio(end);
% % A_teorico=(config.bhca*config.holdTime)/3600;
% % % Probabilidade de perda de chamada
% % B_real=stateData.bloquedCalls/stateData.totalCalls;
% % %B_teorico=PBloqueio(config.nLines, A_teorico);
% % % Tráfego transportado
% % A0_real=stateData.carriedServiceTime/tinicio(end);
% % A0_teorico=A_real*(1-B_real);
% % % Probabilidade de espera
% % C_real=stateData.calltowait/stateData.totalCalls;
% % C_teorico=PWait(config.nOperators, A_real);
% % C_teo=(B_real*config.nOperators)/(config.nOperators-A_real*(1-B_real));
% % Tempo médio de espera

%wTime_teorico=(config.holdTime/(config.nOperators-A_real));
% % Número médio de chamadas em espera: calculado fazendo vários testes com
% % os mesmos parâmetros de simulação e guardando os valores num ficheiro
% % excel
%Probabilidade de espera superior ao tempo de referência
%temp=zeros(length(wait_time112), 1);
%temp=find(wait_time112>30);
%waitTimeProbRef_real=length(temp)/;
% waitTimeProbRef_teorico=C_real*exp(-config.waitTime/(config.holdTime/(config.nOperators-A_real)));
