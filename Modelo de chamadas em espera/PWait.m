function [pw]=PWait(N, A)

    num = A^N/factorial(N);
    den=0;

    for k = 0:1:N-1
        den = den + A^k/factorial(k);
    end

    den = den + A^N/factorial(N)*(A/(N-A));
    pw = num/den;
end

