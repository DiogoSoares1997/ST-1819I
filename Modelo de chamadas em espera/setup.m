function [updated_nOperators,updated_Linhas,not_attended,call_idx, transport_line_idx, updated_state_vars]=setup(Operators,Linhas, idx, duracao, state_vars, config_vars)

% SETUP (Inicio de chamada)
state_vars.totalCalls  = state_vars.totalCalls+1;
state_vars.reqServiceTime=state_vars.reqServiceTime+duracao;
if (state_vars.occupiedLines < config_vars.nLines)
    if(state_vars.occupiedOpe < config_vars.nOperators)
        state_vars.occupiedOpe=state_vars.occupiedOpe+1;
        state_vars.occupiedLines=state_vars.occupiedLines+1;
        for idx_line=1: config_vars.nLines    %resolver este modo pois não vai resultar, talvez considera criar o ciclo para as linhas e depois se confirmares que a linha está fazia entao vai completar a de operadores
            if (Linhas(idx_line) == 0)
                 for idx_op=1: config_vars.nOperators
                    Linhas(idx_line)=idx;
                    Operators(idx_op)=idx;
                    transport_line_idx=idx_line;
                    not_attended = false;
                    call_idx = 0;
                    break;
                end
           
                
                break;
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
%     m = min(Fila_espera(Fila_espera>0));
%     
%     if(m ~= 0)
%         % Chamada servida da fila de espera
%         state_vars.occupiedLines=state_vars.occupiedLines+1;
%         for idx_line=1: config_vars.nLines
%             if (Linhas(idx_line)==0)
%                 Linhas(idx_line)=m;
%                 transport_line_idx=idx_line;
%                 a = find(Fila_espera == m);
%                 Fila_espera(1,a)=idx;
%                 in_wait=true;
%                 call_wait=idx;
%                 break;
%             end
%         end
%         while state_vars.occupiedLines < config_vars.nLines
%             for idx_line=1: config_vars.nLines
%                 if (Linhas(idx_line)==0)
%                     m = min(Fila_espera(Fila_espera>0));
%                     if (m~=0)
%                         Linhas(idx_line)=m;
%                         transport_line_idx=idx_line;
%                         a = find(Fila_espera == m);
%                         Fila_espera(1,a)=0;
%                         state_vars.occupiedLines= state_vars.occupiedLines+1;
%                         state_vars.waitOccupiedLines=state_vars.waitOccupiedLines-1;
%                     else
%                         break;
%                     end
%                 else
%                     break;
%                 end
%                 break;
%             end
%             break;
%         end
%     else
%         % Chamada servida
%         state_vars.occupiedLines=state_vars.occupiedLines+1;
%         for idx_line=1: config_vars.nLines
%             if (Linhas(idx_line) == 0)
%                 Linhas(idx_line)=idx;
%                 %tlinha(idx)=idx_linha;
%                 transport_line_idx=idx_line;
%                 in_wait = false;
%                 call_wait=idx;
%                 break;
%             end
%         end
%         state_vars.carriedServiceTime=state_vars.carriedServiceTime+duracao;
%     end
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