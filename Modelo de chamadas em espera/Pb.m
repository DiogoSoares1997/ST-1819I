function result = Pb( A,N )
somatorio=0;
top = ((A^N)/factorial(N));
for indice = 1:1:N
    
   somatorio = somatorio + ((A^indice)/factorial(indice)); 
end

result = top/somatorio;
