function [updated_Linhas, updated_state_vars]=release(Linhas, idx, state_vars, config_vars)
    
    % Procura a linha onde a chamada esta a ser transportada 
    for idx_line=1: config_vars.nLines
        if (Linhas(idx_line) == idx)
            % Liberta a linha onde está a ser transportada
            % a chamada                        
            state_vars.occupiedLines=state_vars.occupiedLines-1; 
            Linhas(idx_line)=0;
            break;
        end
    end
    
    
    updated_Linhas=Linhas;
    updated_state_vars=state_vars;
end