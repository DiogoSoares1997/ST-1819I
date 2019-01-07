function [tfim_ord,idx_tfim,tinicio,tfim,updated_Operators,updated_Linhas, updated_state_vars, wait_R,Updatedwait_time,diogo]=release(Operators,Linhas, idx, state_vars, config_vars,tinicio,tfim,tdur,wait_time)
    wait_R=0;
    if (idx ~= 0)
        % Procura a linha onde a chamada esta a ser transportada 
        for idx_line=1: config_vars.nLines
            if (Linhas(idx_line) == idx)
            % Liberta a linha onde está a ser transportada
            % a chamada
            diogo=idx;
            state_vars.occupiedLines=state_vars.occupiedLines-1;
            state_vars.occupiedOpe=state_vars.occupiedOpe-1;
            Linhas(idx_line)=0;
            a = find(Operators == idx);
            Operators(a)=0;           
            m = min(Linhas(Linhas>0));
           
                
                if(m ~= 0)
                    while Operators (a) == 0
                        if(m~=0)
                            if(verificar_ope(Operators,m)==0)
                                Operators(a)=m;
                                for i=1:length(wait_time)
                                    if (wait_time(i)==0)
                                        wait_time(i)=tfim(idx)-tinicio(m);
                                        break;
                                    end
                                end
                                tinicio(m)=tfim(idx);
                                tfim(m)=tinicio(m)+tdur(m);
                                [tfim_ord, idx_tfim]=sort(tfim);
                                state_vars.occupiedOpe=state_vars.occupiedOpe+1;
                                state_vars.acccalls=state_vars.acccalls+1;
                                wait_R=1;
                                break;
                            else
                                m = min(Linhas(Linhas>m));
                            end
                        else
                            break;
                        end
                        
                        
                    end
                else
                   
                end
            end
            [tfim_ord, idx_tfim]=sort(tfim);
            tfim=tfim;
            tinicio=tinicio;
        end
    else
        [tfim_ord, idx_tfim]=sort(tfim);
        tfim=tfim;
        tinicio=tinicio;
    end
    Updatedwait_time=wait_time;
    updated_Operators=Operators;
    updated_Linhas=Linhas;
    updated_state_vars=state_vars;
end