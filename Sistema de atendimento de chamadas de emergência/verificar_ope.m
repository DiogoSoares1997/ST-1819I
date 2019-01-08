function [ existente ] = verificar_ope( Operadores,idx )
for idx_line=1:length(Operadores)
    if(Operadores(idx_line)==idx)
        existente=true;
        return
    end
end
existente=false;


end

