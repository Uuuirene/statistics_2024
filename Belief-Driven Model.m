%% ======================================================================
% 信念決策建模系統 (Belief-Driven Decision Modeling System)
% 版本: 2.1
% 核心功能:
%   1. 認知參數估計 (GLM框架)
%   2. 行為風險評分 (ANOVA交互分析)
%   3. 決策儀表板生成 (自動化報告)
% 適用場景:  決策研究 ｜風控 
% =======================================================================

%% -------------------------------
%% 模組1: 認知參數商業化評估系統
%% -------------------------------
fprintf('\n=== 認知參數分析系統啟動 ===\n');

% 模擬商業場景數據 (N=200虛擬員工)
% rng(2023); 
employee_data = struct();
employee_data.risk_tolerance = randn(200,1)*0.5 + 1; % 風險容忍度 ~ μ = 1, σ = 0.5，（原 Massey & Wu 2005 --Decision Weight: ALPHA & BETA）
employee_data.signal_sensitivity = randn(200,1)*0.3 + 0.8; % 信號敏感度 ~ μ = 0.8, σ = 0.3
employee_data.env_transition_prob = [0.01*ones(100,1); 0.1*ones(100,1)]; % 市場狀態轉換機率
employee_data.direction = [ones(100,1); -ones(100,1)]; % 投資市場方向 (1:壞到好，牛市, -1:好到壞，熊市)

behavior_table = struct2table(employee_data);


%% GLM模型1: 風險容忍度 vs 市場環境
fprintf('\n[GLM分析1] 風險容忍度環境適應性\n');
mdl_risk = fitglm(behavior_table, ...
    'risk_tolerance ~ env_transition_prob * direction', ...
    'CategoricalVars', {'direction'});
disp(mdl_risk);

risk_coef = mdl_risk.Coefficients;
fprintf('\n=== 商業洞察 ===\n');
fprintf('當市場擴張時(direction=1)，環境轉換機率每增加0.1:\n');
fprintf('  -> 風險容忍度提升%.2f單位 (p=%.3f)\n', ...
    risk_coef.Estimate(3)*10, risk_coef.pValue(3));

%% GLM模型2: 信號敏感度分析
fprintf('\n[GLM分析2] 信號處理能力診斷\n');
mdl_signal = fitglm(behavior_table, ...
    'signal_sensitivity ~ env_transition_prob + direction', ...
    'CategoricalVars', {'direction'});
disp(mdl_signal);

%% -------------------------------
%% 模組2: 行為風險評分系統
%% -------------------------------
fprintf('\n=== 行為風險評分生成 ===\n');

% 情境設計矩陣 (2x2因子設計)
conditions = {'LowRisk_HighSignal', 'LowRisk_LowSignal', ...
              'HighRisk_HighSignal', 'HighRisk_LowSignal'};

% 模擬投資決策數據 (4條件 x 50人)
investment_rates = zeros(200,1);
investment_rates(1:50)   = 0.6 + randn(50,1)*0.1; % 低風險高信號
investment_rates(51:100) = 0.4 + randn(50,1)*0.15;
investment_rates(101:150)= 0.7 + randn(50,1)*0.2;
investment_rates(151:200)= 0.3 + randn(50,1)*0.25;

% 添加至行為表格
behavior_table.investment_rate = investment_rates;

%% 混合效應ANOVA模型
fprintf('\n[ANOVA] 市場條件對投資決策影響\n');
lme = fitlme(behavior_table, ...
    'investment_rate ~ env_transition_prob * direction + (1|risk_tolerance)');
disp(anova(lme));

% 交互作用可視化
figure('Position', [100 100 800 400]);
subplot(1,2,1);
gscatter(behavior_table.env_transition_prob, behavior_table.investment_rate, ...
    behavior_table.direction, 'br', 'ox');
title('投資率 vs 環境轉換機率');
xlabel('轉換機率'); ylabel('投資率');
legend({'擴張方向', '收縮方向'}, 'Location', 'northwest');

subplot(1,2,2);
boxplot(behavior_table.investment_rate, ...
    categorical(behavior_table.env_transition_prob));
title('投資率分布比較');
xlabel('環境轉換機率'); ylabel('投資率');
saveas(gcf, 'results/investment_behavior_analysis.png');

%% -------------------------------
%% 模組3: 自動化報告生成
%% -------------------------------
fprintf('\n=== 生成報告 ===\n');

% 創建報告
report = {
    '# 員工行為風險分析報告',
    '## 核心發現',
    sprintf('1. **風險敏感度**：環境轉換機率影響力 = %.2f (p=%.3f)', ...
        risk_coef.Estimate(2), risk_coef.pValue(2)),
    sprintf('2. **信號依賴性**：方向性效應 = %.2f (p=%.3f)', ...
        mdl_signal.Coefficients.Estimate(3), mdl_signal.Coefficients.pValue(3)),

% 市場不確定性每增加(%)，員工風險決策波動幅度達(risk_coef.Estimate(2)%)
% 在市場（熊或牛），員工對信號的反應強度比收縮期高（mdl_signal.Coefficients.Estimate(3)%）

};

% 寫入文件
writelines(report, 'behavior_risk_report.md');
fprintf('報告已生成: behavior_risk_report.md\n');

%% ======================================================================
% 系統效能指標 (顯示計算資源使用)
fprintf('\n=== 系統效能摘要 ===\n');
fprintf('分析完成！共處理 %d 筆行為數據\n', height(behavior_table));
fprintf('模型準確度: GLM R²=%.2f, LME R²=%.2f\n', ...
    mdl_risk.Rsquared.Adjusted, lme.Rsquared.Adjusted);
fprintf('生成報告包含 %d 項關鍵洞察\n', numel(report)-3);
