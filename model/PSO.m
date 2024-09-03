
function [gbest,g,Convergence_curve]=PSO(N,T,lb,ub,dim,fobj)
%% ��������Ⱥ�㷨����
% N ��Ⱥ T �������� 
%% �����ʼ����Ⱥ
D=dim;                   %����ά��
c1=1.5;                 %ѧϰ����1
c2=1.5;                 %ѧϰ����2
w=0.8;                  %����Ȩ��

Xmax=ub;                %λ�����ֵ
Xmin=lb;               %λ����Сֵ
Vmax=ub;                %�ٶ����ֵ
Vmin=lb;               %�ٶ���Сֵ
%%
%%%%%%%%%%%%%%%%��ʼ����Ⱥ���壨�޶�λ�ú��ٶȣ�%%%%%%%%%%%%%%%%
lowerbound=ones(1,D).*(Xmin);                              % Lower limit for variables
upperbound=ones(1,D).*(Xmax);                              % Upper limit for variables
p = sobolset(D);
x=net(p,N) ;  
for i=1:D
    x(:,i)= lowerbound(i)+x(:,i).*(upperbound(i)-lowerbound(i));
end            %%sobol ��ʼ��

% x=rand(N,D).*(Xmax-Xmin)+Xmin;
v=rand(N,D).*(Vmax-Vmin)+Vmin;
%%%%%%%%%%%%%%%%%%��ʼ����������λ�ú�����ֵ%%%%%%%%%%%%%%%%%%%
p=x;
pbest=ones(N,1);
for i=1:N
    pbest(i)=fobj(x(i,:)); 
end
%%%%%%%%%%%%%%%%%%%��ʼ��ȫ������λ�ú�����ֵ%%%%%%%%%%%%%%%%%%
g=ones(1,D);
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
%%%%%%%%%%%���չ�ʽ���ε���ֱ�����㾫�Ȼ��ߵ�������%%%%%%%%%%%%%
for i=1:T
    i
    for j=1:N
        %%%%%%%%%%%%%%���¸�������λ�ú�����ֵ%%%%%%%%%%%%%%%%%
        if (fobj(x(j,:))) <pbest(j)
            p(j,:)=x(j,:);
            pbest(j)=fobj(x(j,:)); 
        end
        %%%%%%%%%%%%%%%%����ȫ������λ�ú�����ֵ%%%%%%%%%%%%%%%
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        %%%%%%%%%%%%%%%%%����λ�ú��ٶ�ֵ%%%%%%%%%%%%%%%%%%%%%
        v(j,:)=w*v(j,:)+c1*rand*((p(j,:)+g)./2-x(j,:))+c2*rand*((p(j,:)-g)./2-x(j,:));
            
        x(j,:)=x(j,:)+v(j,:);
        %%%%%%%%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%��¼����ȫ������ֵ%%%%%%%%%%%%%%%%%%%%%
   Convergence_curve(i)=gbest;%��¼ѵ��������Ӧ��ֵ

end



