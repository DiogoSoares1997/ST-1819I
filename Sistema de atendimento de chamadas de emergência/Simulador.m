clear all;
close all;
%% Parametros de Simulação
config.nLines112=130;
config.nLinesINEM=113;
config.nOperators112=30;
config.nOperatorsINEM=73;

Lines112=zeros(config.nLines112,1);
LinesINEM=zeros(config.nLinesINEM,1);
Operators112=zeros(config.nOperators112,1);
OperatorsINEM=zeros(config.nOperatorsINEM,1);
FilaDeEspera112=zeros((config.nLines112-config.nOperators112),1);
FilaDeEsperaINEM=zeros((config.nLinesINEM-config.nOperatorsINEM),1);
FEINEM112=zeros((config.nLines112-config.nOperators112),1);
%% Estado da simulação
stateData.occupiedLines112 = 0;      % Linhas ocupadas do 112
stateData.occupiedLinesINEM = 0;      % Linhas ocupadas do INEM
stateData.totalCalls = 0;         % Numero total de chamadas
stateData.totalCalls112 = 0;         % Numero total de chamadas
stateData.totalCallsINEM = 0;         % Numero total de chamadas
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
        [Operators112 ,OperatorsINEM, Lines112,LinesINEM,FilaDeEspera112,FilaDeEsperaINEM,FEINEM112,not_attended,call_idx, stateData]=setup(Operators112,...
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
    else
        % RELEASE (Fim de chamada)
        % Verifica se o evento de fim de chamada e valido
        % Valido para tempo do fim de chamada superior a zero
        if(idx_tfim(idx_R)~=0)
                % Caso seja valido
                [tfim_ord,idx_tfim,Operators112,OperatorsINEM,Lines112,LinesINEM,FilaDeEspera112,FilaDeEsperaINEM,FEINEM112,stateData,wait,End,Start,last]=release(Operators112, ...
                    OperatorsINEM, ...
                    Lines112, ...
                    LinesINEM,...
                    FilaDeEspera112, ...
                    FilaDeEsperaINEM, ...
                    FEINEM112, ...
                    Type1, ...
                    idx_tfim(idx_R), ...
                    stateData,tfim_ord,idx_tfim,End,HandlingTime1,Start, config);
                if(wait==1)
                    idx_R=find(idx_tfim == last);
                end
            
        end
        % Incrementa o indice do proximo evento de Fim de chamada
        idx_R=idx_R+1;
    end
end
%% Resultados

% x=[Start1 tfim];
% y=[1:length(Start1) 1:length(Start1)];
% figure;
% plot(Start1,1:length(Start1),'.k')
% hold on;
% plot(End1,1:length(End1),'*r')
% hold off;
% 
% figure;
% line([tinicio; tfim], [tlinha; tlinha],...
%     'Linewidth',3,...
%     'Color',[0 0 1]);
% 
%%
%Resultados
B_real112=stateData.bloquedCalls112/stateData.totalCalls112;
B_realINEM=stateData.bloquedCallsINEM/stateData.totalCallsINEM;

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
% wait_time1(wait_time1==0)=NaN;
% wTime_real=mean(wait_time1,'omitnan');
% wTime_teorico=(config.holdTime/(config.nOperators-A_real));
% % Número médio de chamadas em espera: calculado fazendo vários testes com
% % os mesmos parâmetros de simulação e guardando os valores num ficheiro
% % excel
% %Probabilidade de espera superior ao tempo de referência
% temp=zeros(length(wait_time1), 1);
% temp=find(wait_time1>config.waitTime);
% waitTimeProbRef_real=length(temp)/stateData.calltowait;
% waitTimeProbRef_teorico=C_real*exp(-config.waitTime/(config.holdTime/(config.nOperators-A_real)));
