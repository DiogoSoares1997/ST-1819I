function [tfim_ord,idx_tfim,tinicio,tfim,updated_Operators,updated_Linhas, updated_state_vars]=release(Operators,Linhas, idx, state_vars, config_vars,tinicio,tfim,tdur)
    if (idx ~= 0)
        % Procura a linha onde a chamada esta a ser transportada 
        for idx_line=1: config_vars.nLines
            if (Linhas(idx_line) == idx)
            % Liberta a linha onde está a ser transportada
            % a chamada                        
            state_vars.occupiedLines=state_vars.occupiedLines-1;
            state_vars.occupiedOpe=state_vars.occupiedOpe-1;
            Linhas(idx_line)=0;
            a = find(Operators == idx);
            Operators(a)=0;           
            
            m = min(Linhas(Linhas>0));
            
                
                if(m ~= 0)
                    while Operators (a) == 0
                        if(m~=0)
                            if(verificar_ope(m)==0)
                                Linhas(idx_line)=m;
                                Operators(a)=m;
                                tinicio(m)=tfim(idx);
                                tfim(m)=tinicio(m)+tdur(m);
                                [tfim_ord, idx_tfim]=sort(tfim);
                                state_vars.occupiedOpe=state_vars.occupiedOpe+1;
                                state_vars.occupiedLines=state_vars.occupiedLines+1;
                                
                            else
                                m = min(Linhas(Linhas>m));
                            end
                        end
                        
                       break; 
                    end
                end
            end
            [tfim_ord, idx_tfim]=sort(tfim);
        tfim=tfim;
        tinicio=tinicio;
            break;
        end
    else
        [tfim_ord, idx_tfim]=sort(tfim);
        tfim=tfim;
        tinicio=tinicio;
    end
    
    updated_Operators=Operators;
    updated_Linhas=Linhas;
    updated_state_vars=state_vars;
end