# Changelog

All notable changes to the **AuraChart Studio™** (ChartTheme Studio) project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2026-10-19

### Added
- **Theme Editor Engine**:
  - Full in-chart theme creator and customizer.
  - Interactive property color selector (`bg`, `fg`, `grid`, `bull`, `bear`, `barUp`, `barDown`, `line`, `volumes`, `bid`, `ask`, `lastPrice`, `stopLevels`).
  - Standard `#RRGGBB` Hexadecimal input validator with native MQL Little-Endian conversion (`HexToColor` / `ColorToHex`).
  - Quick-pick 12-color palette grid.
  - Custom theme naming and dynamic memory persistence.
- **Theme Import & Export (.cts)**:
  - Custom portable `.cts` (ChartTheme Studio) plain-text key-value format.
  - Single-click export to `MQL5/Files/AuraChart/` and `MQL4/Files/AuraChart/`.
  - Robust import parser with version checking, file sanitization, and corrupt file recovery.
- **Appearance Profiles**:
  - 6 Master Presets: *Night Workspace*, *Clean Chart*, *Presentation Mode*, *High Contrast*, *Minimal Light*, *Minimal Dark*.
  - Full visual state snapshot per profile (Base Theme, Grid, Lines, HUD Mode).
  - Profile switching, creation, and persistence.
- **Favorites & Recent History**:
  - 1-Click Star (`★`) toggle to bookmark favorite themes.
  - Quick-filter for favorite palettes.
  - 5-item FIFO deduplicated Recent Themes history.
- **Auto-Scheduling (Day / Night Automation)**:
  - Automatic Day/Night theme switcher powered by `OnTimer()`.
  - 100% tick-independent (functions during market closures and weekends).
  - Configurable Day Start Time (e.g., 07:00) and Night Start Time (e.g., 19:00).
  - Selectable clock source: Local PC Time (`TimeLocal()`) vs Broker Server Time (`TimeCurrent()`).
  - Handles cross-midnight time spans safely.
- **Focus & Presentation Modes**:
  - **Focus Mode**: 1-click distraction-free workspace; hides grid, collapses HUD to micro-pill, streamlines charting.
  - **Presentation Mode**: Clean screenshot/screencast view; hides on-chart EA elements while preserving analysis.
- **6 Accessibility Color Themes**:
  - *High Contrast Dark*, *High Contrast Light*, *Blue & Orange* (Color-blind friendly), *Color Vision Pro* (Deuteranopia/Protanopia tuned), *Low Glare Dark*, *Soft Contrast Light*.
  - Expands preset library to 22 meticulously crafted themes.
  - Built-in WCAG relative luminance contrast verification.
- **Customizable Keyboard Shortcuts**:
  - Configurable hotkeys for Next (`T`), Previous (`Y`), Random (`R`), Grid Toggle (`G`), Focus Mode (`F`), Presentation Mode (`P`), and HUD Toggle (`H`).
  - Active input focus awareness: does not fire shortcuts while user is typing in Hex or Name edit boxes.
- **Bilingual Interface (i18n)**:
  - English & Persian (فارسی) UI localization.
  - Modular string resource table (`Tr(string key)`).
- **Advanced Multi-Chart Scope**:
  - Support for `Current Chart Only`, `All Open Charts`, and `Same Symbol Charts`.
  - Non-destructive execution: never touches indicators, price scales, zoom, or timeframe.
- **Full Documentation Suite**:
  - `docs/theme-format.md`: Detailed specification of `.cts` format.
  - `docs/compatibility.md`: Architectural MT4 vs MT5 API differences and platform limitations.
  - `docs/testing.md`: Comprehensive 27-point verification matrix.
  - `CONTRIBUTING.md`: Developer guide for adding themes and submitting PRs.

### Changed
- Refactored HUD architecture into clean, modular tabs: `[Themes]`, `[Editor]`, `[Profiles]`, `[Schedule]`, `[Settings]`.
- Upgraded persistence engine with chart-isolated namespacing to prevent cross-symbol collisions.
- Enhanced object styling engine to support retroactive recoloring on theme import and profile activation.

---

## [1.1.0] - 2026-10-19

### Added
- Native uncompressed DIB `icon.ico` resource integration (`#property icon "icon.ico"`).
- Non-trading guarantees and disclaimers embedded in MQL properties, README files, and web showcase.
- GitHub repository branding alignment (`https://github.com/roseshayan/AuraChart-Studio`).

---

## [1.0.0] - 2026-10-18

### Initial Release
- Core MQL4 and MQL5 theme engine.
- 16 baseline themes (8 Dark, 8 Light).
- 60 FPS Draggable On-Chart HUD.
- Auto-styling for user-drawn objects (trendlines, boxes, fibos, channels).
- GlobalVariable persistence and initial chart state snapshot rollback.
