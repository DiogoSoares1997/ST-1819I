function [updated_Linhas, transport_line_idx, updated_state_vars]=setup(Linhas, idx, duracao, state_vars, config_vars)

    % SETUP (Inicio de chamada)
    state_vars.totalCalls=state_vars.totalCalls+1;
    state_vars.reqServiceTime=state_vars.reqServiceTime+duracao;
    if (state_vars.occupiedLines >= config_vars.nLines)
        % Chamada Bloqueada
        state_vars.bloquedCalls=state_vars.bloquedCalls+1;
        transport_line_idx=0;
    else
        % Chamada servida
        state_vars.occupiedLines=state_vars.occupiedLines+1;
        for idx_line=1: config_vars.nLines
            if (Linhas(idx_line) == 0)
                Linhas(idx_line)=idx;
                %tlinha(idx)=idx_linha;
                transport_line_idx=idx_line;
                break;
            end
        end
       state_vars.carriedServiceTime=state_vars.carriedServiceTime+duracao;
    end    
    updated_state_vars=state_vars;
    updated_Linhas=Linhas;
end