function fitness = fitnessfunclssvm(x, p_train, t_train)
%% 定义适应度函数

%% 得到优化参数
gam = x(1);
sig = x(2);

%% 参数设置
type = 'f';                  % 模型类型回归
kernel= 'RBF_kernel';        % RBF 核函数
proprecess = 'preprocess';   % 是否归一化

%% 建立模型
model = initlssvm(p_train, t_train, type, gam, sig, kernel, proprecess);

%% 模型训练
model = trainlssvm(model);

%% 预测
t_sim = simlssvm(model, p_train);

%% 得到适应度值
fitness = sqrt(mse(t_sim - t_train));

end