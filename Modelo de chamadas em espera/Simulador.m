clear all;
close all;

%% Parametros da simulacao
config.bhca=200;            % Ritmo de chamadas por hora ch/h
config.holdTime = 140;       % Duracao da chamada em segundos
config.nLines=10;           % Numero de linhas
config.simTime=24*60*60;    % Tempo da simulacao em segundos
config.nOperators=10;
%config.wLines=100;           % Número de linhas da fila de espera
config.waitTime=1*60;       % Tempo de espera de referência em segundos

% Numero total de eventos(chamadas) da simulacao
NEventos=config.bhca/3600*config.simTime;
Linhas=zeros(config.nLines,1);
%Fila_espera=zeros(1,config.wLines);
Operators=zeros(config.nOperators,1);
wait_time1=zeros(24*config.bhca,1);

%% Estado simulacao
stateData.occupiedLines = 0;      % Linhas ocupadas
stateData.totalCalls= 0;         % Numero total de chamadas
stateData.bloquedCalls=0;       % Chamadas bloqueadas
stateData.reqServiceTime=0;     % Tempo total de oferta
stateData.carriedServiceTime=0;	% Tempo total de transporte
%stateData.waitOccupiedLines=0;  % Nº Linhas ocupadas na fila de espera
stateData.calltowait=0;         % Nº de chamadas que foram para fila de espera
stateData.occupiedOpe=0;        % Nº de operadores ocupados
stateData.acccalls=0;
%stateData.totalHoldingTime=0;   %
%stateData.totalnextCallTime=0;  %

%%
% Geracao de todos os eventos da simulacao
% Geracao do tempo entre chamadas
tchamadas=expon(3600/config.bhca,NEventos);
% Geracao da duracao de cada chamada
tdur=expon(config.holdTime,NEventos);

[ tinicio, idx_tfim, tfim_ord, tdur, tlinha, tfim ] = wait_time( tdur,tchamadas,0 );
% % Sequenciacao das chamadas
% tinicio=tchamadas(1);
% tfim=tchamadas(1)+tdur(1);
%idx_R
% for n=2:length(tchamadas)
%     tinicio(n)=tinicio(n-1)+tchamadas(n);
%     tfim(n)=tinicio(n)+tdur(n);
% end
%
% tfim_ori=tfim;
% tlinha=zeros(size(tinicio));

% %x=[tinicio; tfim];
% %y=[1:length(tinicio); 1:length(tinicio)];
% %figure;
% %%plot(x,y,'k')
% %line(x,y);
%
% % Ordenacao dos eventos de fim de chamada guardando
% % os indices no vetor idx_tfim
% [tfim_ord idx_tfim]=sort(tfim);

%% Inicio da simulacao
idx_S=1;
idx_R=1;
while ( idx_S < length(tinicio) )
    % Verifica o tipo de evento SETUP ou RELEASE
    if ( tinicio(idx_S) < tfim_ord(idx_R) )
        [Operators , Linhas,not_attended,call_idx, idx_line, stateData]=setup(Operators,...
                                                                            Linhas, ...
                                                                            idx_S, ...
                                                                            tdur(idx_S), ...
                                                                            stateData, ...
                                                                            config);
        if(not_attended==true)
            x = find(idx_tfim == call_idx);
            idx_tfim(x)=0;
            tfim(call_idx)= NaN;
        end
        tlinha(idx_S)=idx_line;
        idx_S=idx_S+1;
    else
        % RELEASE (Fim de chamada)
        % Verifica se o evento de fim de chamada e valido
        % Valido para tempo do fim de chamada superior a zero
        if(idx_tfim(idx_R)~=0)
            if (tfim(idx_tfim(idx_R)) > 0)
            % Caso seja valido
            [tfim_ord,idx_tfim,tnicio,tfim,Operators,Linhas, stateData,wait,wait_time1,diogo]=release(Operators, ...
                                        Linhas, ...
                                        idx_tfim(idx_R), ...
                                        stateData, ...
                                        config,...
                                        tinicio,...
                                        tfim,...
                                        tdur,...
                                        tfim_ord, ...
                                        idx_tfim, ... 
                                        wait_time1);
                                    if(wait==1)
                                        idx_R=find(idx_tfim == diogo);
                                    end
            end
        end
        % Incrementa o indice do proximo evento de Fim de chamada
        idx_R=idx_R+1;
    end
end

%% Resultados

x=[tinicio tfim];
y=[1:length(tinicio) 1:length(tinicio)];
figure;
plot(tinicio,1:length(tinicio),'.k')
hold on;
plot(tfim,1:length(tfim),'*r')
hold off;

figure;
line([tinicio; tfim], [tlinha; tlinha],...
    'Linewidth',3,...
    'Color',[0 0 1]);

% Tráfego Oferecido
A_real=stateData.reqServiceTime/tinicio(end);
A_teorico=(config.bhca*config.holdTime)/3600;
% Probabilidade de perda de chamada
B_real=stateData.bloquedCalls/stateData.totalCalls;
B_teorico=Pb( A_real,config.nOperators);
% Tráfego transportado
A0_real=stateData.carriedServiceTime/tinicio(end);
A0_teorico=A_real*(1-B_real);
% Probabilidade de espera
C_real=stateData.calltowait/(stateData.totalCalls-stateData.bloquedCalls);
%C_teorico=PWait(config.nOperators, A_real);
erlangb=0.03;   % valor da probabilidade de bloqueio para linha de espera infinita (tabela Erlang B)
%C_teorico=(B_real*config.nOperators)/(config.nOperators-A_real*(1-B_real));
C_teo=(erlangb*config.nOperators)/(config.nOperators-A_real*(1-erlangb));
% Tempo médio de espera
wait_time(wait_time==0)=NaN;
wTime_real=mean(wait_time,'omitnan');
wTime_teorico=(config.holdTime)/(config.nOperators-A_real);
% Número médio de chamadas em espera: calculado fazendo vários testes com
% os mesmos parâmetros de simulação e guardando os valores num ficheiro
% excel
%Probabilidade de espera superior ao tempo de referência
temp=zeros(length(wait_time1), 1);
temp=find(wait_time1>config.waitTime);
waitTimeProbRef_real=length(temp)/stateData.calltowait;
waitTimeProbRef_teorico=C_real*exp(-config.waitTime/(config.holdTime/(config.nOperators-A_real)));
waitTimeProbRef_teorico2=C_real*exp(-((config.nOperators-A_real)*config.waitTime)/config.holdTime);