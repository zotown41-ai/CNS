# 文献追踪

用于静态发布文献追踪报告。

当前仓库公开以下目录：

- `[周报]/`：CNS 周报项目导出的最新周报
- `[日报]/`：RSS 项目导出的最新日报

## 手机端查看

优先建议开启 GitHub Pages 后，通过浏览器打开仓库首页，再从首页进入：

- `[日报]/`：查看最新日报页面
- `[周报]/`：查看最新周报页面

如果只想在手机上快速查看：

1. 打开 GitHub Pages 首页
2. 使用浏览器“添加到主屏幕”
3. 以后直接点首页，再进入日报或周报

如果需要看原始 Markdown：

- `[日报]/daily_report.md`
- `[周报]/weekly_report.md`

## 一键发布

双击运行：

```text
一键发布.bat
```

等价命令：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish_literature_tracking.ps1
```

仅同步已有结果、不重新生成：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish_literature_tracking.ps1 -SkipWeeklyGeneration -SkipDailyGeneration
```
