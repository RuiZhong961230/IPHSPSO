
function [gbest,g,Convergence_curve]=PSO(N,T,lb,ub,dim,fobj)
%% 定义粒子群算法参数
% N 种群 T 迭代次数 
%% 随机初始化种群
D=dim;                   %粒子维数
c1=1.5;                 %学习因子1
c2=1.5;                 %学习因子2
w=0.8;                  %惯性权重

Xmax=ub;                %位置最大值
Xmin=lb;               %位置最小值
Vmax=ub;                %速度最大值
Vmin=lb;               %速度最小值
%%
%%%%%%%%%%%%%%%%初始化种群个体（限定位置和速度）%%%%%%%%%%%%%%%%
lowerbound=ones(1,D).*(Xmin);                              % Lower limit for variables
upperbound=ones(1,D).*(Xmax);                              % Upper limit for variables
p = sobolset(D);
x=net(p,N) ;  
for i=1:D
    x(:,i)= lowerbound(i)+x(:,i).*(upperbound(i)-lowerbound(i));
end            %%sobol 初始化

% x=rand(N,D).*(Xmax-Xmin)+Xmin;
v=rand(N,D).*(Vmax-Vmin)+Vmin;
%%%%%%%%%%%%%%%%%%初始化个体最优位置和最优值%%%%%%%%%%%%%%%%%%%
p=x;
pbest=ones(N,1);
for i=1:N
    pbest(i)=fobj(x(i,:)); 
end
%%%%%%%%%%%%%%%%%%%初始化全局最优位置和最优值%%%%%%%%%%%%%%%%%%
g=ones(1,D);
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
%%%%%%%%%%%按照公式依次迭代直到满足精度或者迭代次数%%%%%%%%%%%%%
for i=1:T
    i
    for j=1:N
        %%%%%%%%%%%%%%更新个体最优位置和最优值%%%%%%%%%%%%%%%%%
        if (fobj(x(j,:))) <pbest(j)
            p(j,:)=x(j,:);
            pbest(j)=fobj(x(j,:)); 
        end
        %%%%%%%%%%%%%%%%更新全局最优位置和最优值%%%%%%%%%%%%%%%
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        %%%%%%%%%%%%%%%%%跟新位置和速度值%%%%%%%%%%%%%%%%%%%%%
        v(j,:)=w*v(j,:)+c1*rand*((p(j,:)+g)./2-x(j,:))+c2*rand*((p(j,:)-g)./2-x(j,:));
            
        x(j,:)=x(j,:)+v(j,:);
        %%%%%%%%%%%%%%%%%%%%边界条件处理%%%%%%%%%%%%%%%%%%%%%%
        if length(Vmax)==1
            for ii=1:D
                if (v(j,ii)>Vmax)  |  (v(j,ii)< Vmin)
                    v(j,ii)=rand * (Vmax-Vmin)+Vmin;
                end
                if (x(j,ii)>Xmax)  |  (x(j,ii)< Xmin)
                    x(j,ii)=rand * (Xmax-Xmin)+Xmin;
                end
            end           
        else
            for ii=1:D
                if (v(j,ii)>Vmax(ii))  |  (v(j,ii)< Vmin(ii))
                    v(j,ii)=rand * (Vmax(ii)-Vmin(ii))+Vmin(ii);
                end
                if (x(j,ii)>Xmax(ii))  |  (x(j,ii)< Xmin(ii))
                    x(j,ii)=rand * (Xmax(ii)-Xmin(ii))+Xmin(ii);
                end
            end
        end
            
    end
    %%%%%%%%%%%%%%%%%%%%记录历代全局最优值%%%%%%%%%%%%%%%%%%%%%
   Convergence_curve(i)=gbest;%记录训练集的适应度值

end



