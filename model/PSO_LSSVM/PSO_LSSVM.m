%%  清空环境变量 T_sim1 为训练集的预测结果  T_sim2 为测试集的预测结果
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行
addpath('LSSVMlabv')
%% 导入数据
load Cell1.mat
load Cell2.mat
load Cell3.mat
load Cell4.mat
load Cell5.mat
load Cell6.mat
load Cell7.mat
load Cell8.mat
CE_CELL=8;%%指的是测试那块电池
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
%%  导入数据 nasa
P_train =xunlian(:,1:2)';%1*num  %     
T_train= xunlian(:,n)'; %1*总数-num
% 测试集——
P_test=ceshi(:,1:2)';        %
T_test=ceshi(:,n)';        %
%%使用第一个特征时
%P_train =xunlian(:,1)';%1*num  %     
%T_train= xunlian(:,n)'; %1*总数-num
% % 测试集——
%P_test=ceshi(:,1)';        %
%T_test=ceshi(:,n)';        %
%%使用第二个特征
%P_train =xunlian(:,2)';%1*num  %     
%T_train= xunlian(:,n)'; %1*总数-num
% % 测试集——
%P_test=ceshi(:,2)';        %
%T_test=ceshi(:,n)';        %
%%  划分训练集和测试集
M = size(P_train, 2);
N = size(P_test, 2);

%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  转置以适应模型
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  参数设置
pop = 10;              % 种群数目
Max_iter = 10;         % 迭代次数
dim = 2;               % 优化参数个数
lb = [50,   1];       % 下限
ub = [100, 100];       % 上限

%% 优化函数
fobj = @(x)fitnessfunclssvm(x, p_train, t_train);

%% 优化
[Best_pos, Best_score, curve] = PSO(pop, Max_iter, lb, ub, dim, fobj);
% CURCE=[CURCE curve ];
%% LSSVM参数设置
type       = 'f';                % 模型类型 回归
kernel     = 'RBF_kernel';       % RBF 核函数
proprecess = 'preprocess';       % 是否归一化

%% 建立模型
gam = Best_score(1);  
sig = Best_score(2);
model = initlssvm(p_train, t_train, type, gam, sig, kernel, proprecess);

%% 训练模型
model = trainlssvm(model);

%% 模型预测
t_sim1 = simlssvm(model, p_train);
t_sim2 = simlssvm(model, p_test);

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  均方根误差
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%% 优化曲线
figure
plot(curve, 'linewidth', 1.5);
title('PSO-LSSVM 迭代曲线')
xlabel('迭代次数')
ylabel('适应度')
grid on;

%%  均方根误差
toc
%% 注意变量维度

T_sim1=T_sim1';
T_sim2=T_sim2';

% figure;
% plotregression(T_test,T_sim2,['回归图']);
% figure;
% ploterrhist(T_test-T_sim2,['误差直方图']);
%%  均方根误差 RMSE
error1 = sqrt(sum((T_sim1 - T_train).^2)./M);
error2 = sqrt(sum((T_test - T_sim2).^2)./N);

%%
%决定系数
R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test -  T_sim2)^2 / norm(T_test -  mean(T_test ))^2;

%%
%均方误差 MSE
mse1 = sum((T_sim1 - T_train).^2)./M;
mse2 = sum((T_sim2 - T_test).^2)./N;
%%
%RPD 剩余预测残差
SE1=std(T_sim1-T_train);
RPD1=std(T_train)/SE1;

SE=std(T_sim2-T_test);
RPD2=std(T_test)/SE;
%% 平均绝对误差MAE
MAE1 = mean(abs(T_train - T_sim1));
MAE2 = mean(abs(T_test - T_sim2));
%% 平均绝对百分比误差MAPE
MAPE1 = mean(abs((T_train - T_sim1)./T_train));
MAPE2 = mean(abs((T_test - T_sim2)./T_test));
%%  训练集绘图
% figure
% %plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','LineWidth',1)
% plot(1:M,T_train,'r-*',1:M,T_sim1,'b-o','LineWidth',1.5)
% legend('真实值','PSO-LSSVM预测值')
% xlabel('预测样本')
% ylabel('预测结果')
% string={'训练集预测结果对比';['(R^2 =' num2str(R1) ' RMSE= ' num2str(error1) ' MSE= ' num2str(mse1) ' RPD= ' num2str(RPD1) ')' ]};
% title(string)
% %% 预测集绘图
figure
plot(1:N,T_test,'r-*',1:N,T_sim2,'b-o','LineWidth',1.5)
legend('真实值','PSO-LSSVM预测值')
xlabel('预测样本')
ylabel('预测结果')
%string={'测试集预测结果对比';['(R^2 =' num2str(R2) ' RMSE= ' num2str(error2)  ' MSE= ' num2str(mse2) ' RPD= ' num2str(RPD2) ')']};
string={'测试集预测结果对比'};
title(string)

% %% 测试集误差图
figure  
ERROR3=T_test-T_sim2;
plot(T_test-T_sim2,'b-*','LineWidth',1.5)
xlabel('测试集样本编号')
ylabel('预测误差')
title('测试集预测误差')
grid on;
legend('PSO-LSSVM预测输出误差')
%% 绘制线性拟合图
%% 训练集拟合效果图
figure
plot(T_train,T_sim1,'*r');
xlabel('真实值')
ylabel('预测值')
string = {'训练集效果图';['R^2_c=' num2str(R1)  '  RMSEC=' num2str(error1) ]};
title(string)
hold on ;h=lsline;
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% 预测集拟合效果图
figure
plot(T_test,T_sim2,'ob');
xlabel('真实值')
ylabel('预测值')
string1 = {'测试集效果图';['R^2_p=' num2str(R2)  '  RMSEP=' num2str(error2) ]};
title(string1)
hold on ;h=lsline();
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% 求平均
R3=(R1+R2)./2;
error3=(error1+error2)./2;
%% 总数据线性预测拟合图
tsim=[T_sim1,T_sim2]';
S=[T_train,T_test]';
figure
plot(S,tsim,'ob');
xlabel('真实值')
ylabel('预测值')
string1 = {'所有样本拟合预测图';['R^2_p=' num2str(R3)  '  RMSEP=' num2str(error3) ]};
title(string1)
hold on ;h=lsline();
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
%% 打印出评价指标
disp(['-----------------------误差计算--------------------------'])
disp(['评价结果如下所示：'])
disp(['平均绝对误差MAE为：',num2str(MAE2)])
disp(['均方误差MSE为：       ',num2str(mse2)])
disp(['均方根误差RMSEP为：  ',num2str(error2)])
disp(['决定系数R^2为：  ',num2str(R2)])
disp(['剩余预测残差RPD为：  ',num2str(RPD2)])
disp(['平均绝对百分比误差MAPE为：  ',num2str(MAPE2)])
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