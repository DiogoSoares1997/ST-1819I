function [tfim_ord,idx_tfim,updated_Operators112,updated_OperatorsINEM,updated_Lines112,updated_LinesINEM,UP_FE112,UP_FEINEM,UP_FEINEM112, updated_state_vars, wait_R,End,Start,last]=release(Operators112,OperatorsINEM,Lines112,LinesINEM,FE112,FEINEM,FEINEM112,Type, idx, state_vars,tfim_ord,idx_tfim,End,HandlingTime,Start, config_vars)
wait_R=0;
if ( strcmp(Type(idx),'112'))
    if (idx ~= 0)
        % Procura a linha onde a chamada esta a ser transportada
        for idx_112=1: config_vars.nLines112
            if (Lines112(idx_112) == idx)
                % Liberta a linha onde está a ser transportada
                % a chamada
                state_vars.occupiedLines112=state_vars.occupiedLines112-1;
                state_vars.occupiedOpe112=state_vars.occupiedOpe112-1;
                Lines112(idx_112)=0;
                a = find(Operators112 == idx);
                Operators112(a)=0;
                m = min(FE112(FE112>0));
                if(m ~= 0) %Procura a existência de alguma chamada do 112 em fila de espera
                    Operators112(a)=m;
                    a = find (FE112==m);
                    FE112(a)=0;
                    Start(m)=End(idx);
                    End(m)= Start(m)+ HandlingTime(m);
                    [tfim_ord, idx_tfim]=sort(End);
                    state_vars.occupiedOpe112=state_vars.occupiedOpe112+1;
                    wait_R=1;
                    break;
                    
                end
                
            end
        end
    end
else
    if ( idx ~=0)
        % Procura a linha onde a chamada esta a ser transportada
        for idx_INEM=1: config_vars.nLinesINEM
            if (LinesINEM(idx_INEM) == idx)
                % Liberta a linha onde está a ser transportada
                % a chamada
                state_vars.occupiedLinesINEM=state_vars.occupiedLinesINEM-1;
                state_vars.occupiedOpeINEM=state_vars.occupiedOpeINEM-1;
                LinesINEM(idx_INEM)=0;
                a = find(OperatorsINEM == idx);
                OperatorsINEM(a)=0;
                n = min(FEINEM(FEINEM>0));
                if (n ~= 0)                 %Procura alguma chamada do INEM que esteja em fila de espera
                    OperatorsINEM(a)=n;
                    a = find (FEINEM==n);
                    FEINEM(a)=0;
                    Start(n)=End(idx);
                    End(n)= Start(n)+ HandlingTime(n);
                    [tfim_ord, idx_tfim]=sort(End);
                    state_vars.occupiedOpeINEM=state_vars.occupiedOpeINEM+1;
                    wait_R=1;
                    x = min (FEINEM112(FEINEM112>0));
                    if( x ~=0)              %Procura alguma chamda que esteja na fila de espera do INEM nas linhas do 112
                        FEINEM(a)=x;
                        b = find (FEINEM112==x);
                        FEINEM112(b)=0;
                        state_vars.occupiedLinesINEM=state_vars.occupiedLinesINEM+1;
                        state_vars.occupiedLines112=state_vars.occupiedLines112-1;
                    end
                    break;
                end
                break;
            end
        end
    end
end

updated_Operators112=Operators112;
updated_OperatorsINEM=OperatorsINEM;
updated_Lines112=Lines112;
updated_LinesINEM=LinesINEM;
UP_FE112 = FE112;
UP_FEINEM = FEINEM;
UP_FEINEM112 = FEINEM112;
last = idx;
updated_state_vars=state_vars;
tfim_ord = tfim_ord;
idx_tfim = idx_tfim;
End=End;
Start=Start;
end