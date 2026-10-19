# Contributing to AuraChart Studio™

Thank you for your interest in contributing to **AuraChart Studio™**! We welcome contributions from traders, quantitative researchers, and MQL developers worldwide.

---

## 📜 Code of Conduct & Core Principles

Before submitting any code or documentation, please ensure you adhere to our non-negotiable principles:

1. **100% Non-Trading Utility**:
   - Under NO circumstances should any trading, execution, order placement, order modification, or account balance functions be added.
   - AuraChart Studio is strictly an ergonomics and visual customization tool.
2. **Zero External Dependencies**:
   - NO DLLs, Windows API calls requiring DLL imports, external HTTP/REST endpoints, cloud CDNs, or proprietary third-party libraries.
   - All code must run natively inside MetaTrader 4 and MetaTrader 5 sandboxes.
3. **Dual Platform Independence**:
   - MT4 (`.mq4`) and MT5 (`.mq5`) must be maintained as independent, robust codebases.
   - Do NOT introduce fake polyfill functions or macros that attempt to blend APIs at the cost of stability.
4. **Performance & Cleanliness**:
   - Code must be event-driven.
   - Never run heavy computation or loops inside `OnTick()`. Use `OnChartEvent()` for UI interactions and `OnTimer()` with sensible intervals (>= 10 seconds) for scheduled routines.
   - Clean up 100% of generated UI objects on deinitialization.

---

## 🎨 How to Contribute a New Theme

Adding a new theme to AuraChart Studio is straightforward:

1. **Test Your Theme**:
   - Use the in-chart **Theme Editor** or create a `.cts` theme file.
   - Test under both bright sunlight and dark room conditions to ensure comfortable readability.
   - Verify that Bull and Bear candle bodies and wicks are immediately distinguishable at a glance.
2. **Check Contrast Ratios**:
   - Ensure the foreground/axis text has a contrast ratio of at least 4.5:1 against the background (WCAG AA standard).
   - Ensure grid lines are subtle and never distract from price action.
3. **Format Theme Code**:
   - In `InitializeThemes()`, add your theme to either Dark, Light, or Accessibility categories:
   ```mql5
   g_themes[idx].name        = "Your Theme Name";
   g_themes[idx].category    = THEME_CAT_DARK; // or THEME_CAT_LIGHT / THEME_CAT_ACCESS
   g_themes[idx].bg          = C'15,23,42';
   g_themes[idx].fg          = C'203,213,225';
   g_themes[idx].grid        = C'30,41,59';
   g_themes[idx].barUp       = C'56,189,248';
   g_themes[idx].barDown     = C'244,63,94';
   g_themes[idx].candleBull  = C'14,165,233';
   g_themes[idx].candleBear  = C'225,29,72';
   g_themes[idx].chartLine   = C'56,189,248';
   g_themes[idx].volumes     = C'71,85,105';
   g_themes[idx].bid         = C'56,189,248';
   g_themes[idx].ask         = C'244,63,94';
   g_themes[idx].lastPrice   = C'234,179,8'; // MT5 only
   g_themes[idx].stopLevels  = C'249,115,22';
   ```
4. **Export a `.cts` File**:
   - Include the `.cts` export file in the `themes/` directory for community sharing.

---

## 🛠️ Development & Compilation Workflow

### Requirements
- **MetaTrader 5**: MetaEditor (Build 4000+ recommended, 64-bit).
- **MetaTrader 4**: MetaEditor (Build 1400+ recommended).

### Compilation Rules
All submissions must compile cleanly:
- **0 errors**
- **0 warnings**

Compile MT5 via command line:
```powershell
& "C:\Program Files\MetaTrader 5\MetaEditor64.exe" /compile:"ChartThemeStudio_MT5.mq5" /log:"compile.log"
```

---

## 🚀 Pull Request Process

1. **Fork the Repository**:
   Create a feature branch: `git checkout -b feature/your-feature-name`.
2. **Commit Your Changes**:
   Use clear semantic commit messages:
   - `feat: add Nordic Frost accessibility palette`
   - `fix: resolve object recoloring on cloned charts`
   - `docs: update theme format specification`
3. **Run the Test Matrix**:
   Verify against all 27 scenarios documented in [`docs/testing.md`](docs/testing.md).
4. **Submit Pull Request**:
   Describe the rationale behind your change, provide screenshots of the chart visual transformation, and tag the relevant issues.

---

## 📬 Contact & Support
- **Author**: Shayan Namayandeh (SudoShayanNA)
- **Telegram**: [@SudoShayanNA](https://t.me/SudoShayanNA)
- **Email**: [namayandeshayan@gmail.com](mailto:namayandeshayan@gmail.com)
- **GitHub**: [github.com/roseshayan/AuraChart-Studio](https://github.com/roseshayan/AuraChart-Studio)
