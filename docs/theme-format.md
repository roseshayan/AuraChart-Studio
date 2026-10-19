# ChartTheme Studio (.cts) Theme File Specification

## Version: 1.1
## Status: Stable / Official Standard

---

## 1. Overview

The `.cts` (ChartTheme Studio) format is a lightweight, human-readable, plain-text key-value file designed for exporting, importing, and exchanging visual chart palettes between MetaTrader 4 and MetaTrader 5 terminals.

### Design Principles:
- **Zero Executable Code**: Contains strictly configuration keys and color definitions. No macros, scripts, or binary payloads.
- **Portability**: Usable identically across Windows, Wine, and diverse MetaTrader builds.
- **Hexadecimal Standard**: Colors are expressed in standard web `#RRGGBB` format, avoiding confusion with MQL internal little-endian byte ordering.
- **Backward & Forward Compatibility**: Unrecognized keys are safely ignored by the parser; missing optional keys fallback to deterministic defaults.

---

## 2. Storage Directory

Files are read from and written to the sandbox data folder of each terminal:
- **MetaTrader 5**: `<Terminal_Data_Folder>\MQL5\Files\AuraChart\`
- **MetaTrader 4**: `<Terminal_Data_Folder>\MQL4\Files\AuraChart\`
- **Common Storage (Optional)**: If `FILE_COMMON` is enabled, files are located in `%APPDATA%\MetaQuotes\Terminal\Common\Files\AuraChart\`, permitting cross-terminal sharing on the same PC.

---

## 3. Specification & Syntax

- Encoding: UTF-8 or ANSI.
- Line endings: CRLF (`\r\n`) or LF (`\n`).
- Lines beginning with `#` or `;` are comments and ignored.
- Key-value pairs use the format `key=value`.
- Leading and trailing whitespace around keys and values is trimmed.

### Mandatory Keys:

| Key | Type | Example | Description |
|:---|:---:|:---|:---|
| `format_version` | String | `1.1` | The specification version. |
| `name` | String | `Cyberpunk Neon` | Display name of the theme. |
| `category` | String | `Dark` | Category: `Dark`, `Light`, or `Accessibility`. |
| `bg` | Hex Color | `#0F172A` | Chart background color. |
| `fg` | Hex Color | `#CBD5E1` | Foreground, axes, price/time scales. |
| `grid` | Hex Color | `#1E293B` | Chart grid line color. |
| `candle_bull` | Hex Color | `#0EA5E9` | Bullish candle body color. |
| `candle_bear` | Hex Color | `#E11D48` | Bearish candle body color. |
| `bar_up` | Hex Color | `#38BDF8` | Bullish bar outline & candle wicks. |
| `bar_down` | Hex Color | `#F43F5E` | Bearish bar outline & candle wicks. |
| `chart_line` | Hex Color | `#38BDF8` | Line chart color. |

### Optional Keys:

| Key | Type | Default | Description |
|:---|:---:|:---:|:---|
| `volumes` | Hex Color | `#475569` | Volume histogram color. |
| `bid` | Hex Color | `#38BDF8` | Bid price line color. |
| `ask` | Hex Color | `#F43F5E` | Ask price line color. |
| `last_price` | Hex Color | `#EAB308` | Last trade price line (MT5 exclusive). |
| `stop_levels` | Hex Color | `#F97316` | Stop Loss & Take Profit order lines. |
| `description` | String | `""` | Optional theme author notes or description. |

---

## 4. Example File (`Cyberpunk_Neon.cts`)

```ini
# ===============================================
# AuraChart Studio Theme File (.cts)
# Created by: Shayan Namayandeh
# ===============================================
format_version=1.1
name=Cyberpunk Neon
category=Dark
description=Futuristic high-contrast neon palette with cyan and crimson accents.

# Chart Canvas & Axes
bg=#0A0E17
fg=#E2E8F0
grid=#1A2234

# Candlesticks & Bars
bar_up=#00F0FF
bar_down=#FF0055
candle_bull=#00B8D4
candle_bear=#D50000

# Analytical Elements
chart_line=#00F0FF
volumes=#475569
bid=#00F0FF
ask=#FF0055
last_price=#FFD600
stop_levels=#FF6D00
```

---

## 5. Parser Validation & Error Handling

1. **Path Traversal Protection**: Any file name containing `..`, `/`, `\`, or `:` is rejected to ensure strictly sandboxed I/O.
2. **Hex Validation**: Values must match `^#?[0-9A-Fa-f]{6}$`. Invalid hex strings result in safe fallback to `clrNONE` or parent theme values without crashing.
3. **MQL Color Conversion**:
   Hex `#RRGGBB` is converted into MQL `color` (stored as `0x00BBGGRR`) using bitwise operations:
   ```mql5
   color c = (color)((b << 16) | (g << 8) | r);
   ```
4. **Corrupted File Detection**: If the file lacks `format_version` or `bg`, the parser aborts gracefully and reports an on-screen user error without affecting the active chart.
