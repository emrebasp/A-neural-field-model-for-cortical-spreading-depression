% Plot time output of the inhibitory population

function status = TimeOutputI(t,u,flag,plotSol,x,p,parent,idx) 
  
%   arrange = u(idx(:,1),end);
%   u(idx(:,1),end) = u(idx(:,2),end);
%   u(idx(:,2),end) = u(idx(:,3),end);
%   u(idx(:,3),end) = [];
%   idx = idx(:,2:3);
  nx = size(idx,1);
  
  if isempty(flag)
    disp(['t = ' num2str(max(t))]);
    if plotSol
      % PlotSolution(x,u(:,end),p,parent,idx,false);
%       u = u()
      u = [u(:,end); FiringRateI(u(idx(:,2),end),u(idx(:,3),end),p(3),p(5),p(14),p(15))];
%       PlotSolution(x,u,p,parent,[idx [3*nx+1:4*nx]'],false);
      PlotSolution(x,u,p,parent,[idx(:, [2 3]) [3*nx+1:4*nx]'],false);
      drawnow;
    end
  end
  status = 0;

end
