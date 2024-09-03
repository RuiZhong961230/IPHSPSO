function SampEnVal = SampEn(data)
%SAMPEN  计算时间序列 data 的样本熵
%        data 为输入数据序列
%        m 为初始分段，每段的数据长度
%        r 为阈值
N = length(data); 
m=1;
% r=0.2*sqrt(var(data));
r=0.1;
Nkx1 =  0; 
Nkx2 = 0; 
% 分段计算距离， x1 为长度为 m的序列， x2 为长度为 m+1的序列
for k = N - m:-1:1   
    x1(k, :) = data(k:k + m - 1);
    x2(k, :) = data(k:k + m);
end
for k = N - m:-1:1
    x1temprow = x1(k, :); 
    x1temp    = ones(N - m, 1)*x1temprow; 
    dx1(k, :) = max(abs(x1temp - x1), [], 2); 
    Nkx1 = Nkx1 + (sum(dx1(k, :) < r) - 1 )/(N - m - 1); 
    % x2 序列计算，和 x1 同样方法 
    x2temprow = x2(k, :);
    x2temp    = ones(N - m, 1)*x2temprow; 
    dx2(k, :) = max(abs(x2temp - x2), [], 2); 
    Nkx2      = Nkx2 + (sum(dx2(k, :) < r) - 1 )/(N - m - 1);
end 
% 平均值
Bmx1 = Nkx1/(N - m); 
Bmx2 = Nkx2/(N - m); 
% 样本熵
SampEnVal = -log(Bmx2/Bmx1)

