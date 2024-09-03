function fitness = fitnessfunclssvm(x, p_train, t_train)
%% ������Ӧ�Ⱥ���

%% �õ��Ż�����
gam = x(1);
sig = x(2);

%% ��������
type = 'f';                  % ģ�����ͻع�
kernel= 'RBF_kernel';        % RBF �˺���
proprecess = 'preprocess';   % �Ƿ��һ��

%% ����ģ��
model = initlssvm(p_train, t_train, type, gam, sig, kernel, proprecess);

%% ģ��ѵ��
model = trainlssvm(model);

%% Ԥ��
t_sim = simlssvm(model, p_train);

%% �õ���Ӧ��ֵ
fitness = sqrt(mse(t_sim - t_train));

end