# 🌌 AuraChart Studio™ v2.0 (ChartTheme Studio Pro)
> **The Next-Gen Visual Ergonomics, Theme Studio & Chart Workspace Manager for MetaTrader 4 & 5**  
> Developed by **[Shayan Namayandeh (SudoShayanNA)](https://github.com/roseshayan)**

[![MetaTrader 5](https://img.shields.io/badge/MetaTrader_5-MQL5-007acc.svg?style=for-the-badge&logo=windows)](https://www.mql5.com)
[![MetaTrader 4](https://img.shields.io/badge/MetaTrader_4-MQL4-ff9900.svg?style=for-the-badge&logo=windows)](https://www.mql4.com)
[![Version](https://img.shields.io/badge/Version-2.0.0-emerald.svg?style=for-the-badge)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/roseshayan/AuraChart-Studio?style=for-the-badge&color=blue)](https://github.com/roseshayan/AuraChart-Studio)
[![Telegram](https://img.shields.io/badge/Telegram-@SudoShayanNA-2CA5E0?style=for-the-badge&logo=telegram)](https://t.me/SudoShayanNA)

---

[ English ] | [ [مستندات فارسی](README_FA.md) ] | [ [Live Web Showcase](https://roseshayan.github.io/AuraChart-Studio/) ] | [ [Theme Specification](docs/theme-format.md) ] | [ [Test Matrix](docs/testing.md) ]

---

> ### ⚠️ 100% Non-Trading Utility Disclaimer
> **AuraChart Studio™** is strictly an ergonomic user interface enhancement and charting aesthetic manager for technical analysts. It does **NOT** place, close, modify, or manage orders. It does **NOT** read account balances or communicate with external servers. It has **ZERO** impact on your trading decisions, execution, or risk.

---

## 🌟 Overview

**AuraChart Studio™ v2.0** (ChartTheme Studio Pro) is a high-performance, non-trading Expert Advisor designed specifically to transform the default visuals of MetaTrader 4 & 5 into clean, aesthetic, and eye-friendly charting environments.

Built for technical analysts and day traders who spend hours analyzing charts, version 2.0 introduces an **interactive in-chart Theme Editor**, **portable `.cts` Theme Import/Export**, **Appearance Profiles**, **Automated Day/Night Scheduling**, and **Accessibility Palettes** for color vision deficiency.

![AuraChart Studio Hero Banner](assets/hero-banner.png)

---

## 🚀 Key Features in Version 2.0

### 1. In-Chart Theme Editor
- Modify any core chart color in real time without restarting: Background, Text/Scales, Grid, Candle Bodies, Bar Outlines/Wicks, Line Chart, Volumes, Bid, Ask, and Last Price.
- Standard `#RRGGBB` Hexadecimal input with native MQL Little-Endian conversion.
- Quick 12-color palette matrix for rapid customization.
- Live WCAG contrast ratio calculation with instant readability score.

### 2. Import & Export System (`.cts` Format)
- Save and share custom palettes using the lightweight, open, versioned `.cts` (ChartTheme Studio) format.
- Export directly to `<Terminal_Data_Folder>/MQL5/Files/AuraChart/`.
- Safe import engine with strict path traversal protection and corrupted file detection.

### 3. Appearance Profiles
- 6 Pre-built institutional workspace presets:
  - **Night Workspace**: Muted dark slate with subtle bid line.
  - **Clean Chart**: Distraction-free OLED black.
  - **Presentation Mode**: High contrast, HUD auto-hidden for screenshots and streaming.
  - **High Contrast**: Maximum luminance distinction.
  - **Minimal Light**: Clean white paper with electric blue accents.
  - **Minimal Dark**: Apple Dark Graphite inspired.
- Save current chart state directly into custom profiles.

### 4. 26 Ergonomic Master Themes (Including Fantasy Palettes)
- **8 Dark Palettes**: Midnight Navy, Obsidian Black, Nord Dark, Monokai Trader, Deep Ocean, Emerald Night, Dark Graphite, Burgundy Night.
- **8 Light Palettes**: Arctic White, Ivory Pro, Paper Trading, Soft Silver, Morning Sky, Sage Light, Sandstone, Minimal Light.
- **6 Accessibility Palettes**: High Contrast Dark, High Contrast Light, Blue & Orange (Daltonism safe), Color Vision Pro (Deuteranopia/Protanopia tuned), Low Glare Dark, Soft Contrast Light.
- **4 Fantasy Palettes (Girly & Boyish)**:
  - **Sakura Dream (🌸 Girly)**: Mysterious deep plum velvet background (`#1C1526`), soft rose gold scales, hot sakura pink bull candles, and dreamy lavender bear accents.
  - **Cotton Candy (🍭 Girly)**: Midnight blackberry background (`#160E22`), pastel lilac axes, vibrant barbie pink bull candles, and vivid aqua sky cyan bear candles.
  - **Cyber Mecha (⚡ Boyish)**: Stealth gunmetal titanium background (`#10141A`), matrix grid, toxic neon acid green bull candles (`#00FF66`), and cyber plasma crimson bear candles (`#FF2A6D`).
  - **Phantom Samurai (🗡️ Boyish)**: Void indigo black background (`#0A0D14`), razor katana steel blade axes, electric blue bull candles (`#00A6FF`), and molten forge amber bear candles (`#FF9E00`).

### 5. Interactive Theme Browser & Category Filter
- **Paginated Direct Theme List**: Tab 0 displays 6 themes simultaneously with active state bullets (`●`/`○`), theme name, favorite bookmark status, and mini background/bull color preview swatches.
- **One-Click Instant Apply**: Tap any row to instantly activate that theme on the chart.
- **Category Filter Pills**: Fast filtering by `[All]`, `[Dark]`, `[Light]`, `[🌸/⚡ Fantasy]`, `[A11y]`, or `[★ Favorites]`.
- **Page Controls**: Smooth pagination navigation (`◄ Prev`, `Page X/Y`, `Next ►`).

### 6. 60 FPS Buttery Smooth Drag & Drop
- **Zero-Flicker Motion**: Uses native coordinate offset shifting (`MoveAllUIObjects`) without destroying or recreating objects during mouse drag.
- **Chart Scroll Lock**: Automatically locks background chart dragging (`CHART_MOUSE_SCROLL = false`) while grabbing the HUD header, preventing accidental chart drift.
- **Persistent Location**: Memorizes coordinates to chart global state upon release.

### 7. Smart Boundary-Transition Auto Scheduler
- Automatically switches between your preferred Day and Night themes at set times (e.g., 07:00 Day / 19:00 Night).
- **Zero Accidental Overrides**: Switching triggers strictly upon crossing the time boundary, allowing full freedom to explore other themes manually throughout the session without being reverted.
- **100% Tick-Independent**: Powered by `OnTimer()`, ensuring transitions work when markets are closed and on weekends.
- Selectable time source: Local PC Time (`TimeLocal()`) or Broker Server Time (`TimeCurrent()`).
- Correctly handles overnight intervals spanning midnight.

### 8. Focus & Presentation Modes
- **Focus Mode**: 1-click decluttering; turns off grid and collapses HUD to a micro-pill.
- **Presentation Mode**: Hides EA HUD entirely for recording video tutorials or taking clean screenshots.

### 7. Multi-Chart Management Scope
- Target your changes to:
  - **Current Chart Only**
  - **All Open Charts**
  - **Same Symbol Charts** (e.g. apply only across all EURUSD charts).
- Completely non-destructive: never alters indicators, timeframe, zoom level, or price scale.

### 8. Auto-Styling of Drawn Objects
- User-drawn **Trendlines, Rectangles, Fibonacci Retracements, Channels, Horizontal Lines, and Arrows** immediately inherit the active theme's harmonious accent colors.

### 9. Bilingual Interface (English & Persian)
- Switch dynamically between **English** and **فارسی** directly inside the Settings tab.

---

## ⌨️ Keyboard Shortcuts

| Hotkey | Action | Notes |
|:---:|:---|:---|
| `T` | Next Theme | Cycles forward |
| `Y` | Previous Theme | Cycles backward |
| `R` | Intelligent Random | Picks an alternative high-contrast theme |
| `G` | Toggle Grid | Toggles grid visibility |
| `F` | Focus Mode | Toggles distraction-free view |
| `P` | Presentation Mode | Hides UI for clean display |
| `H` | Toggle HUD | Shows / hides on-chart control panel |

> *Note: Hotkeys are automatically suppressed when typing inside Hex or Name edit boxes.*

---

## 🛠️ Installation Guide

### MetaTrader 5 (MT5):
1. In MetaTrader 5, click **File > Open Data Folder**.
2. Navigate to `MQL5/Experts/`.
3. Copy `ChartThemeStudio_MT5.mq5` and `ChartThemeStudio_MT5.ex5` into this folder.
4. Press `Ctrl+N` to open Navigator, right-click **Expert Advisors**, and click **Refresh**.
5. Drag **ChartThemeStudio_MT5** onto any chart and click **OK**.

### MetaTrader 4 (MT4):
1. In MetaTrader 4, click **File > Open Data Folder**.
2. Navigate to `MQL4/Experts/`.
3. Copy `ChartThemeStudio_MT4.mq4` into this folder.
4. Open MetaEditor (`F4`), open the file, and press `F7` to compile.
5. In the Navigator window, right-click **Expert Advisors**, click **Refresh**, and attach to your chart.

---

## 📁 Repository Structure

```text
├── ChartThemeStudio_MT5.mq5   # Native MetaTrader 5 MQL5 source code
├── ChartThemeStudio_MT5.ex5   # Pre-compiled MT5 executable (0 errors, 0 warnings)
├── ChartThemeStudio_MT4.mq4   # Native MetaTrader 4 MQL4 source code
├── icon.ico                   # Standard uncompressed DIB icon resource
├── README.md                  # Comprehensive English documentation
├── README_FA.md               # Persian documentation (مستندات فارسی)
├── CHANGELOG.md               # Version history and release notes
├── CONTRIBUTING.md            # Guidelines for community contributions
├── LICENSE                    # MIT Open-Source License
├── index.html                 # Interactive Web Showcase with live simulator
├── docs/
│   ├── theme-format.md        # Technical specification for .cts theme files
│   ├── compatibility.md       # MT4 vs MT5 architectural comparison
│   └── testing.md             # Formal 27-scenario verification test matrix
├── themes/
│   ├── Cyberpunk_Neon.cts     # Sample community theme
│   └── Nordic_Frost.cts       # Sample accessibility theme
└── assets/                    # Graphic assets, banners, and logos
```

---

## 👤 Author & Support

- **Author**: Shayan Namayandeh (SudoShayanNA)
- **GitHub**: [github.com/roseshayan/AuraChart-Studio](https://github.com/roseshayan/AuraChart-Studio)
- **Telegram**: [@SudoShayanNA](https://t.me/SudoShayanNA)
- **Email**: [namayandeshayan@gmail.com](mailto:namayandeshayan@gmail.com)

---

## 📜 License
Distributed under the **MIT License**. Free for personal and commercial analysis workflows.
