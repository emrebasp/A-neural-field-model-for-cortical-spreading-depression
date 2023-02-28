function F = NeuralFieldWithDiffusible(t,z,p,Dxx,wHat,x,Lx,idx,tau)

% %   % Rename parameters
% %   delta       = p(1);
% %   he          = p(2);
% %   hi          = p(3);
% %   betae       = p(4);
% %   betai       = p(5);
% %   S0e         = p(6);
% %   S0i         = p(7);
% %   veStar      = p(8);
% %   viStar      = p(9);
% %   keStar      = p(10);
% %   kiStar      = p(11);
% %   c1          = p(12);
% %   c2          = p(13);
% %   crossConnEI = p(14);
% %   crossConnIE = p(15);
% %   nx          = size(z,1)/2;
  
  
  
    % Rename parameters
  delta       = p(1);
  he          = p(2);
  hi          = p(3);
  betae       = p(4);
  betai       = p(5);
  betave      = p(6);
  betavi      = p(7);
  S0e         = p(8);
  S0i         = p(9);
  veStar      = p(10);
  viStar      = p(11);
  keStar      = p(12);
  keStar2     = p(13);
  kiStar      = p(14);
  kiStar2     = p(15);
  kveStar     = p(16);
  kviStar     = p(17);
  c1          = p(18);
  c2          = p(19);
  cie         = p(20);
  cei         = p(21);
  cee         = p(22);
  cii         = p(23);
  tau         = p(26);
  nx          = size(z,1)/2;
  

  % Split variables
  iVe = idx(:,1); ve = z(iVe);
  iVi = idx(:,2); vi = z(iVi); 
  iK = idx(:,3); k = z(iK);

  % Convolution between w and firing rate
  Se     = FiringRateE(ve,k,he,betae,keStar,keStar2);
  SeConv = (2*Lx/nx)*ifftshift(real(ifft(fft(Se) .* wHat)));
  Si     = FiringRateI(vi,k,hi,betai,kiStar,kiStar2);
  SiConv = (2*Lx/nx)*ifftshift(real(ifft(fft(Si) .* wHat)));

  % Coupling functions (tentative)
  % gv = @(v,k) 1 ./ (1 + exp(- beta * (k - kStar) ));
  % gk = @(S) zeros(size(S));
  SeStar  = FiringRateE(veStar,keStar,he,betae,keStar,keStar2);
  SiStar  = FiringRateI(viStar,kiStar,hi,betai,kiStar,kiStar2);
  gve = @(ve,k) 1 ./ (1 + exp(- betave * (k - kveStar) ));
  gvi = @(vi,k) 1 ./ (1 + exp(- betavi * (k - kviStar) ));
%   gk = @(Se, Si) 3 ./ (c1.*cosh(10*(Se-1.5*SeStar)) + c2.*cosh(10*(Si-1.5*SiStar)));
  gke = @(Se) 3 ./ cosh(10*(Se-1.5*SeStar));
  gki = @(Si) 3 ./ cosh(10*(Si-1.5*SiStar));

  % External potassium influx
  %   I = @(x,t) 6*(t <= 5)./cosh(0.4*x).^2;
      I = @(x,t,tscale) 3*(t>=2*tscale).*(t <= 4*tscale)./cosh(0.4*x).^2;
  %   I = @(x,t) 3*(t>=2).*(t <= 5)./cosh(0.4*x).^2;
%   I = @(x,t) zeros(size(x));
    
  F = zeros(size(z));
  F(iVe) = (1/tau)*(-ve + cie*SiConv + cee*SeConv + gve(ve,k));
  F(iVi) = (1/tau)*(-vi + cei*SeConv + cii*SiConv + gvi(vi,k));
%   F(iK) = (1/tau)*(delta*Dxx*k + c1*gke(Se) + c2*gki(Si)  + I(x,t,tau));
F(iK) = (1/tau)*(delta*Dxx*k + c1*gke(Se) + c2*gki(Si)  + I(x,t,tau));

end

 
