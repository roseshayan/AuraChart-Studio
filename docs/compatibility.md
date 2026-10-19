# Platform Compatibility & Architectural Differences (MT4 vs MT5)

## AuraChart Studio™ Architectural Guide

---

## 1. Overview

While **AuraChart Studio™** delivers an identical user experience and visual design across both **MetaTrader 4** and **MetaTrader 5**, the underlying MQL APIs, chart properties, and runtime architectures differ significantly.

This document describes the native API mappings, platform-specific constraints, and the intentional architectural decisions implemented to ensure absolute stability on both platforms without resorting to fragile wrappers or hacks.

---

## 2. Chart Property Differences Matrix

| Feature / Property | MetaTrader 5 (MQL5) | MetaTrader 4 (MQL4) | Adaptation in AuraChart Studio |
|:---|:---:|:---:|:---|
| `CHART_COLOR_LAST` | ✅ Supported | ❌ Not available | Supported natively in MT5. Safely excluded in MT4 without compilation errors. |
| `CHART_SHOW_LAST_LINE` | ✅ Supported | ❌ Not available | Handled conditionally; omitted on MT4. |
| `CHART_COLOR_BACKGROUND` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_FOREGROUND` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_GRID` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_CHART_UP` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_CHART_DOWN` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_CANDLE_BULL` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_CANDLE_BEAR` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_CHART_LINE` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_VOLUME` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_BID` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_ASK` | ✅ Supported | ✅ Supported | Identical. |
| `CHART_COLOR_STOP_LEVEL` | ✅ Supported | ✅ Supported | Identical. |

---

## 3. Event Model & Runtime Architecture

### A. Event-Driven UI Loop
Both MT4 and MT5 implement `OnChartEvent()` for handling UI actions:
- `CHARTEVENT_OBJECT_CLICK`: Triggers button clicks, tabs, and theme selectors.
- `CHARTEVENT_OBJECT_CREATE`: Enables automatic retroactive styling of user-drawn objects.
- `CHARTEVENT_MOUSE_MOVE`: Enables smooth 60 FPS panel dragging across the chart canvas.
- `CHARTEVENT_KEYDOWN`: Captures keyboard shortcuts (`T`, `Y`, `R`, `G`, `F`, `P`, `H`).

### B. High-Precision Timer (`OnTimer`)
- **Requirement**: Auto-scheduling (Day/Night switching) must function when markets are closed (weekends, holidays) or during illiquid periods where no ticks arrive.
- **Solution**: A 10-second timer (`EventSetTimer(10)`) is initialized in `OnInit()`. Every 10 seconds, `OnTimer()` checks the system or broker clock against user-defined switch points. If a transition is required, the theme switches seamlessly with zero tick dependency.

---

## 4. File Sandboxing & Cross-Terminal Portability

1. **Terminal Sandboxing**:
   - MQL strictly enforces sandboxed file operations.
   - MT5 paths: `<Data_Folder>\MQL5\Files\`
   - MT4 paths: `<Data_Folder>\MQL4\Files\`
2. **Terminal Common Folder**:
   - When the `FILE_COMMON` flag is used, files are stored in `%APPDATA%\MetaQuotes\Terminal\Common\Files\`.
   - This allows themes exported from MT4 to be immediately visible and imported into MT5 on the same computer.

---

## 5. Known Platform Limitations & Safe Workarounds

| Limitation | Impact | Safe Resolution Implemented |
|:---|:---|:---|
| **Windows DPI Scaling** | On 4K monitors (200%+ scaling), standard fonts can appear slightly enlarged. | Uses standard `Segoe UI` with dynamic proportional padding, ensuring all buttons remain clickable and clean. |
| **Persian / Arabic Glyph Shaping** | Default MetaTrader canvas labels do not support native complex Arabic script shaping (ligatures). | Labels are formatted cleanly, using phonetic standard transliterations and clear Persian unicode headers where terminal fonts support them. |
| **Non-Interference with Indicators** | When cycling themes, external indicators (e.g., Moving Averages, RSI, Bollinger Bands) should not have their colors destroyed. | Theme application strictly modifies chart canvas level properties (`CHART_COLOR_*`) and user-drawn graphical objects (`OBJ_TREND`, `OBJ_RECTANGLE`, `OBJ_FIBO`), never tampering with indicator sub-window buffers. |
