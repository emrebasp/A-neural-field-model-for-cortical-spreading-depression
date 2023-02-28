function plotHandle = PlotSolution(x,u,p,parentHandle,idx,reflect)

   %% Position and eventually grab figure
   if isempty(parentHandle)
     scrsz = get(0,'ScreenSize');
     plotHandle = figure('Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/4]);
     parentHandle = plotHandle;
    else
      plotHandle = parentHandle;
   end

   figure(parentHandle);

   %% Extract number of components
   numComp = size(idx,2);

   %% 1D plot
   for k = 1:numComp
     subplot(numComp,1,k);
     if ~reflect
       plot(x,u(idx(:,k)),'.-');
     else
       plot([-x(end:-1:2); x],[u(idx(end:-1:2,k)); u(idx(:,k))],'.-');
     end
     hold on;
     if k == 1
       vStar = p(11);
       plot(x,vStar*ones(size(x)),'r');
       title(['Voltage']);
     end
     if k == 2
       kStar = p(14);
       plot(x,kStar*ones(size(x)),'r');
       title(['Potassium']);
     end
     if k == 3
       title(['Rate']);
     end
     xlabel('x');
     hold off;

   end

   %% Save
   % print -depsc state.eps
   % print -dtiff state.tiff

end

