function [ tinicio, idx_tfim, tfim_ord, tdur, tlinha, tfim ] = wait_time( tdur,tchamadas, wait_time )
% Sequenciacao das chamadas
tinicio=tchamadas(1);
tfim=tchamadas(1)+tdur(1);

for n=2:length(tchamadas)
    tinicio(n)=tinicio(n-1)+tchamadas(n);
    tfim(n)=tinicio(n)+ tdur(n)+ wait_time;
end

tfim_ori=tfim;
tlinha=zeros(size(tinicio));
% Ordenacao dos eventos de fim de chamada guardando
% os indices no vetor idx_tfim
[tfim_ord idx_tfim]=sort(tfim);

end

