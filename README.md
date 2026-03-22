# 文献追踪

用于静态发布文献追踪报告。

当前仓库公开以下目录：

- `[周报]/`：CNS 周报项目导出的最新周报
- `[日报]/`：RSS 项目导出的最新日报

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