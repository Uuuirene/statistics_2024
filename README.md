# 信念驅動的決策模型（Belief-Driven Decision Modeling System）
> 商業預測 × 風險評估 × 行為建模
本專案模擬200位虛擬員工在不確定市場環境中的投資決策表現，
> 結合 GLM、ANOVA 與自動化報告產出，適用於 行為經濟與風控相關分析應用。

---

## Project Overview

此系統從以下三個面向建構「風險行為模型」：

1. **認知參數建模**：估算個體的風險容忍度與信號敏感度
2. **條件行為分析**：使用 ANOVA 與 GLM 比較不同市場情境對決策的影響
3. **自動報告產出**：轉譯為主管可用的行為洞察報告與圖表

---

## ⚙️｜Techniques

| 方法     | 說明 |
|----------|------|
| GLM   | 廣義線性模型分析風險容忍度與信號敏感度的交互作用 |
| ANOVA | 比較高/低轉換市場下投資決策的穩定性差異 |
| LME  | 混合模型控制個體風格 (如 risk_tolerance) |
| Markdown報告 | 自動產出行為風險報告，含圖像與指標說明 |

---

## 📦 ｜Project Structure
belief-decision-model/
├── README.md                        # 本說明文件
├── data

├── reports/
│   └── behavior_risk_report.md     # 自動產生的報告（含圖表）

├── results/
│   └── investment_behavior_analysis.png  # 投資行為圖

├── scripts/
│   └── belief_revision_modeling.m  # 主程式含所有模型


## Reference
- Massey & Wu (2005). *Detecting Regime Shifts*. Management Science, 51(6), 932-947.
- Kahneman & Tversky (1979). *Prospect Theory: An Analysis of Decision under Risk.*

