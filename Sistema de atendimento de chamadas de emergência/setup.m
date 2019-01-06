function [updated_nOperators,updated_Linhas,not_attended,call_idx, updated_state_vars]=setup(Operators112,OperatorsINEM,Lines112,LinesINEM,Type, idx, duracao, state_vars, config_vars)

% SETUP (Inicio de chamada)
state_vars.totalCalls  = state_vars.totalCalls+1;
state_vars.reqServiceTime=state_vars.reqServiceTime+duracao;
if( strcmp(Type(idx),'112'))
    if (state_vars.occupiedLines112 < config_vars.nLines112)
        for idx_triagem=1: config_vars.nLines112
            if(Lines112(idx_triagem)==0)
               state_vars.occupiedLines112=state_vars.occupiedLines112+1;
               Lines112(idx_triagem)=idx;
               break;
            end
        end
        if(state_vars.occupiedOpeTriagem < config_vars.nOperatorsTriagem)
           state_vars.occupiedOpeTriagem=state_vars.occupiedOpeTriagem+1;
        
            for idx_Opt=1: config_vars.nOperatorsTriagem    
                if (OperatorsTriagem(idx_Opt) == 0)
                    OperatorsTriagem(idx_Opt)=idx;
                    not_attended = false;
                    call_idx = 0;
                    break;
                end
            end
            if (state_vars.nOccupiedOpe112 < config.nOperators112)
                x = find(OperatorsTriagem(OperatorsTriagem == idx));
                OperatorsTriagem(x)=0;
                for idx_temp=1: config_vars.nOperators112    
                    if (Operators112(idx_temp) == 0)
                        Operators112(idx_temp)=idx;
                        break;
                    end
                end
            end
            
    else
        % Chamada em fila de espera
        state_vars.occupiedLines=state_vars.occupiedLines+1;
        state_vars.calltowait=state_vars.calltowait+1;
        for idx_line = 1: config_vars.nLines
            if (Linhas(idx_line)==0)
                Linhas(idx_line)=idx;
                not_attended = true;
                call_idx=idx;
                transport_line_idx=idx_line;
                break,
            end
        end
        end
    else

        state_vars.bloquedCalls=state_vars.bloquedCalls+1;
        transport_line_idx=0;
        not_attended=true;
        call_idx=idx;
    end
updated_state_vars=state_vars;
updated_Linhas=Linhas;
updated_nOperators=Operators;
end