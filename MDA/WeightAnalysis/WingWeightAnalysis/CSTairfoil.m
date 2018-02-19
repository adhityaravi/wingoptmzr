function y = CSTairfoil(A,x)

    N1 = 0.5;
    N2 = 1;

    C  = ((x.^N1)).*(1-x).^N2;

    % Create Bernstein polynomial
    n  = length(A);

    for v = 0:n-1
        Sx(v+1,:) = nchoosek(n-1,v)*x.^v.*(1-x).^(n-1-v);
    end

    yb = zeros(1,length(x));

    for i = 1:n
        yb(1,:) = yb(1,:) + A(i).*Sx(i,:);
    end

    [r_C, ~] = size(C);
    [r_yb,~] = size(yb);
    
    if r_C == r_yb 
        y = C  .* yb;
    else
        y = C' .* yb;
    end
    
end
