function Xi = FiringRateE(v, k, h, beta, kStar, kStar2)


   % S = 0.5 ./ (1 + exp(- beta * (v - h) ));

   Xi = zeros(size(v));

   % id = find(  k<= kStar );
   % S(id) =  0.5 ./ (1 + exp(- beta * (v(id) - h) ));

   % id = find( (k >= kStar) & (k <= 1.8) );
   % S(id) =  1.0 ./ (1 + exp(- beta * (v(id) - h) ));

   Xi =  (k<kStar) .* 0.5 ./ (1 + exp(- beta * (v - h) ))...
     +  (k>=kStar) .* (k <= kStar2) ./ (1 + exp(- beta * (v - h) ));
 
   % Mollify = @(k,kStar) 1./(1+exp(-200*(k-kStar)));
   % m = Mollify(k,kStar);
   % S =  (1-m) .* 0.5 ./ (1 + exp(- beta * (v - h) ))...
   %   +     m .* (1-Mollify(k,1.8)) ./ (1 + exp(- beta * (v - h) ));

end
