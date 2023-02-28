% Plot time output of the excitatory population

function status = TimeOutputE(t,u,flag,plotSol,x,p,parent, idx) 
  
%   arrange = u(idx(:,2));
%   u(idx(:,2)) = u(idx(:,3));
%   u(idx(:,3)) = [];
%   idx = idx(:,[1 3]);
  
  nx = size(idx,1);
  
  if isempty(flag)
%     disp(['t = ' num2str(max(t))]);
    if plotSol
      % PlotSolution(x,u(:,end),p,parent,idx,false);
      u = [u(:,end); FiringRateE(u(idx(:,1),end),u(idx(:,3),end),p(2),p(4),p(12),p(13))];
%       u = [u(:,1:3); FiringRateE(u(idx(:,1),end),u(idx(:,2),end),u(idx(:,3),end),p(2),p(4),p(8),p(10),p(14))];
%       PlotSolution(x,u,p,parent,[idx(:, [1 3]) [3*nx+1:4*nx]'],false);
%       drawnow;
    end
  end
  status = 0;

end
