function [x,wHat,W,Dxx] = LinearOperators(nx,Lx);

  % Grid parameters
  hx = 2*Lx/(nx-1); x = -Lx + [0:nx-1]'*hx; 
  
  % Synaptic kernel function
  wFun = @(x) 0.5*exp(-abs(x));

  % FFT
  wHat = fft(wFun(x));

  % Integration weights
  rho = ones(size(x)); rho(1) = 0.5; rho(nx) = 0.5; rho = rho*hx;

  % Synaptic matrix (on a circle)
  y = wFun(x);
  iRows = 1:nx;
  iShift = -nx/2:nx/2-1;
  for i = 1:nx
    W(iRows(i),:) = circshift( y, iShift(i));
  end
  W = W*hx;

  % Ancillary vector of ones for differentiation matrix
  e = ones(nx,1); 

  % Differentiation matrix in x: finite differences with periodic BCs
  Dxx = spdiags([e -2*e e], [-1 0 1], nx, nx); Dxx(1,nx) = 1; Dxx(nx,1) = 1; Dxx = Dxx/hx^2;

end

