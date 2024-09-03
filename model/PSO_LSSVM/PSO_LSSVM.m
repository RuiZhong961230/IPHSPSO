%%  ��ջ������� T_sim1 Ϊѵ������Ԥ����  T_sim2 Ϊ���Լ���Ԥ����
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������
addpath('LSSVMlabv')
%% ��������
load Cell1.mat
load Cell2.mat
load Cell3.mat
load Cell4.mat
load Cell5.mat
load Cell6.mat
load Cell7.mat
load Cell8.mat
CE_CELL=8;%%ָ���ǲ����ǿ���
if CE_CELL==1 
    xunlian=[Cell2; Cell3; Cell4; Cell5; Cell6; Cell7; Cell8];
    ceshi=Cell1; 
end
if CE_CELL==2 
    xunlian=[Cell1; Cell3; Cell4; Cell5; Cell6; Cell7; Cell8];
    ceshi=Cell2; 
end
if CE_CELL==3 
    xunlian=[Cell2; Cell1; Cell4; Cell5; Cell6; Cell7; Cell8];
    ceshi=Cell3; 
end
if CE_CELL==4 
    xunlian=[Cell2; Cell3; Cell1; Cell5; Cell6; Cell7; Cell8];
    ceshi=Cell4; 
end
if CE_CELL==5 
    xunlian=[Cell2; Cell3; Cell4; Cell1; Cell6; Cell7; Cell8];
    ceshi=Cell5; 
end
if CE_CELL==6
    xunlian=[Cell2; Cell3; Cell4; Cell5; Cell1; Cell7; Cell8];
    ceshi=Cell6; 
end
if CE_CELL==7 
    xunlian=[Cell2; Cell3; Cell4; Cell5; Cell6; Cell1; Cell8];
    ceshi=Cell7; 
end
if CE_CELL==8 
    xunlian=[Cell2; Cell3; Cell4; Cell5; Cell6; Cell7; Cell1];
    ceshi=Cell8; 
end
[m,n]=size(xunlian);
%%  �������� nasa
P_train =xunlian(:,1:2)';%1*num  %     
T_train= xunlian(:,n)'; %1*����-num
% ���Լ�����
P_test=ceshi(:,1:2)';        %
T_test=ceshi(:,n)';        %
%%ʹ�õ�һ������ʱ
%P_train =xunlian(:,1)';%1*num  %     
%T_train= xunlian(:,n)'; %1*����-num
% % ���Լ�����
%P_test=ceshi(:,1)';        %
%T_test=ceshi(:,n)';        %
%%ʹ�õڶ�������
%P_train =xunlian(:,2)';%1*num  %     
%T_train= xunlian(:,n)'; %1*����-num
% % ���Լ�����
%P_test=ceshi(:,2)';        %
%T_test=ceshi(:,n)';        %
%%  ����ѵ�����Ͳ��Լ�
M = size(P_train, 2);
N = size(P_test, 2);

%%  ���ݹ�һ��
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ת������Ӧģ��
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  ��������
pop = 10;              % ��Ⱥ��Ŀ
Max_iter = 10;         % ��������
dim = 2;               % �Ż���������
lb = [50,   1];       % ����
ub = [100, 100];       % ����

%% �Ż�����
fobj = @(x)fitnessfunclssvm(x, p_train, t_train);

%% �Ż�
[Best_pos, Best_score, curve] = PSO(pop, Max_iter, lb, ub, dim, fobj);
% CURCE=[CURCE curve ];
%% LSSVM��������
type       = 'f';                % ģ������ �ع�
kernel     = 'RBF_kernel';       % RBF �˺���
proprecess = 'preprocess';       % �Ƿ��һ��

%% ����ģ��
gam = Best_score(1);  
sig = Best_score(2);
model = initlssvm(p_train, t_train, type, gam, sig, kernel, proprecess);

%% ѵ��ģ��
model = trainlssvm(model);

%% ģ��Ԥ��
t_sim1 = simlssvm(model, p_train);
t_sim2 = simlssvm(model, p_test);

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  ���������
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%% �Ż�����
figure
plot(curve, 'linewidth', 1.5);
title('PSO-LSSVM ��������')
xlabel('��������')
ylabel('��Ӧ��')
grid on;

%%  ���������
toc
%% ע�����ά��

T_sim1=T_sim1';
T_sim2=T_sim2';

% figure;
% plotregression(T_test,T_sim2,['�ع�ͼ']);
% figure;
% ploterrhist(T_test-T_sim2,['���ֱ��ͼ']);
%%  ��������� RMSE
error1 = sqrt(sum((T_sim1 - T_train).^2)./M);
error2 = sqrt(sum((T_test - T_sim2).^2)./N);

%%
%����ϵ��
R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;

