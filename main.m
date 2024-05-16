clc;
clear;
close all;

% 生成随机数据点
rng(1); % 设置随机数种子以确保结果可重复
n = 100; % 总数据点数
x = linspace(0, 10, n); % 生成x坐标
y = 2 * x + 1 + randn(1, n); % 生成带有噪声的y坐标

% 添加离群值
outliers_idx = randsample(n, 10); % 随机选择10个离群值的索引
y(outliers_idx) = y(outliers_idx) + 30 * randn(1, 10); % 在离群值上增加更大的噪声

% 绘制数据点
scatter(x, y, 'b', 'filled');
hold on;

% RANSAC参数
num_iterations = 1000; % 迭代次数
inlier_threshold = 2; % 内点阈值

best_model = [];
best_inliers = [];
best_num_inliers = 0;

for iteration = 1:num_iterations
    % 随机选择两个点来拟合直线模型
    sample_indices = randsample(n, 2);
    x_sample = x(sample_indices);
    y_sample = y(sample_indices);
    
    % 拟合直线模型（y = mx + b）
    coeff = polyfit(x_sample, y_sample, 1);
    m = coeff(1);
    b = coeff(2);
    
    % 计算所有点到直线的距离
    distances = abs(y - (m * x + b));
    
    % 根据阈值判断内点和外点
    inliers = find(distances < inlier_threshold);
    num_inliers = length(inliers);
    
    % 更新最佳模型
    if num_inliers > best_num_inliers
        best_model = [m, b];
        best_inliers = inliers;
        best_num_inliers = num_inliers;
    end
end

% 用最佳模型拟合内点
x_inliers = x(best_inliers);
y_inliers = y(best_inliers);
best_coeff = polyfit(x_inliers, y_inliers, 1);
best_m = best_coeff(1);
best_b = best_coeff(2);

% 绘制拟合直线
x_range = linspace(0, 10, 100);
y_fit = best_m * x_range + best_b;
plot(x_range, y_fit, 'r', 'LineWidth', 2);

hold off;
legend('数据点', 'RANSAC拟合');
title('RANSAC直线拟合示例');
xlabel('X坐标');
ylabel('Y坐标');
