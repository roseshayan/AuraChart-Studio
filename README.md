# 🌌 AuraChart Studio™ (ChartTheme Studio Pro)
> **The Ultimate Modern Theme & Visual Manager for MetaTrader 4 & MetaTrader 5**  
> Developed by **[Shayan Namayandeh (SudoShayanNA)](https://github.com/roseshayan)**

[![MetaTrader 5](https://img.shields.io/badge/MetaTrader_5-MQL5-007acc.svg?style=for-the-badge&logo=windows)](https://www.mql5.com)
[![MetaTrader 4](https://img.shields.io/badge/MetaTrader_4-MQL4-ff9900.svg?style=for-the-badge&logo=windows)](https://www.mql4.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg?style=for-the-badge)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/roseshayan/charttheme-studio?style=for-the-badge&color=blue)](https://github.com/roseshayan)
[![Telegram](https://img.shields.io/badge/Telegram-@SudoShayanNA-2CA5E0?style=for-the-badge&logo=telegram)](https://t.me/SudoShayanNA)

---

[ English ] | [ [مستندات به زبان فارسی](README_FA.md) ]

---

## 🌟 Overview

**AuraChart Studio™** (also known as *ChartTheme Studio Pro*) is a high-performance, non-trading Expert Advisor designed specifically to transform the outdated default visuals of MetaTrader 4 & 5 into clean, aesthetic, and eye-friendly charting environments.

Built for serious technical analysts and day traders who spend hours analyzing charts, AuraChart Studio combines **16 pre-crafted dark & light color palettes**, **automatic styling of user-drawn objects**, and a **silky-smooth draggable HUD panel** with zero trading latency and zero external dependencies.

![AuraChart Studio Hero Banner](assets/hero-banner.png)

---

## 🚀 Key Features

- 🎨 **16 Balanced Master Palettes:**
  - **8 Dark Themes:** *Midnight Navy, Obsidian Black, Nord Dark, Monokai Trader, Deep Ocean, Emerald Night, Dark Graphite, Burgundy Night*.
  - **8 Light Themes:** *Arctic White, Ivory Pro, Paper Trading, Soft Silver, Morning Sky, Sage Light, Sandstone, Minimal Light*.
- ✏️ **Auto-Styling of Drawn Objects:**
  - Automatically applies active theme colors to newly drawn **Trendlines, Horizontal/Vertical Lines, Rectangles, Fibonacci Retracements, Channels, and Arrows**.
  - Retroactively updates all existing chart objects when changing themes.
- 🖐️ **Draggable On-Chart HUD:**
  - Move the controller anywhere on your chart canvas with zero flicker and 60 FPS fluidity.
  - Supports both **Full HUD** (expanded controls & color swatches) and **Compact Mini-Pill** (minimalist toolbar).
- 🌐 **Apply to All Open Charts:**
  - Switch the color scheme of your entire terminal across all symbols and timeframes with a single click.
- 🎲 **Intelligent Non-Repeating Randomizer:**
  - Picks an alternative high-contrast theme without ever repeating the currently active one.
- ⌨️ **Keyboard Hotkeys:**
  - Cycle themes (`T` / `Y`), trigger random palettes (`R`), or toggle grid (`G`) directly from your keyboard.
- 💾 **State Persistence:**
  - Automatically remembers your active theme, grid status, panel coordinates, and layout mode across terminal restarts.
- 🛡️ **1-Click Rollback:**
  - Creates a full memory snapshot of your chart's original color scheme on launch and restores it at any time with the `Reset Init` button.
- 🔒 **100% Non-Trading & Secure:**
  - Opens NO orders, executes NO trades, makes NO network requests, and requires NO external DLLs.

---

## 🎨 Theme Showcase

| Category | Theme Name | Description & Visual Tone |
|:---|:---|:---|
| **Dark** | **Midnight Navy** | Deep slate navy `#0F172A` with vibrant cyan bull and rose red bear candles. |
| **Dark** | **Obsidian Black** | Ultra-deep OLED black with vivid mint green and crimson highlights. |
| **Dark** | **Nord Dark** | Arctic cold slate based on the popular Nord design system with pastel tones. |
| **Dark** | **Monokai Trader** | Code editor aesthetic with high readability and classic Monokai accents. |
| **Dark** | **Deep Ocean** | Marine abyss with bioluminescent aqua and coral contrast. |
| **Dark** | **Emerald Night** | Calming pine background with balanced emerald bull bars. |
| **Dark** | **Dark Graphite** | Minimalist Apple-inspired dark gray with iOS-style green and red. |
| **Dark** | **Burgundy Night** | Luxurious dark velvet wine background with soft jade and berry candles. |
| **Light** | **Arctic White** | Studio-grade pure white with crisp slate text and emerald/coral candles. |
| **Light** | **Ivory Pro** | Warm cream and ivory background with elegant teal and deep crimson. |
| **Light** | **Paper Trading** | Newspaper and tactile paper feel with classic ink green and red. |
| **Light** | **Soft Silver** | Modern neutral light slate preventing eye strain during daytime analysis. |
| **Light** | **Morning Sky** | Alice Blue background with sky blue and burnt orange candles. |
| **Light** | **Sage Light** | Herbal pastel green backdrop designed for calming technical analysis. |
| **Light** | **Sandstone** | Warm earth tones, beige and rich forest green/burgundy. |
| **Light** | **Minimal Light** | Monochrome base with electric blue bull candles. |

---

## 📥 Installation Guide

### For MetaTrader 5 (MT5):
1. In MetaTrader 5, click **File -> Open Data Folder**.
2. Navigate to `MQL5/Experts/`.
3. Copy `ChartThemeStudio_MT5.mq5` (and `ChartThemeStudio_MT5.ex5`) into this folder.
4. In MT5, open the **Navigator** window (`Ctrl+N`), right-click on **Expert Advisors**, and click **Refresh**.
5. Drag **ChartThemeStudio_MT5** onto any chart.

### For MetaTrader 4 (MT4):
1. In MetaTrader 4, click **File -> Open Data Folder**.
2. Navigate to `MQL4/Experts/`.
3. Copy `ChartThemeStudio_MT4.mq4` into this folder.
4. Press `F4` to open **MetaEditor**, open the file, and press `F7` to compile.
5. In MT4 Navigator (`Ctrl+N`), refresh and drag **ChartThemeStudio_MT4** onto your chart.

---

## ⚙️ Input Parameters

| Parameter | Type | Default | Description |
|:---|:---|:---|:---|
| `InpInitialTheme` | Enum | `THEME_MIDNIGHT_NAVY` | Default theme loaded on first run. |
| `InpRestoreSavedTheme` | bool | `true` | Restores last used theme and settings automatically. |
| `InpAutoSaveSettings` | bool | `true` | Automatically saves changes to Terminal GlobalVariables. |
| `InpApplyToAllOpenCharts` | bool | `false` | When true, theme applies across all open terminal charts. |
| `InpStyleDrawnObjects` | bool | `true` | Automatically themes trendlines, boxes, fibos, and shapes. |
| `InpShowPanel` | bool | `true` | Displays the on-chart HUD controller. |
| `InpStartCompact` | bool | `false` | Starts the panel in minimized floating pill mode. |
| `InpEnableDragging` | bool | `true` | Allows dragging the HUD panel anywhere with the mouse. |
| `InpEnableHotkeys` | bool | `true` | Enables keyboard shortcuts (`T`, `Y`, `R`, `G`). |
| `InpDeinitAction` | Enum | `DEINIT_RESTORE_ORIGINAL` | Reverts chart to original state when EA is removed. |

---

## 👨‍💻 Author & Contact

**Shayan Namayandeh (SudoShayanNA)**  
*Senior Financial Software & MQL Developer*

- **GitHub:** [@roseshayan](https://github.com/roseshayan)
- **Telegram:** [@SudoShayanNA](https://t.me/SudoShayanNA)
- **Email:** [namayandeshayan@gmail.com](mailto:namayandeshayan@gmail.com)

---

## 📄 License
This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it for personal and commercial trading setups.
