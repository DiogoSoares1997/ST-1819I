function [updated_nOperators,updated_Linhas,not_attended,call_idx, transport_line_idx, updated_state_vars]=setup(Operators,Linhas, idx, duracao, state_vars, config_vars)

% SETUP (Inicio de chamada)
state_vars.totalCalls  = state_vars.totalCalls+1;
state_vars.reqServiceTime=state_vars.reqServiceTime+duracao;
if (state_vars.occupiedLines < config_vars.nLines)
    state_vars.occupiedLines=state_vars.occupiedLines+1;
    if(state_vars.occupiedOpe < config_vars.nOperators)
        state_vars.occupiedOpe=state_vars.occupiedOpe+1;
        state_vars.acccalls=state_vars.acccalls+1;
        for idx_line=1: config_vars.nLines    
            if (Linhas(idx_line) == 0)
                Linhas(idx_line)=idx;
                transport_line_idx=idx_line;
                not_attended = false;
                call_idx = 0;
                 for idx_op=1 : config_vars.nOperators
                     if (Operators(idx_op) == 0)
                        Operators(idx_op)=idx;
                     break;  
                     end
                 end
                break;
            end
        end
    else
        % Chamada em fila de espera
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
    state_vars.carriedServiceTime=state_vars.carriedServiceTime+duracao;
else

% Chamada Bloqueada
        state_vars.bloquedCalls=state_vars.bloquedCalls+1;
        transport_line_idx=0;
        not_attended=true;
        call_idx=idx;
end
updated_state_vars=state_vars;
updated_Linhas=Linhas;
updated_nOperators=Operators;
end