function [updated_wLinhas,updated_Linhas,in_wait,call_wait, transport_line_idx, updated_state_vars]=setup(Fila_espera,Linhas, idx, duracao, state_vars, config_vars)

% SETUP (Inicio de chamada)
state_vars.totalCalls  = state_vars.totalCalls+1;
state_vars.reqServiceTime=state_vars.reqServiceTime+duracao;
if (state_vars.occupiedLines >= config_vars.nLines)
    if(state_vars.waitOccupiedLines < config_vars.wLines)
        % Chamada em fila de espera
        state_vars.waitOccupiedLines=state_vars.waitOccupiedLines+1;
        for idx_waitLine = 1: config_vars.wLines
            if (Fila_espera(1,idx_waitLine)==0)
                Fila_espera(1,idx_waitLine)=idx;
                in_wait = true;
                call_wait=idx;
                transport_line_idx=0;
                break,
            end
        end
    else
        % Chamada Bloqueada
        state_vars.bloquedCalls=state_vars.bloquedCalls+1;
        transport_line_idx=0;
        in_wait=0;
        call_wait=0;
    end
else
    m = min(Fila_espera(Fila_espera>0));
    
    if(m ~= 0)
        % Chamada servida da fila de espera
        state_vars.occupiedLines=state_vars.occupiedLines+1;
        for idx_line=1: config_vars.nLines
            if (Linhas(idx_line)==0)
                Linhas(idx_line)=m;
                transport_line_idx=idx_line;
                a = find(Fila_espera == m);
                Fila_espera(1,a)=idx;
                in_wait=true;
                call_wait=idx;
                break;
            end
        end
        while state_vars.occupiedLines < config_vars.nLines
            for idx_line=1: config_vars.nLines
                if (Linhas(idx_line)==0)
                    m = min(Fila_espera(Fila_espera>0));
                    if (m~=0)
                        Linhas(idx_line)=m;
                        transport_line_idx=idx_line;
                        a = find(Fila_espera == m);
                        Fila_espera(1,a)=0;
                        state_vars.occupiedLines= state_vars.occupiedLines+1;
                        state_vars.waitOccupiedLines=state_vars.waitOccupiedLines-1;
                    else
                        break;
                    end
                else
                    break;
                end
            break;
            end
            break;
        end
    else
        % Chamada servida
        state_vars.occupiedLines=state_vars.occupiedLines+1;
        for idx_line=1: config_vars.nLines
            if (Linhas(idx_line) == 0)
                Linhas(idx_line)=idx;
                %tlinha(idx)=idx_linha;
                transport_line_idx=idx_line;
                in_wait = false;
                call_wait=idx;
                break;
            end
        end
        state_vars.carriedServiceTime=state_vars.carriedServiceTime+duracao;
    end
end
updated_state_vars=state_vars;
updated_Linhas=Linhas;
updated_wLinhas=Fila_espera;
end