%%
%������� MSE
mse1 = sum((T_sim1 - T_train).^2)./M;
mse2 = sum((T_sim2 - T_test).^2)./N;
%%
%RPD ʣ��Ԥ��в�
SE1=std(T_sim1-T_train);
RPD1=std(T_train)/SE1;

SE=std(T_sim2-T_test);
RPD2=std(T_test)/SE;
%% ƽ���������MAE
MAE1 = mean(abs(T_train - T_sim1));
MAE2 = mean(abs(T_test - T_sim2));
%% ƽ�����԰ٷֱ����MAPE
MAPE1 = mean(abs((T_train - T_sim1)./T_train));
MAPE2 = mean(abs((T_test - T_sim2)./T_test));
%%  ѵ������ͼ
% figure
% %plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','LineWidth',1)
% plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','LineWidth',1.5)
% legend('��ʵֵ','PSO-LSSVMԤ��ֵ')
% xlabel('Ԥ������')
% ylabel('Ԥ����')
% string={'ѵ����Ԥ�����Ա�';['(R^2 =' num2str(R1) ' RMSE= ' num2str(error1) ' MSE= ' num2str(mse1) ' RPD= ' num2str(RPD1) ')' ]};
% title(string)
% %% Ԥ�⼯��ͼ
figure
plot(1:N,T_test,'r-*',1:N,T_sim2,'b-o','LineWidth',1.5)
legend('��ʵֵ','PSO-LSSVMԤ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
%string={'���Լ�Ԥ�����Ա�';['(R^2 =' num2str(R2) ' RMSE= ' num2str(error2)  ' MSE= ' num2str(mse2) ' RPD= ' num2str(RPD2) ')']};
string={'���Լ�Ԥ�����Ա�'};
title(string)

% %% ���Լ����ͼ
figure  
ERROR3=T_test-T_sim2;
plot(T_test-T_sim2,'b-*','LineWidth',1.5)
xlabel('���Լ��������')
ylabel('Ԥ�����')
title('���Լ�Ԥ�����')
grid on;
legend('PSO-LSSVMԤ��������')
%% �����������ͼ
%% ѵ�������Ч��ͼ
figure
plot(T_train,T_sim1,'*r');
xlabel('��ʵֵ')
ylabel('Ԥ��ֵ')
string = {'ѵ����Ч��ͼ';['R^2_c=' num2str(R1)  '  RMSEC=' num2str(error1) ]};
title(string)
hold on ;h=lsline;
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% Ԥ�⼯���Ч��ͼ
figure
plot(T_test,T_sim2,'ob');
xlabel('��ʵֵ')
ylabel('Ԥ��ֵ')
string1 = {'���Լ�Ч��ͼ';['R^2_p=' num2str(R2)  '  RMSEP=' num2str(error2) ]};
title(string1)
hold on ;h=lsline();
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% ��ƽ��
R3=(R1+R2)./2;
error3=(error1+error2)./2;
%% ����������Ԥ�����ͼ
tsim=[T_sim1,T_sim2]';
S=[T_train,T_test]';
figure
plot(S,tsim,'ob');
xlabel('��ʵֵ')
ylabel('Ԥ��ֵ')
string1 = {'�����������Ԥ��ͼ';['R^2_p=' num2str(R3)  '  RMSEP=' num2str(error3) ]};
title(string1)
hold on ;h=lsline();
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% ��ӡ������ָ��
disp(['-----------------------������--------------------------'])
disp(['���۽��������ʾ��'])
disp(['ƽ���������MAEΪ��',num2str(MAE2)])
disp(['�������MSEΪ��       ',num2str(mse2)])
disp(['���������RMSEPΪ��  ',num2str(error2)])
disp(['����ϵ��R^2Ϊ��  ',num2str(R2)])
disp(['ʣ��Ԥ��в�RPDΪ��  ',num2str(RPD2)])
disp(['ƽ�����԰ٷֱ����MAPEΪ��  ',num2str(MAPE2)])
grid
if CE_CELL==1 
    lssvm_1=T_sim2;
    save('lssvm_1.mat','lssvm_1') ;
end
if CE_CELL==2 
    lssvm_2=T_sim2;
    save('lssvm_2.mat','lssvm_2') ; 
end
if CE_CELL==3
    lssvm_3=T_sim2;
    save('lssvm_3.mat','lssvm_3') ;
end
if CE_CELL==4 
    lssvm_4=T_sim2;
   save('lssvm_4.mat','lssvm_4') ; 
end
if CE_CELL==5 
    lssvm_5=T_sim2;
    save('lssvm_5.mat','lssvm_5') ;
end
if CE_CELL==6
    lssvm_6=T_sim2;
    save('lssvm_6.mat','lssvm_6') ;
end
if CE_CELL==7 
    lssvm_7=T_sim2;
    save('lssvm_7.mat','lssvm_7') ;
end
if CE_CELL==8
    lssvm_8=T_sim2;
    save('lssvm_8.mat','lssvm_8') ;
end