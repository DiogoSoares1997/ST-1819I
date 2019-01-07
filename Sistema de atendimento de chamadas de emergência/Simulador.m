clear all;
close all;
%% Parametros de Simulação
config.nLines112=10;
config.nLinesINEM=10;
config.nOperators112=5;
config.nOperatorsINEM=10;

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
stateData.bloquedCalls = 0;       % Chamadas bloqueadas
stateData.reqServiceTime112 = 0;     % Tempo total de oferta
stateData.carriedServiceTime112 = 0; % Tempo total de transporte
stateData.carriedServiceTimeINEM = 0;
%stateData.waitOccupiedLines=0;  % Nº Linhas ocupadas na fila de espera
stateData.calltowait=0;         % Nº de chamadas que foram para fila de espera no 112
stateData.calltowaitINEM=0;     %Nº de chamadas que foram para a fila de espera no INEM
stateData.occupiedOpe112=0; % Nº de operadores ocupados do 112
stateData.occupiedOpeINEM=0; % Nº de operadores ocupados do 112

%% Simulação
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

idx_S=1;
idx_R=1;
while ( idx_S < length(Start1) )
    % Verifica o tipo de evento SETUP ou RELEASE
    if ( Start1(idx_S) < tfim_ord(idx_R) )
        [Operators , Linhas,,,,,,not_attended,call_idx, stateData]=setup(Operators112,...
                                                                    OperatorsINEM, ...
                                                                    OperatorsTriagem, ...
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
        end
        idx_S=idx_S+1;
    else
        % RELEASE (Fim de chamada)
        % Verifica se o evento de fim de chamada e valido
        % Valido para tempo do fim de chamada superior a zero
        if(idx_tfim(idx_R)~=0)
            if (tfim(idx_tfim(idx_R)) > 0)
            % Caso seja valido
            [tfim_ord,idx_tfim,tnicio,tfim,Operators,Linhas, stateData,wait]=release(Operators, ...
                                        Linhas, ...
                                        idx_tfim(idx_R), ...
                                        stateData, config,tinicio,tfim,tdur);
                                    if(wait==1)
                                        idx_R=idx_R-1;
                                    end
            end
        end
        % Incrementa o indice do proximo evento de Fim de chamada
        idx_R=idx_R+1;
    end
end