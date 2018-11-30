clear all;
close all;

%% Parametros da simulacao
config.bhca=200;            % Ritmo de chamadas por hora ch/h
config.holdTime =140;       % Duracao da chamada em segundos
config.nLines=15;           % Numero de operadores
config.simTime=24*60*60;    % Tempo da simulacao em segundos
config.wLines=25;           % Número de linhas da fila de espera
config.waitTime=1*60;       % Tempo de espera de referência

% Numero total de eventos(chamadas) da simulacao
NEventos=config.bhca/3600*config.simTime;
Linhas=zeros(config.nLines,1);
Fila_espera=zeros(1,config.wLines);

%% Estado simulacao
stateData.occupiedLines=0;      % Linhas ocupadas
stateData.totalCalls=0;         % Numero total de chamadas
stateData.bloquedCalls=0;       % Chamadas bloqueadas
stateData.reqServiceTime=0;     % Tempo total de oferta
stateData.carriedServiceTime=0;	% Tempo total de transporte
stateData.waitOccupiedLines=0;  % Nº Linhas ocupadas na fila de espera
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
%
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
        [Fila_espera , Linhas,in_wait,call_wait, idx_line, stateData]=setup(Fila_espera,...
            Linhas, ...
            idx_S, ...
            tdur(idx_S), ...
            stateData, ...
            config);
        if(in_wait==true)
            tfim(call_wait)=tinicio(call_wait)+ tdur(call_wait)+ config.waitTime;
            [tfim_ord idx_tfim]=sort(tfim);
        end
        tlinha(idx_S)=idx_line;
        idx_S=idx_S+1;
    else
        % RELEASE (Fim de chamada)
        % Verifica se o evento de fim de chamada e valido
        % Valido para tempo do fim de chamada superior a zero
        if (tfim(idx_tfim(idx_R)) > 0)
            % Caso seja valido
            [Linhas, stateData]=release(Linhas, ...
                idx_tfim(idx_R), ...
                stateData, config);
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


% Trafego Oferecido
A=stateData.reqServiceTime/tinicio(end);
% Trafego transportado
A0=stateData.carriedServiceTime/tinicio(end);
% Probabilidade de bloqueio
B=stateData.bloquedCalls/stateData.totalCalls;
