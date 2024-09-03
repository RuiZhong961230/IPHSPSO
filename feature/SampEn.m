function SampEnVal = SampEn(data)
%SAMPEN  ����ʱ������ data ��������
%        data Ϊ������������
%        m Ϊ��ʼ�ֶΣ�ÿ�ε����ݳ���
%        r Ϊ��ֵ
N = length(data); 
m=1;
% r=0.2*sqrt(var(data));
r=0.1;
Nkx1 =  0; 
Nkx2 = 0; 
% �ֶμ�����룬 x1 Ϊ����Ϊ m�����У� x2 Ϊ����Ϊ m+1������
for k = N - m:-1:1   
    x1(k, :) = data(k:k + m - 1);
    x2(k, :) = data(k:k + m);
end
for k = N - m:-1:1
    x1temprow = x1(k, :); 
    x1temp    = ones(N - m, 1)*x1temprow; 
    dx1(k, :) = max(abs(x1temp - x1), [], 2); 
    Nkx1 = Nkx1 + (sum(dx1(k, :) < r) - 1 )/(N - m - 1); 
    % x2 ���м��㣬�� x1 ͬ������ 
    x2temprow = x2(k, :);
    x2temp    = ones(N - m, 1)*x2temprow; 
    dx2(k, :) = max(abs(x2temp - x2), [], 2); 
    Nkx2      = Nkx2 + (sum(dx2(k, :) < r) - 1 )/(N - m - 1);
end 
% ƽ��ֵ
Bmx1 = Nkx1/(N - m); 
Bmx2 = Nkx2/(N - m); 
% ������
SampEnVal = -log(Bmx2/Bmx1)

