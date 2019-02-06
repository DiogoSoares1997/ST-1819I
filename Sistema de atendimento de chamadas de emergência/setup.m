function [updated_nOperators112,updated_nOperatorsINEM,updated_Lines112,updated_LinesINEM,updated_FE112,updated_FEINEM,updated_FEINEM112,not_attended,call_idx,transport_line_idx, updated_state_vars]=setup(Operators112,OperatorsINEM, Lines112,LinesINEM,FilaDeEspera112,FilaDeEsperaINEM,FEINEM112,Type, idx, duracao, state_vars, config_vars)

% SETUP (Inicio de chamada)
call_idx=idx;
transport_line_idx=0;
state_vars.totalCalls  = state_vars.totalCalls+1;
if( strcmp(Type(idx),'112'))
    state_vars.totalCalls112=state_vars.totalCalls112+1;
    state_vars.reqServiceTime112=state_vars.reqServiceTime112+duracao;
    if (state_vars.occupiedLines112 < config_vars.nLines112) %Entrada da chamada nas linhas 112
        for idx_triagem=1: config_vars.nLines112
            if(Lines112(idx_triagem)==0)
                state_vars.occupiedLines112=state_vars.occupiedLines112+1;
                Lines112(idx_triagem)=idx;
                break;
            end
        end
        if(state_vars.occupiedOpe112 < config_vars.nOperators112) %Atendimento por um op de 112
            state_vars.occupiedOpe112=state_vars.occupiedOpe112+1;
            not_attended = false;
            for idx_Opt=1: config_vars.nOperators112
                if (Operators112(idx_Opt) == 0)
                    Operators112(idx_Opt)=idx;
                    call_idx = idx;
                    transport_line_idx=idx_Opt;
                    break;
                end
            end
        else
            % Chamada em fila de espera NO 112
            not_attended = true;
            state_vars.calltowait = state_vars.calltowait + 1 ;
            for idx_112 = 1: length(FilaDeEspera112)
                if (FilaDeEspera112(idx_112)==0)
                    FilaDeEspera112(idx_112)=idx;
                    call_idx=idx;
                    break;
                end
            end
        end
    else
        state_vars.bloquedCalls112=state_vars.bloquedCalls112+1;
        state_vars.bloquedCalls=state_vars.bloquedCalls+1;
        not_attended=true;
        call_idx=idx;
    end
else
    state_vars.reqServiceTimeINEM=state_vars.reqServiceTimeINEM+duracao;
    state_vars.totalCallsINEM=state_vars.totalCallsINEM+1;
    if(state_vars.occupiedLinesINEM < config_vars.nLinesINEM)
        state_vars.occupiedLinesINEM=state_vars.occupiedLinesINEM+1;
        for idx_INEM=1: config_vars.nLinesINEM
            if(LinesINEM(idx_INEM)==0)
                LinesINEM(idx_INEM)=idx;
                break;
            end
        end
        
        if(state_vars.occupiedOpeINEM < config_vars.nOperatorsINEM)
            state_vars.occupiedOpeINEM=state_vars.occupiedOpeINEM+1;
            not_attended = false;
            for idx_op=1: config_vars.nOperatorsINEM
                if (OperatorsINEM(idx_op) == 0)
                    OperatorsINEM(idx_op)=idx;
                    call_idx = 0;
                    break;
                end
            end
        else
            % Chamada em fila de espera NO INEM
            state_vars.calltowaitINEM=state_vars.calltowaitINEM+1;
            not_attended = true;
            for idx_1 = 1: length(FilaDeEsperaINEM)
                if (FilaDeEsperaINEM(idx_1)==0)
                    FilaDeEsperaINEM(idx_1)=idx;
                    call_idx=idx;
                    break;
                end
            end
        end
    else
        if (state_vars.occupiedLines112 < config_vars.nLines112)
            state_vars.occupiedLines112=state_vars.occupiedLines112+1;
            not_attended=true;
            call_idx = idx;
            
            for idx_triagem=1: config_vars.nLines112
                if(Lines112(idx_triagem)==0)
                    Lines112(idx_triagem)=idx;
                    break;
                end
            end
            for idx_I=1:length(FEINEM112)
                if(FEINEM112(idx_I)==0)
                    FEINEM112(idx_I) = idx;
                    break;
                end
            end
        else
            state_vars.bloquedCallsINEM=state_vars.bloquedCallsINEM+1;
            state_vars.bloquedCalls=state_vars.bloquedCalls+1;
            not_attended=true;
            call_idx=idx;
        end
    end
end
updated_state_vars=state_vars;
updated_nOperators112=Operators112;
updated_nOperatorsINEM=OperatorsINEM;
updated_Lines112=Lines112;
updated_LinesINEM=LinesINEM;
updated_FE112=FilaDeEspera112;
updated_FEINEM=FilaDeEsperaINEM;
updated_FEINEM112=FEINEM112;

end