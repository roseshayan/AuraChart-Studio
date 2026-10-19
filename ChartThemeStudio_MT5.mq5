//+------------------------------------------------------------------+
//|                                     ChartThemeStudio_MT5.mq5     |
//|                          Copyright 2026, Shayan Namayandeh       |
//|                                   https://github.com/roseshayan  |
//+------------------------------------------------------------------+
#property copyright   "Shayan Namayandeh (SudoShayanNA)"
#property link        "https://github.com/roseshayan/AuraChart-Studio"
#property version     "2.00"
#property description "AuraChart Studio (ChartTheme Studio Pro) v2.0 - Advanced Visual & Theme Manager"
#property description "Author: Shayan Namayandeh | Telegram: @SudoShayanNA | Email: namayandeshayan@gmail.com"
#property description "NOTE: 100% Non-Trading Utility. Does NOT open, close, or affect your trades."
#property icon        "icon.ico"
#property strict

//+------------------------------------------------------------------+
//| Enums and Constants                                              |
//+------------------------------------------------------------------+
enum ENUM_THEME_CATEGORY
{
   THEME_CAT_DARK,       // Dark Theme
   THEME_CAT_LIGHT,      // Light Theme
   THEME_CAT_ACCESS      // Accessibility Theme
};

enum ENUM_PRESET_THEME
{
   // Dark Themes (0 - 7)
   THEME_MIDNIGHT_NAVY = 0,   // Midnight Navy (Deep slate blue)
   THEME_OBSIDIAN_BLACK,      // Obsidian Black (OLED black & vibrant accents)
   THEME_NORD_DARK,           // Nord Dark (Arctic ice & cool slates)
   THEME_MONOKAI_TRADER,      // Monokai Trader (Code aesthetic & high contrast)
   THEME_DEEP_OCEAN,          // Deep Ocean (Bioluminescent marine)
   THEME_EMERALD_NIGHT,       // Emerald Night (Dark pine & balanced green)
   THEME_DARK_GRAPHITE,       // Dark Graphite (Minimalist Apple dark)
   THEME_BURGUNDY_NIGHT,      // Burgundy Night (Dark velvet & soft rose)
   
   // Light Themes (8 - 15)
   THEME_ARCTIC_WHITE,        // Arctic White (Clean pristine studio)
   THEME_IVORY_PRO,           // Ivory Pro (Warm cream & elegant teal)
   THEME_PAPER_TRADING,       // Paper Trading (Tactile newsprint & classic ink)
   THEME_SOFT_SILVER,         // Soft Silver (Modern neutral slate)
   THEME_MORNING_SKY,         // Morning Sky (Crisp dawn blue & bright accents)
   THEME_SAGE_LIGHT,          // Sage Light (Calming herbal pastel)
   THEME_SANDSTONE,           // Sandstone (Earthy desert & warm brown)
   THEME_MINIMAL_LIGHT,       // Minimal Light (High contrast monochrome)
   
   // Accessibility Themes (16 - 21)
   THEME_HIGH_CONTRAST_DARK,  // High Contrast Dark (Pure Black & Vivid Neon)
   THEME_HIGH_CONTRAST_LIGHT, // High Contrast Light (Pure White & Deep Navy)
   THEME_BLUE_ORANGE,         // Blue & Orange (Daltonism safe)
   THEME_COLOR_VISION_PRO,    // Color Vision Pro (Deuteranopia & Protanopia tuned)
   THEME_LOW_GLARE_DARK,      // Low Glare Dark (Matte Charcoal & Eye Relief)
   THEME_SOFT_CONTRAST_LIGHT  // Soft Contrast Light (Warm Sepia & Low Blue Light)
};

enum ENUM_DEINIT_ACTION
{
   DEINIT_KEEP_CURRENT_THEME = 0, // Keep current theme
   DEINIT_RESTORE_ORIGINAL   = 1  // Restore original chart appearance
};

enum ENUM_CHART_TARGET
{
   TARGET_CURRENT_CHART = 0, // Only Current Chart
   TARGET_ALL_OPEN_CHARTS = 1,// All Open Charts
   TARGET_SAME_SYMBOL = 2    // All Charts with Same Symbol
};

enum ENUM_UI_TAB
{
   TAB_THEMES = 0,    // Themes & Quick Selection
   TAB_EDITOR,        // Custom Theme Editor
   TAB_PROFILES,      // Appearance Profiles
   TAB_SCHEDULE,      // Auto Day/Night Scheduling & Target
   TAB_SETTINGS       // Settings, Languages & About
};

enum ENUM_UI_LANG
{
   LANG_EN = 0,       // English
   LANG_FA = 1        // فارسی (Persian)
};

enum ENUM_EDIT_PROP
{
   PROP_BG = 0,
   PROP_FG,
   PROP_GRID,
   PROP_CANDLE_BULL,
   PROP_CANDLE_BEAR,
   PROP_BAR_UP,
   PROP_BAR_DOWN,
   PROP_CHART_LINE,
   PROP_VOLUMES,
   PROP_BID,
   PROP_ASK,
   PROP_LAST_PRICE,
   PROP_STOP_LEVELS
};

//+------------------------------------------------------------------+
//| Palette Definition Structure                                     |
//+------------------------------------------------------------------+
struct ThemePalette
{
   string               name;          // Display name
   ENUM_THEME_CATEGORY  category;      // Dark, Light, or Accessibility
   color                bg;            // Background
   color                fg;            // Foreground (axes, scales, text)
   color                grid;          // Grid
   color                barUp;         // Bull bar outline / wicks
   color                barDown;       // Bear bar outline / wicks
   color                candleBull;    // Bull candle body
   color                candleBear;    // Bear candle body
   color                chartLine;     // Line chart
   color                volumes;       // Volumes
   color                bid;           // Bid line
   color                ask;           // Ask line
   color                lastPrice;     // Last price line (MT5 exclusive)
   color                stopLevels;    // Trade & Stop levels
   bool                 isFavorite;    // User bookmarked
};

//+------------------------------------------------------------------+
//| Appearance Profile Structure                                     |
//+------------------------------------------------------------------+
struct AppearanceProfile
{
   string name;
   int    themeIdx;
   bool   showGrid;
   bool   showBid;
   bool   showAsk;
   bool   showPeriodSep;
   bool   compactMode;
};

//+------------------------------------------------------------------+
//| Original Chart Appearance Backup Structure                       |
//+------------------------------------------------------------------+
struct ChartAppearanceBackup
{
   color bg;
   color fg;
   color grid;
   color barUp;
   color barDown;
   color candleBull;
   color candleBear;
   color chartLine;
   color volumes;
   color bid;
   color ask;
   color lastPrice;
   color stopLevels;
   bool  showGrid;
   bool  showPeriodSep;
   bool  showBid;
   bool  showAsk;
   bool  showLast;
   bool  isValid;
};

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input group "=== [ Theme Selection & Core ] ==="
input ENUM_PRESET_THEME InpInitialTheme          = THEME_MIDNIGHT_NAVY;  // Initial Theme
input bool              InpRestoreSavedTheme     = true;                 // Restore Last Saved Theme
input bool              InpAutoSaveSettings      = true;                 // Auto-Save Theme & Grid Choice
input ENUM_CHART_TARGET InpChartTargetScope      = TARGET_CURRENT_CHART; // Multi-Chart Target Scope
input bool              InpStyleDrawnObjects     = true;                 // Auto-Apply Theme Colors to Drawn Objects
input ENUM_UI_LANG      InpDefaultLanguage       = LANG_EN;              // UI Language (English / Persian)

input group "=== [ UI Panel Appearance & Dragging ] ==="
input bool              InpShowPanel             = true;                 // Show On-Chart HUD Panel
input bool              InpStartCompact          = false;                // Start in Compact (Mini) Mode
input bool              InpEnableDragging        = true;                 // Enable Drag & Drop for Panel
input ENUM_BASE_CORNER  InpPanelCorner           = CORNER_LEFT_UPPER;    // Default Placement Corner
input int               InpPanelOffsetX          = 25;                   // Initial Panel X (pixels)
input int               InpPanelOffsetY          = 35;                   // Initial Panel Y (pixels)
input string            InpFontName              = "Segoe UI";           // UI Font Family

input group "=== [ Keyboard Shortcuts ] ==="
input bool              InpEnableHotkeys         = true;                 // Enable Keyboard Shortcuts
input string            InpHotkeyNext            = "T";                  // Key: Next Theme
input string            InpHotkeyPrev            = "Y";                  // Key: Previous Theme
input string            InpHotkeyRandom          = "R";                  // Key: Intelligent Random Theme
input string            InpHotkeyGrid            = "G";                  // Key: Toggle Grid
input string            InpHotkeyFocus           = "F";                  // Key: Toggle Focus Mode
input string            InpHotkeyPresentation    = "P";                  // Key: Toggle Presentation Mode
input string            InpHotkeyToggleHUD       = "H";                  // Key: Toggle HUD Visibility

input group "=== [ Auto Day / Night Scheduling ] ==="
input bool              InpAutoSchedule          = false;                // Enable Auto Day/Night Scheduling
input string            InpDayStartTime          = "07:00";              // Day Mode Start Time (HH:MM)
input string            InpNightStartTime        = "19:00";              // Night Mode Start Time (HH:MM)
input ENUM_PRESET_THEME InpDayTheme              = THEME_ARCTIC_WHITE;   // Day Mode Theme
input ENUM_PRESET_THEME InpNightTheme            = THEME_MIDNIGHT_NAVY;  // Night Mode Theme
input bool              InpScheduleUseLocalTime  = true;                 // Use Local PC Time (false = Server Time)

input group "=== [ Chart Elements Default State ] ==="
input bool              InpDefaultGrid           = false;                // Default Grid Visible
input bool              InpDefaultBidLine        = true;                 // Default Show Bid Line
input bool              InpDefaultAskLine        = false;                // Default Show Ask Line
input bool              InpDefaultPeriodSep      = false;                // Default Show Period Separators

input group "=== [ Deinitialization Behavior ] ==="
input ENUM_DEINIT_ACTION InpDeinitAction         = DEINIT_RESTORE_ORIGINAL; // On EA Removal

//+------------------------------------------------------------------+
//| Global Variables & State                                         |
//+------------------------------------------------------------------+
#define TOTAL_BUILTIN_THEMES 22
#define MAX_TOTAL_THEMES     30
#define MAX_RECENT           5
#define TOTAL_PROFILES       6

ThemePalette           g_themes[MAX_TOTAL_THEMES];
int                    g_themes_count        = TOTAL_BUILTIN_THEMES;
ChartAppearanceBackup  g_backup;
int                    g_current_theme_idx   = 0;
bool                   g_grid_state          = false;
bool                   g_compact_mode        = false;
bool                   g_focus_mode          = false;
bool                   g_presentation_mode   = false;
bool                   g_hud_visible         = true;
ENUM_UI_TAB            g_active_tab          = TAB_THEMES;
ENUM_UI_LANG           g_current_lang        = LANG_EN;
ENUM_CHART_TARGET      g_chart_target        = TARGET_CURRENT_CHART;
string                 g_ui_prefix           = "";
long                   g_chart_id            = 0;

// Appearance profiles
AppearanceProfile      g_profiles[TOTAL_PROFILES];
int                    g_current_profile_idx = 0;

// Recent themes FIFO queue
int                    g_recent_themes[MAX_RECENT];
int                    g_recent_count        = 0;

// Theme Editor state
ThemePalette           g_edit_theme;
ENUM_EDIT_PROP         g_edit_prop           = PROP_BG;
string                 g_edit_hex_input      = "#0F172A";
string                 g_status_msg          = "";
datetime               g_status_time         = 0;

// Drag & drop state
int                    g_panel_x             = 25;
int                    g_panel_y             = 35;
bool                   g_is_dragging         = false;
int                    g_drag_start_mouse_x  = 0;
int                    g_drag_start_mouse_y  = 0;
int                    g_drag_start_panel_x  = 0;
int                    g_drag_start_panel_y  = 0;

// State backup for Focus/Presentation mode rollback
int                    g_pre_focus_theme     = 0;
bool                   g_pre_focus_grid      = false;
bool                   g_pre_focus_compact   = false;

// Forward declarations
void BuildUIPanel();
void UpdateUIPositions();
void DeleteAllUIObjects();
void StyleAllDrawnObjects(const long chart_id, const int theme_idx);
void StyleSingleObject(const long chart_id, const string obj_name, const int theme_idx);
void ApplyThemeToChart(const long chart_id, const int theme_idx, const bool set_grid);
void ApplyThemeUniversal(const int theme_idx, const bool set_grid);
void SaveSettings();
void LoadSavedSettings();
void NextTheme();
void PrevTheme();
void SetTheme(const int idx);
void ToggleGrid();
void ToggleFocusMode();
void TogglePresentationMode();
void TriggerIntelligentRandom();
void AddRecentTheme(const int idx);
void SetStatusMessage(const string msg);
bool ExportThemeToCTS(const ThemePalette &t, string filename = "");
bool ImportThemeFromCTS(string filename, ThemePalette &out_t);

//+------------------------------------------------------------------+
//| Multi-Language Translation Table (English & Persian)             |
//+------------------------------------------------------------------+
string Tr(const string key)
{
   if(g_current_lang == LANG_FA)
   {
      if(key == "TITLE_APP")        return "استودیو تم چارت | نسخه ۲.۰";
      if(key == "TAB_THEMES")       return "تم‌ها";
      if(key == "TAB_EDITOR")       return "ویرایشگر";
      if(key == "TAB_PROFILES")     return "پروفایل";
      if(key == "TAB_SCHEDULE")     return "زمان‌بندی";
      if(key == "TAB_SETTINGS")     return "تنظیمات";
      if(key == "BTN_PREV")         return "◄ قبلی";
      if(key == "BTN_NEXT")         return "بعدی ►";
      if(key == "BTN_RANDOM")       return "تصادفی";
      if(key == "BTN_GRID")         return "شبکه";
      if(key == "BTN_FOCUS")        return "تمرکز";
      if(key == "BTN_APPLY")        return "اعمال";
      if(key == "BTN_SAVE")         return "ذخیره";
      if(key == "BTN_EXPORT")       return "خروجی .cts";
      if(key == "BTN_IMPORT")       return "ورودی .cts";
      if(key == "BTN_RESET")        return "بازنشانی";
      if(key == "STATUS_APPLIED")   return "تم با موفقیت اعمال گردید";
      if(key == "STATUS_SAVED")     return "تنظیمات و تم ذخیره شد";
      if(key == "STATUS_ERR_FILE")  return "خطا در فرمت یا مسیر فایل";
      if(key == "STATUS_EXP_OK")    return "فایل در پوشه Files ذخیره شد";
      if(key == "STATUS_IMP_OK")    return "تم با موفقیت وارد و اعمال شد";
      if(key == "STATUS_RESET")     return "ظاهر اولیه چارت بازیابی شد";
      if(key == "PROP_BG")          return "پس‌زمینه";
      if(key == "PROP_FG")          return "محورها/متن";
      if(key == "PROP_GRID")        return "خطوط شبکه";
      if(key == "PROP_BULL")        return "کندل صعودی";
      if(key == "PROP_BEAR")        return "کندل نزولی";
      if(key == "PROP_BARUP")       return "سایه صعودی";
      if(key == "PROP_BARDOWN")     return "سایه نزولی";
      if(key == "PROP_LINE")        return "نمودار خطی";
      if(key == "PROP_VOL")         return "حجم معاملات";
      if(key == "PROP_BID")         return "خط Bid";
      if(key == "PROP_ASK")         return "خط Ask";
      if(key == "PROP_LAST")        return "خط Last";
      if(key == "TARGET_SCOPE")     return "دامنه اعمال:";
      if(key == "TARGET_CURR")      return "فقط چارت جاری";
      if(key == "TARGET_ALL")       return "تمام چارت‌های باز";
      if(key == "TARGET_SYM")       return "چارت‌های هم‌نماد";
      if(key == "LBL_ACTIVE_THEME") return "تم فعال:";
      if(key == "LBL_ACTIVE_PROF")  return "پروفایل فعال:";
      if(key == "LBL_FAVORITES")    return "علاقه‌مندی‌ها";
      if(key == "LBL_RECENT")       return "اخیر:";
      if(key == "LBL_SCHEDULE_ST")  return "زمان‌بندی خودکار:";
      if(key == "LBL_TIME_SRC")     return "منبع ساعت:";
      if(key == "LBL_HOTKEYS_ST")   return "کلیدهای میانبر:";
      if(key == "LBL_CONTRAST")     return "کنتراست متن:";
      if(key == "VAL_ON")           return "روشن";
      if(key == "VAL_OFF")          return "خاموش";
      if(key == "VAL_GOOD")         return "بسیار عالی (AA)";
      if(key == "VAL_POOR")         return "ضعیف! (کم)";
      if(key == "PRES_EXIT")        return "خروج از ارائه";
   }

   // Default English
   if(key == "TITLE_APP")        return "AuraChart Studio v2.0";
   if(key == "TAB_THEMES")       return "Themes";
   if(key == "TAB_EDITOR")       return "Editor";
   if(key == "TAB_PROFILES")     return "Profiles";
   if(key == "TAB_SCHEDULE")     return "Schedule";
   if(key == "TAB_SETTINGS")     return "Settings";
   if(key == "BTN_PREV")         return "◄ Prev";
   if(key == "BTN_NEXT")         return "Next ►";
   if(key == "BTN_RANDOM")       return "Random";
   if(key == "BTN_GRID")         return "Grid";
   if(key == "BTN_FOCUS")        return "Focus";
   if(key == "BTN_APPLY")        return "Apply";
   if(key == "BTN_SAVE")         return "Save";
   if(key == "BTN_EXPORT")       return "Export .cts";
   if(key == "BTN_IMPORT")       return "Import .cts";
   if(key == "BTN_RESET")        return "Reset Init";
   if(key == "STATUS_APPLIED")   return "Theme applied successfully";
   if(key == "STATUS_SAVED")     return "Settings saved";
   if(key == "STATUS_ERR_FILE")  return "Error: Invalid file format";
   if(key == "STATUS_EXP_OK")    return "Exported to MQL5/Files/AuraChart";
   if(key == "STATUS_IMP_OK")    return "Imported & applied successfully";
   if(key == "STATUS_RESET")     return "Initial chart state restored";
   if(key == "PROP_BG")          return "Background";
   if(key == "PROP_FG")          return "Axes/Text";
   if(key == "PROP_GRID")        return "Grid Lines";
   if(key == "PROP_BULL")        return "Bull Candle";
   if(key == "PROP_BEAR")        return "Bear Candle";
   if(key == "PROP_BARUP")       return "Bar Up/Wick";
   if(key == "PROP_BARDOWN")     return "Bar Down/Wick";
   if(key == "PROP_LINE")        return "Line Chart";
   if(key == "PROP_VOL")         return "Volumes";
   if(key == "PROP_BID")         return "Bid Line";
   if(key == "PROP_ASK")         return "Ask Line";
   if(key == "PROP_LAST")        return "Last Price";
   if(key == "TARGET_SCOPE")     return "Apply Scope:";
   if(key == "TARGET_CURR")      return "Current Chart Only";
   if(key == "TARGET_ALL")       return "All Open Charts";
   if(key == "TARGET_SYM")       return "Same Symbol Charts";
   if(key == "LBL_ACTIVE_THEME") return "Active Theme:";
   if(key == "LBL_ACTIVE_PROF")  return "Active Profile:";
   if(key == "LBL_FAVORITES")    return "Favorites";
   if(key == "LBL_RECENT")       return "Recent:";
   if(key == "LBL_SCHEDULE_ST")  return "Auto Day/Night:";
   if(key == "LBL_TIME_SRC")     return "Time Source:";
   if(key == "LBL_HOTKEYS_ST")   return "Keyboard Hotkeys:";
   if(key == "LBL_CONTRAST")     return "Text Contrast:";
   if(key == "VAL_ON")           return "ON";
   if(key == "VAL_OFF")          return "OFF";
   if(key == "VAL_GOOD")         return "Optimal (AA)";
   if(key == "VAL_POOR")         return "Low Contrast!";
   if(key == "PRES_EXIT")        return "Exit Presentation";

   return key;
}

//+------------------------------------------------------------------+
//| Color & Hex Conversion Helpers                                   |
//+------------------------------------------------------------------+
int HexCharToInt(const ushort c)
{
   if(c >= '0' && c <= '9') return (int)(c - '0');
   if(c >= 'A' && c <= 'F') return (int)(c - 'A' + 10);
   if(c >= 'a' && c <= 'f') return (int)(c - 'a' + 10);
   return -1;
}

int HexPairToInt(const string s)
{
   if(StringLen(s) < 2) return -1;
   int hi = HexCharToInt(StringGetCharacter(s, 0));
   int lo = HexCharToInt(StringGetCharacter(s, 1));
   if(hi < 0 || lo < 0) return -1;
   return (hi << 4) | lo;
}

color HexToColor(string hex)
{
   StringTrimLeft(hex);
   StringTrimRight(hex);
   if(StringSubstr(hex, 0, 1) == "#")
      hex = StringSubstr(hex, 1);
   if(StringLen(hex) != 6)
      return clrNONE;
      
   int r = HexPairToInt(StringSubstr(hex, 0, 2));
   int g = HexPairToInt(StringSubstr(hex, 2, 2));
   int b = HexPairToInt(StringSubstr(hex, 4, 2));
   if(r < 0 || g < 0 || b < 0)
      return clrNONE;
      
   return (color)((b << 16) | (g << 8) | r);
}

string ColorToHex(const color c)
{
   int r = (int)(c & 0xFF);
   int g = (int)((c >> 8) & 0xFF);
   int b = (int)((c >> 16) & 0xFF);
   return StringFormat("#%02X%02X%02X", r, g, b);
}

double RelativeLuminance(const color c)
{
   double r = (double)(c & 0xFF) / 255.0;
   double g = (double)((c >> 8) & 0xFF) / 255.0;
   double b = (double)((c >> 16) & 0xFF) / 255.0;
   return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double ContrastRatio(const color c1, const color c2)
{
   double l1 = RelativeLuminance(c1);
   double l2 = RelativeLuminance(c2);
   if(l1 < l2) { double tmp = l1; l1 = l2; l2 = tmp; }
   return (l1 + 0.05) / (l2 + 0.05);
}

//+------------------------------------------------------------------+
//| Initialize Built-in 22 Master Themes                             |
//+------------------------------------------------------------------+
void InitializeThemes()
{
   // 0: Midnight Navy (Dark)
   g_themes[0].name        = "Midnight Navy";
   g_themes[0].category    = THEME_CAT_DARK;
   g_themes[0].bg          = C'15,23,42';      // #0F172A
   g_themes[0].fg          = C'203,213,225';   // #CBD5E1
   g_themes[0].grid        = C'30,41,59';      // #1E293B
   g_themes[0].barUp       = C'56,189,248';    // #38BDF8
   g_themes[0].barDown     = C'244,63,94';     // #F43F5E
   g_themes[0].candleBull  = C'14,165,233';    // #0EA5E9
   g_themes[0].candleBear  = C'225,29,72';     // #E11D48
   g_themes[0].chartLine   = C'56,189,248';
   g_themes[0].volumes     = C'71,85,105';     // #475569
   g_themes[0].bid         = C'56,189,248';
   g_themes[0].ask         = C'244,63,94';
   g_themes[0].lastPrice   = C'234,179,8';     // #EAB308
   g_themes[0].stopLevels  = C'249,115,22';    // #F97316
   g_themes[0].isFavorite  = false;

   // 1: Obsidian Black (Dark)
   g_themes[1].name        = "Obsidian Black";
   g_themes[1].category    = THEME_CAT_DARK;
   g_themes[1].bg          = C'18,18,18';      // #121212
   g_themes[1].fg          = C'220,220,220';   // #DCDCDC
   g_themes[1].grid        = C'34,34,34';      // #222222
   g_themes[1].barUp       = C'0,230,118';     // #00E676
   g_themes[1].barDown     = C'255,23,68';     // #FF1744
   g_themes[1].candleBull  = C'0,200,83';      // #00C853
   g_themes[1].candleBear  = C'213,0,0';       // #D50000
   g_themes[1].chartLine   = C'0,230,118';
   g_themes[1].volumes     = C'66,66,66';      // #424242
   g_themes[1].bid         = C'0,230,118';
   g_themes[1].ask         = C'255,23,68';
   g_themes[1].lastPrice   = C'255,214,0';
   g_themes[1].stopLevels  = C'255,145,0';
   g_themes[1].isFavorite  = false;

   // 2: Nord Dark (Dark)
   g_themes[2].name        = "Nord Dark";
   g_themes[2].category    = THEME_CAT_DARK;
   g_themes[2].bg          = C'46,52,64';      // #2E3440
   g_themes[2].fg          = C'236,239,244';   // #ECEFF4
   g_themes[2].grid        = C'59,66,82';      // #3B4252
   g_themes[2].barUp       = C'163,190,140';   // #A3BE8C
   g_themes[2].barDown     = C'191,97,106';    // #BF616A
   g_themes[2].candleBull  = C'143,188,143';   // #8FBC8F
   g_themes[2].candleBear  = C'205,92,92';     // #CD5C5C
   g_themes[2].chartLine   = C'136,192,208';   // #88C0D0
   g_themes[2].volumes     = C'76,86,106';     // #4C566A
   g_themes[2].bid         = C'136,192,208';
   g_themes[2].ask         = C'191,97,106';
   g_themes[2].lastPrice   = C'235,203,139';
   g_themes[2].stopLevels  = C'208,135,112';
   g_themes[2].isFavorite  = false;

   // 3: Monokai Trader (Dark)
   g_themes[3].name        = "Monokai Trader";
   g_themes[3].category    = THEME_CAT_DARK;
   g_themes[3].bg          = C'39,40,34';      // #272822
   g_themes[3].fg          = C'248,248,242';   // #F8F8F2
   g_themes[3].grid        = C'62,61,50';      // #3E3D32
   g_themes[3].barUp       = C'166,226,46';    // #A6E22E
   g_themes[3].barDown     = C'249,38,114';    // #F92672
   g_themes[3].candleBull  = C'140,198,38';
   g_themes[3].candleBear  = C'220,30,95';
   g_themes[3].chartLine   = C'102,217,239';   // #66D9EF
   g_themes[3].volumes     = C'117,113,94';
   g_themes[3].bid         = C'102,217,239';
   g_themes[3].ask         = C'249,38,114';
   g_themes[3].lastPrice   = C'253,151,31';
   g_themes[3].stopLevels  = C'174,129,255';
   g_themes[3].isFavorite  = false;

   // 4: Deep Ocean (Dark)
   g_themes[4].name        = "Deep Ocean";
   g_themes[4].category    = THEME_CAT_DARK;
   g_themes[4].bg          = C'10,25,47';      // #0A192F
   g_themes[4].fg          = C'204,214,246';   // #CCD6F6
   g_themes[4].grid        = C'23,42,69';      // #172A45
   g_themes[4].barUp       = C'100,255,218';   // #64FFDA
   g_themes[4].barDown     = C'255,107,107';   // #FF6B6B
   g_themes[4].candleBull  = C'0,191,165';
   g_themes[4].candleBear  = C'229,57,53';
   g_themes[4].chartLine   = C'100,255,218';
   g_themes[4].volumes     = C'35,53,84';
   g_themes[4].bid         = C'100,255,218';
   g_themes[4].ask         = C'255,107,107';
   g_themes[4].lastPrice   = C'255,209,102';
   g_themes[4].stopLevels  = C'247,127,0';
   g_themes[4].isFavorite  = false;

   // 5: Emerald Night (Dark)
   g_themes[5].name        = "Emerald Night";
   g_themes[5].category    = THEME_CAT_DARK;
   g_themes[5].bg          = C'18,30,23';      // #121E17
   g_themes[5].fg          = C'224,242,233';   // #E0F2E9
   g_themes[5].grid        = C'31,48,39';      // #1F3027
   g_themes[5].barUp       = C'46,204,113';    // #2ECC71
   g_themes[5].barDown     = C'231,76,60';     // #E74C3C
   g_themes[5].candleBull  = C'39,174,96';     // #27AE60
   g_themes[5].candleBear  = C'192,57,43';     // #C0392B
   g_themes[5].chartLine   = C'46,204,113';
   g_themes[5].volumes     = C'52,73,63';
   g_themes[5].bid         = C'46,204,113';
   g_themes[5].ask         = C'231,76,60';
   g_themes[5].lastPrice   = C'241,196,15';
   g_themes[5].stopLevels  = C'230,126,34';
   g_themes[5].isFavorite  = false;

   // 6: Dark Graphite (Dark)
   g_themes[6].name        = "Dark Graphite";
   g_themes[6].category    = THEME_CAT_DARK;
   g_themes[6].bg          = C'28,28,30';      // #1C1C1E
   g_themes[6].fg          = C'209,209,214';   // #D1D1D6
   g_themes[6].grid        = C'44,44,46';      // #2C2C2E
   g_themes[6].barUp       = C'50,215,75';     // #32D74B
   g_themes[6].barDown     = C'255,69,58';     // #FF453A
   g_themes[6].candleBull  = C'40,180,60';
   g_themes[6].candleBear  = C'220,50,40';
   g_themes[6].chartLine   = C'10,132,255';    // #0A84FF
   g_themes[6].volumes     = C'72,72,74';
   g_themes[6].bid         = C'50,215,75';
   g_themes[6].ask         = C'255,69,58';
   g_themes[6].lastPrice   = C'255,214,10';
   g_themes[6].stopLevels  = C'255,159,10';
   g_themes[6].isFavorite  = false;

   // 7: Burgundy Night (Dark)
   g_themes[7].name        = "Burgundy Night";
   g_themes[7].category    = THEME_CAT_DARK;
   g_themes[7].bg          = C'28,15,20';      // #1C0F14
   g_themes[7].fg          = C'238,220,225';   // #EEDCE1
   g_themes[7].grid        = C'50,28,38';      // #321C26
   g_themes[7].barUp       = C'52,211,153';    // #34D399
   g_themes[7].barDown     = C'251,113,133';   // #FB7185
   g_themes[7].candleBull  = C'16,185,129';    // #10B981
   g_themes[7].candleBear  = C'244,63,94';     // #F43F5E
   g_themes[7].chartLine   = C'244,114,182';   // #F472B6
   g_themes[7].volumes     = C'88,47,66';
   g_themes[7].bid         = C'52,211,153';
   g_themes[7].ask         = C'251,113,133';
   g_themes[7].lastPrice   = C'251,191,36';
   g_themes[7].stopLevels  = C'168,85,247';
   g_themes[7].isFavorite  = false;

   // 8: Arctic White (Light)
   g_themes[8].name        = "Arctic White";
   g_themes[8].category    = THEME_CAT_LIGHT;
   g_themes[8].bg          = C'255,255,255';   // #FFFFFF
   g_themes[8].fg          = C'30,41,59';      // #1E293B
   g_themes[8].grid        = C'226,232,240';   // #E2E8F0
   g_themes[8].barUp       = C'16,185,129';    // #10B981
   g_themes[8].barDown     = C'239,68,68';     // #EF4444
   g_themes[8].candleBull  = C'16,185,129';
   g_themes[8].candleBear  = C'239,68,68';
   g_themes[8].chartLine   = C'37,99,235';     // #2563EB
   g_themes[8].volumes     = C'148,163,184';
   g_themes[8].bid         = C'16,185,129';
   g_themes[8].ask         = C'239,68,68';
   g_themes[8].lastPrice   = C'217,119,6';
   g_themes[8].stopLevels  = C'220,38,38';
   g_themes[8].isFavorite  = false;

   // 9: Ivory Pro (Light)
   g_themes[9].name        = "Ivory Pro";
   g_themes[9].category    = THEME_CAT_LIGHT;
   g_themes[9].bg          = C'250,249,246';   // #FAF9F6
   g_themes[9].fg          = C'44,53,64';      // #2C3540
   g_themes[9].grid        = C'228,225,218';   // #E4E1DA
   g_themes[9].barUp       = C'13,148,136';    // #0D9488
   g_themes[9].barDown     = C'225,29,72';     // #E11D48
   g_themes[9].candleBull  = C'15,118,110';    // #0F766E
   g_themes[9].candleBear  = C'190,18,60';     // #BE123C
   g_themes[9].chartLine   = C'13,148,136';
   g_themes[9].volumes     = C'156,163,175';
   g_themes[9].bid         = C'13,148,136';
   g_themes[9].ask         = C'225,29,72';
   g_themes[9].lastPrice   = C'202,138,4';
   g_themes[9].stopLevels  = C'217,119,6';
   g_themes[9].isFavorite  = false;

   // 10: Paper Trading (Light)
   g_themes[10].name       = "Paper Trading";
   g_themes[10].category   = THEME_CAT_LIGHT;
   g_themes[10].bg         = C'244,244,240';   // #F4F4F0
   g_themes[10].fg         = C'20,20,20';      // #141414
   g_themes[10].grid       = C'216,216,208';   // #D8D8D0
   g_themes[10].barUp      = C'46,125,50';     // #2E7D32
   g_themes[10].barDown    = C'198,40,40';     // #C62828
   g_themes[10].candleBull = C'56,142,60';
   g_themes[10].candleBear = C'211,47,47';
   g_themes[10].chartLine  = C'21,101,192';    // #1565C0
   g_themes[10].volumes    = C'158,158,158';
   g_themes[10].bid        = C'46,125,50';
   g_themes[10].ask        = C'198,40,40';
   g_themes[10].lastPrice  = C'245,124,0';
   g_themes[10].stopLevels = C'123,31,162';
   g_themes[10].isFavorite = false;

   // 11: Soft Silver (Light)
   g_themes[11].name       = "Soft Silver";
   g_themes[11].category   = THEME_CAT_LIGHT;
   g_themes[11].bg         = C'241,245,249';   // #F1F5F9
   g_themes[11].fg         = C'51,65,85';      // #334155
   g_themes[11].grid       = C'203,213,225';   // #CBD5E1
   g_themes[11].barUp      = C'5,150,105';     // #059669
   g_themes[11].barDown    = C'220,38,38';     // #DC2626
   g_themes[11].candleBull = C'16,185,129';
   g_themes[11].candleBear = C'239,68,68';
   g_themes[11].chartLine  = C'79,70,229';     // #4F46E5
   g_themes[11].volumes    = C'148,163,184';
   g_themes[11].bid        = C'5,150,105';
   g_themes[11].ask        = C'220,38,38';
   g_themes[11].lastPrice  = C'217,119,6';
   g_themes[11].stopLevels = C'234,88,12';
   g_themes[11].isFavorite = false;

   // 12: Morning Sky (Light)
   g_themes[12].name       = "Morning Sky";
   g_themes[12].category   = THEME_CAT_LIGHT;
   g_themes[12].bg         = C'240,248,255';   // #F0F8FF
   g_themes[12].fg         = C'27,38,59';      // #1B263B
   g_themes[12].grid       = C'218,230,242';   // #DAE6F2
   g_themes[12].barUp      = C'2,132,199';     // #0284C7
   g_themes[12].barDown    = C'234,88,12';     // #EA580C
   g_themes[12].candleBull = C'14,165,233';
   g_themes[12].candleBear = C'249,115,22';
   g_themes[12].chartLine  = C'2,132,199';
   g_themes[12].volumes    = C'141,166,193';
   g_themes[12].bid        = C'2,132,199';
   g_themes[12].ask        = C'234,88,12';
   g_themes[12].lastPrice  = C'202,138,4';
   g_themes[12].stopLevels = C'220,38,38';
   g_themes[12].isFavorite = false;

   // 13: Sage Light (Light)
   g_themes[13].name       = "Sage Light";
   g_themes[13].category   = THEME_CAT_LIGHT;
   g_themes[13].bg         = C'244,247,244';   // #F4F7F4
   g_themes[13].fg         = C'40,55,45';      // #28372D
   g_themes[13].grid       = C'220,229,221';   // #DCE5DD
   g_themes[13].barUp      = C'40,167,69';     // #28A745
   g_themes[13].barDown    = C'217,83,79';     // #D9534F
   g_themes[13].candleBull = C'92,184,92';
   g_themes[13].candleBear = C'217,83,79';
   g_themes[13].chartLine  = C'32,125,90';
   g_themes[13].volumes    = C'150,170,155';
   g_themes[13].bid        = C'40,167,69';
   g_themes[13].ask        = C'217,83,79';
   g_themes[13].lastPrice  = C'235,160,20';
   g_themes[13].stopLevels = C'210,105,30';
   g_themes[13].isFavorite = false;

   // 14: Sandstone (Light)
   g_themes[14].name       = "Sandstone";
   g_themes[14].category   = THEME_CAT_LIGHT;
   g_themes[14].bg         = C'248,245,238';   // #F8F5EE
   g_themes[14].fg         = C'68,60,50';      // #443C32
   g_themes[14].grid       = C'230,223,210';   // #E6DFD2
   g_themes[14].barUp      = C'56,142,60';     // #388E3C
   g_themes[14].barDown    = C'183,28,28';     // #B71C1C
   g_themes[14].candleBull = C'67,160,71';
   g_themes[14].candleBear = C'198,40,40';
   g_themes[14].chartLine  = C'121,85,72';     // #795548
   g_themes[14].volumes    = C'175,165,150';
   g_themes[14].bid        = C'56,142,60';
   g_themes[14].ask        = C'183,28,28';
   g_themes[14].lastPrice  = C'230,81,0';
   g_themes[14].stopLevels = C'136,14,79';
   g_themes[14].isFavorite = false;

   // 15: Minimal Light (Light)
   g_themes[15].name       = "Minimal Light";
   g_themes[15].category   = THEME_CAT_LIGHT;
   g_themes[15].bg         = C'248,249,250';   // #F8F9FA
   g_themes[15].fg         = C'33,37,41';      // #212529
   g_themes[15].grid       = C'233,236,239';   // #E9ECEF
   g_themes[15].barUp      = C'13,110,253';    // #0D6EFD
   g_themes[15].barDown    = C'108,117,125';   // #6C757D
   g_themes[15].candleBull = C'13,110,253';
   g_themes[15].candleBear = C'108,117,125';
   g_themes[15].chartLine  = C'13,110,253';
   g_themes[15].volumes    = C'173,181,189';
   g_themes[15].bid        = C'13,110,253';
   g_themes[15].ask        = C'220,53,69';
   g_themes[15].lastPrice  = C'255,193,7';
   g_themes[15].stopLevels = C'253,126,20';
   g_themes[15].isFavorite = false;

   // 16: High Contrast Dark (Accessibility)
   g_themes[16].name       = "High Contrast Dark";
   g_themes[16].category   = THEME_CAT_ACCESS;
   g_themes[16].bg         = C'0,0,0';         // #000000
   g_themes[16].fg         = C'255,255,255';   // #FFFFFF
   g_themes[16].grid       = C'40,40,40';      // #282828
   g_themes[16].barUp      = C'255,255,0';     // #FFFF00 (Bright Yellow)
   g_themes[16].barDown    = C'0,255,255';     // #00FFFF (Bright Cyan)
   g_themes[16].candleBull = C'255,255,255';   // #FFFFFF
   g_themes[16].candleBear = C'0,17,51';       // #001133
   g_themes[16].chartLine  = C'255,255,0';
   g_themes[16].volumes    = C'120,120,120';
   g_themes[16].bid        = C'255,255,0';
   g_themes[16].ask        = C'0,255,255';
   g_themes[16].lastPrice  = C'255,0,255';
   g_themes[16].stopLevels = C'255,128,0';
   g_themes[16].isFavorite = false;

   // 17: High Contrast Light (Accessibility)
   g_themes[17].name       = "High Contrast Light";
   g_themes[17].category   = THEME_CAT_ACCESS;
   g_themes[17].bg         = C'255,255,255';   // #FFFFFF
   g_themes[17].fg         = C'0,0,0';         // #000000
   g_themes[17].grid       = C'200,200,200';   // #C8C8C8
   g_themes[17].barUp      = C'0,34,136';      // #002288
   g_themes[17].barDown    = C'153,0,0';       // #990000
   g_themes[17].candleBull = C'0,34,136';
   g_themes[17].candleBear = C'153,0,0';
   g_themes[17].chartLine  = C'0,0,0';
   g_themes[17].volumes    = C'100,100,100';
   g_themes[17].bid        = C'0,34,136';
   g_themes[17].ask        = C'153,0,0';
   g_themes[17].lastPrice  = C'204,102,0';
   g_themes[17].stopLevels = C'153,0,0';
   g_themes[17].isFavorite = false;

   // 18: Blue & Orange (Accessibility - Color Blind Safe)
   g_themes[18].name       = "Blue & Orange";
   g_themes[18].category   = THEME_CAT_ACCESS;
   g_themes[18].bg         = C'15,20,30';      // #0F141E
   g_themes[18].fg         = C'225,230,240';   // #E1E6F0
   g_themes[18].grid       = C'35,45,60';      // #232D3C
   g_themes[18].barUp      = C'29,99,255';     // #1D63FF
   g_themes[18].barDown    = C'255,119,0';     // #FF7700
   g_themes[18].candleBull = C'29,99,255';
   g_themes[18].candleBear = C'255,119,0';
   g_themes[18].chartLine  = C'70,150,255';
   g_themes[18].volumes    = C'65,80,100';
   g_themes[18].bid        = C'29,99,255';
   g_themes[18].ask        = C'255,119,0';
   g_themes[18].lastPrice  = C'255,215,0';
   g_themes[18].stopLevels = C'255,170,0';
   g_themes[18].isFavorite = false;

   // 19: Color Vision Pro (Accessibility - Deuteranopia/Protanopia)
   g_themes[19].name       = "Color Vision Pro";
   g_themes[19].category   = THEME_CAT_ACCESS;
   g_themes[19].bg         = C'20,24,33';      // #141821
   g_themes[19].fg         = C'235,240,248';   // #EBF0F8
   g_themes[19].grid       = C'40,48,65';      // #283041
   g_themes[19].barUp      = C'70,211,255';    // #46D3FF (Cyan)
   g_themes[19].barDown    = C'216,27,96';     // #D81B60 (Magenta)
   g_themes[19].candleBull = C'0,178,238';
   g_themes[19].candleBear = C'194,24,91';
   g_themes[19].chartLine  = C'70,211,255';
   g_themes[19].volumes    = C'75,85,110';
   g_themes[19].bid        = C'70,211,255';
   g_themes[19].ask        = C'216,27,96';
   g_themes[19].lastPrice  = C'255,193,7';
   g_themes[19].stopLevels = C'142,36,170';
   g_themes[19].isFavorite = false;

   // 20: Low Glare Dark (Accessibility - Eye Strain Relief)
   g_themes[20].name       = "Low Glare Dark";
   g_themes[20].category   = THEME_CAT_ACCESS;
   g_themes[20].bg         = C'24,26,27';      // #181A1B
   g_themes[20].fg         = C'180,185,190';   // #B4B9BE
   g_themes[20].grid       = C'42,46,48';      // #2A2E30
   g_themes[20].barUp      = C'115,168,128';   // #73A880 (Muted Sage)
   g_themes[20].barDown    = C'184,104,104';   // #B86868 (Terracotta)
   g_themes[20].candleBull = C'100,150,115';
   g_themes[20].candleBear = C'165,90,90';
   g_themes[20].chartLine  = C'130,165,185';
   g_themes[20].volumes    = C'65,70,75';
   g_themes[20].bid        = C'115,168,128';
   g_themes[20].ask        = C'184,104,104';
   g_themes[20].lastPrice  = C'195,160,100';
   g_themes[20].stopLevels = C'170,120,80';
   g_themes[20].isFavorite = false;

   // 21: Soft Contrast Light (Accessibility - Low Blue Light)
   g_themes[21].name       = "Soft Contrast Light";
   g_themes[21].category   = THEME_CAT_ACCESS;
   g_themes[21].bg         = C'245,239,235';   // #F5EFEB
   g_themes[21].fg         = C'56,64,71';      // #384047
   g_themes[21].grid       = C'225,218,212';   // #E1DAD4
   g_themes[21].barUp      = C'58,125,92';     // #3A7D5C
   g_themes[21].barDown    = C'158,77,72';     // #9E4D48
   g_themes[21].candleBull = C'68,138,102';
   g_themes[21].candleBear = C'170,85,80';
   g_themes[21].chartLine  = C'95,115,135';
   g_themes[21].volumes    = C'165,160,155';
   g_themes[21].bid        = C'58,125,92';
   g_themes[21].ask        = C'158,77,72';
   g_themes[21].lastPrice  = C'195,135,45';
   g_themes[21].stopLevels = C'165,85,60';
   g_themes[21].isFavorite = false;
   
   // Copy active theme to editor workbuffer
   g_edit_theme = g_themes[0];
}

//+------------------------------------------------------------------+
//| Initialize Preset Appearance Profiles                            |
//+------------------------------------------------------------------+
void InitializeProfiles()
{
   g_profiles[0].name          = "Night Workspace";
   g_profiles[0].themeIdx      = (int)THEME_MIDNIGHT_NAVY;
   g_profiles[0].showGrid      = false;
   g_profiles[0].showBid       = true;
   g_profiles[0].showAsk       = false;
   g_profiles[0].showPeriodSep = false;
   g_profiles[0].compactMode   = false;

   g_profiles[1].name          = "Clean Chart";
   g_profiles[1].themeIdx      = (int)THEME_OBSIDIAN_BLACK;
   g_profiles[1].showGrid      = false;
   g_profiles[1].showBid       = false;
   g_profiles[1].showAsk       = false;
   g_profiles[1].showPeriodSep = false;
   g_profiles[1].compactMode   = true;

   g_profiles[2].name          = "Presentation Mode";
   g_profiles[2].themeIdx      = (int)THEME_ARCTIC_WHITE;
   g_profiles[2].showGrid      = false;
   g_profiles[2].showBid       = false;
   g_profiles[2].showAsk       = false;
   g_profiles[2].showPeriodSep = false;
   g_profiles[2].compactMode   = true;

   g_profiles[3].name          = "High Contrast";
   g_profiles[3].themeIdx      = (int)THEME_HIGH_CONTRAST_DARK;
   g_profiles[3].showGrid      = true;
   g_profiles[3].showBid       = true;
   g_profiles[3].showAsk       = true;
   g_profiles[3].showPeriodSep = false;
   g_profiles[3].compactMode   = false;

   g_profiles[4].name          = "Minimal Light";
   g_profiles[4].themeIdx      = (int)THEME_MINIMAL_LIGHT;
   g_profiles[4].showGrid      = false;
   g_profiles[4].showBid       = true;
   g_profiles[4].showAsk       = false;
   g_profiles[4].showPeriodSep = false;
   g_profiles[4].compactMode   = false;

   g_profiles[5].name          = "Minimal Dark";
   g_profiles[5].themeIdx      = (int)THEME_DARK_GRAPHITE;
   g_profiles[5].showGrid      = false;
   g_profiles[5].showBid       = true;
   g_profiles[5].showAsk       = false;
   g_profiles[5].showPeriodSep = false;
   g_profiles[5].compactMode   = false;
}

//+------------------------------------------------------------------+
//| Chart State Snapshot Engine (Capture & Restore)                  |
//+------------------------------------------------------------------+
void SnapshotOriginalAppearance(const long chart_id)
{
   g_backup.bg         = (color)ChartGetInteger(chart_id, CHART_COLOR_BACKGROUND);
   g_backup.fg         = (color)ChartGetInteger(chart_id, CHART_COLOR_FOREGROUND);
   g_backup.grid       = (color)ChartGetInteger(chart_id, CHART_COLOR_GRID);
   g_backup.barUp      = (color)ChartGetInteger(chart_id, CHART_COLOR_CHART_UP);
   g_backup.barDown    = (color)ChartGetInteger(chart_id, CHART_COLOR_CHART_DOWN);
   g_backup.candleBull = (color)ChartGetInteger(chart_id, CHART_COLOR_CANDLE_BULL);
   g_backup.candleBear = (color)ChartGetInteger(chart_id, CHART_COLOR_CANDLE_BEAR);
   g_backup.chartLine  = (color)ChartGetInteger(chart_id, CHART_COLOR_CHART_LINE);
   g_backup.volumes    = (color)ChartGetInteger(chart_id, CHART_COLOR_VOLUME);
   g_backup.bid        = (color)ChartGetInteger(chart_id, CHART_COLOR_BID);
   g_backup.ask        = (color)ChartGetInteger(chart_id, CHART_COLOR_ASK);
   g_backup.lastPrice  = (color)ChartGetInteger(chart_id, CHART_COLOR_LAST);
   g_backup.stopLevels = (color)ChartGetInteger(chart_id, CHART_COLOR_STOP_LEVEL);
   
   g_backup.showGrid      = (bool)ChartGetInteger(chart_id, CHART_SHOW_GRID);
   g_backup.showPeriodSep = (bool)ChartGetInteger(chart_id, CHART_SHOW_PERIOD_SEP);
   g_backup.showBid       = (bool)ChartGetInteger(chart_id, CHART_SHOW_BID_LINE);
   g_backup.showAsk       = (bool)ChartGetInteger(chart_id, CHART_SHOW_ASK_LINE);
   g_backup.showLast      = (bool)ChartGetInteger(chart_id, CHART_SHOW_LAST_LINE);
   
   g_backup.isValid = true;
}

void RestoreOriginalAppearance(const long chart_id)
{
   if(!g_backup.isValid)
      return;
      
   ChartSetInteger(chart_id, CHART_COLOR_BACKGROUND,  g_backup.bg);
   ChartSetInteger(chart_id, CHART_COLOR_FOREGROUND,  g_backup.fg);
   ChartSetInteger(chart_id, CHART_COLOR_GRID,        g_backup.grid);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_UP,    g_backup.barUp);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_DOWN,  g_backup.barDown);
   ChartSetInteger(chart_id, CHART_COLOR_CANDLE_BULL, g_backup.candleBull);
   ChartSetInteger(chart_id, CHART_COLOR_CANDLE_BEAR, g_backup.candleBear);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_LINE,  g_backup.chartLine);
   ChartSetInteger(chart_id, CHART_COLOR_VOLUME,      g_backup.volumes);
   ChartSetInteger(chart_id, CHART_COLOR_BID,         g_backup.bid);
   ChartSetInteger(chart_id, CHART_COLOR_ASK,         g_backup.ask);
   ChartSetInteger(chart_id, CHART_COLOR_LAST,        g_backup.lastPrice);
   ChartSetInteger(chart_id, CHART_COLOR_STOP_LEVEL,  g_backup.stopLevels);
   
   ChartSetInteger(chart_id, CHART_SHOW_GRID,         g_backup.showGrid);
   ChartSetInteger(chart_id, CHART_SHOW_PERIOD_SEP,   g_backup.showPeriodSep);
   ChartSetInteger(chart_id, CHART_SHOW_BID_LINE,     g_backup.showBid);
   ChartSetInteger(chart_id, CHART_SHOW_ASK_LINE,     g_backup.showAsk);
   ChartSetInteger(chart_id, CHART_SHOW_LAST_LINE,    g_backup.showLast);
   
   ChartRedraw(chart_id);
   SetStatusMessage(Tr("STATUS_RESET"));
}

//+------------------------------------------------------------------+
//| Object Color Styling Engine                                      |
//+------------------------------------------------------------------+
void StyleSingleObject(const long chart_id, const string obj_name, const int theme_idx)
{
   if(!InpStyleDrawnObjects)
      return;
      
   if(StringFind(obj_name, g_ui_prefix) == 0)
      return; // Never touch our own UI objects
      
   const ThemePalette t = g_themes[theme_idx];
   ENUM_OBJECT obj_type = (ENUM_OBJECT)ObjectGetInteger(chart_id, obj_name, OBJPROP_TYPE);
   
   if(obj_type == OBJ_HLINE || obj_type == OBJ_VLINE)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.chartLine);
   }
   else if(obj_type == OBJ_TREND || obj_type == OBJ_TRENDBYANGLE)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.barUp);
   }
   else if(obj_type == OBJ_RECTANGLE || obj_type == OBJ_TRIANGLE || obj_type == OBJ_ELLIPSE)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.chartLine);
      if(ObjectGetInteger(chart_id, obj_name, OBJPROP_BACK))
         ObjectSetInteger(chart_id, obj_name, OBJPROP_BGCOLOR, t.grid);
   }
   else if(obj_type == OBJ_FIBO || obj_type == OBJ_FIBOFAN || obj_type == OBJ_FIBOTIMES || obj_type == OBJ_EXPANSION)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.fg);
      int levels = (int)ObjectGetInteger(chart_id, obj_name, OBJPROP_LEVELS);
      for(int i = 0; i < levels; i++)
         ObjectSetInteger(chart_id, obj_name, OBJPROP_LEVELCOLOR, i, t.fg);
   }
   else if(obj_type == OBJ_TEXT || obj_type == OBJ_LABEL)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.fg);
   }
   else if(obj_type == OBJ_ARROW_UP)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.barUp);
   }
   else if(obj_type == OBJ_ARROW_DOWN)
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.barDown);
   }
   else
   {
      ObjectSetInteger(chart_id, obj_name, OBJPROP_COLOR, t.chartLine);
   }
}

void StyleAllDrawnObjects(const long chart_id, const int theme_idx)
{
   if(!InpStyleDrawnObjects)
      return;
      
   int total = ObjectsTotal(chart_id, 0, -1);
   for(int i = 0; i < total; i++)
   {
      string name = ObjectName(chart_id, i, 0, -1);
      if(StringFind(name, g_ui_prefix) != 0)
         StyleSingleObject(chart_id, name, theme_idx);
   }
   ChartRedraw(chart_id);
}

//+------------------------------------------------------------------+
//| Apply Theme to Target Chart                                      |
//+------------------------------------------------------------------+
void ApplyThemeToChart(const long chart_id, const int theme_idx, const bool set_grid)
{
   if(theme_idx < 0 || theme_idx >= g_themes_count)
      return;
      
   const ThemePalette t = g_themes[theme_idx];
   
   ChartSetInteger(chart_id, CHART_COLOR_BACKGROUND,  t.bg);
   ChartSetInteger(chart_id, CHART_COLOR_FOREGROUND,  t.fg);
   ChartSetInteger(chart_id, CHART_COLOR_GRID,        t.grid);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_UP,    t.barUp);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_DOWN,  t.barDown);
   ChartSetInteger(chart_id, CHART_COLOR_CANDLE_BULL, t.candleBull);
   ChartSetInteger(chart_id, CHART_COLOR_CANDLE_BEAR, t.candleBear);
   ChartSetInteger(chart_id, CHART_COLOR_CHART_LINE,  t.chartLine);
   ChartSetInteger(chart_id, CHART_COLOR_VOLUME,      t.volumes);
   ChartSetInteger(chart_id, CHART_COLOR_BID,         t.bid);
   ChartSetInteger(chart_id, CHART_COLOR_ASK,         t.ask);
   ChartSetInteger(chart_id, CHART_COLOR_LAST,        t.lastPrice);
   ChartSetInteger(chart_id, CHART_COLOR_STOP_LEVEL,  t.stopLevels);
   
   ChartSetInteger(chart_id, CHART_SHOW_GRID,         set_grid);
   
   StyleAllDrawnObjects(chart_id, theme_idx);
   ChartRedraw(chart_id);
}

void ApplyThemeUniversal(const int theme_idx, const bool set_grid)
{
   if(g_chart_target == TARGET_ALL_OPEN_CHARTS)
   {
      long cid = ChartFirst();
      while(cid >= 0)
      {
         ApplyThemeToChart(cid, theme_idx, set_grid);
         cid = ChartNext(cid);
      }
   }
   else if(g_chart_target == TARGET_SAME_SYMBOL)
   {
      long cid = ChartFirst();
      while(cid >= 0)
      {
         if(ChartSymbol(cid) == _Symbol)
            ApplyThemeToChart(cid, theme_idx, set_grid);
         cid = ChartNext(cid);
      }
   }
   else
   {
      ApplyThemeToChart(g_chart_id, theme_idx, set_grid);
   }
}

//+------------------------------------------------------------------+
//| Persistence Engine (GlobalVariables)                             |
//+------------------------------------------------------------------+
string GetGVThemeKey()   { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_THM"; }
string GetGVGridKey()    { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_GRD"; }
string GetGVCompactKey() { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_CMP"; }
string GetGVPXKey()      { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_PX"; }
string GetGVPYKey()      { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_PY"; }
string GetGVLangKey()    { return "CTS_" + _Symbol + "_" + IntegerToString(_Period) + "_LNG"; }

void SaveSettings()
{
   if(!InpAutoSaveSettings)
      return;
      
   GlobalVariableSet(GetGVThemeKey(), (double)g_current_theme_idx);
   GlobalVariableSet(GetGVGridKey(), g_grid_state ? 1.0 : 0.0);
   GlobalVariableSet(GetGVCompactKey(), g_compact_mode ? 1.0 : 0.0);
   GlobalVariableSet(GetGVPXKey(), (double)g_panel_x);
   GlobalVariableSet(GetGVPYKey(), (double)g_panel_y);
   GlobalVariableSet(GetGVLangKey(), (double)g_current_lang);
}

void LoadSavedSettings()
{
   g_current_theme_idx = (int)InpInitialTheme;
   g_grid_state        = InpDefaultGrid;
   g_compact_mode      = InpStartCompact;
   g_panel_x           = InpPanelOffsetX;
   g_panel_y           = InpPanelOffsetY;
   g_current_lang      = InpDefaultLanguage;
   g_chart_target      = InpChartTargetScope;
   
   if(InpRestoreSavedTheme)
   {
      string kTheme = GetGVThemeKey();
      if(GlobalVariableCheck(kTheme))
      {
         int saved = (int)GlobalVariableGet(kTheme);
         if(saved >= 0 && saved < g_themes_count)
            g_current_theme_idx = saved;
      }
      
      string kGrid = GetGVGridKey();
      if(GlobalVariableCheck(kGrid))
         g_grid_state = (GlobalVariableGet(kGrid) > 0.5);
         
      string kCmp = GetGVCompactKey();
      if(GlobalVariableCheck(kCmp))
         g_compact_mode = (GlobalVariableGet(kCmp) > 0.5);
         
      string kPX = GetGVPXKey();
      if(GlobalVariableCheck(kPX))
         g_panel_x = (int)GlobalVariableGet(kPX);
         
      string kPY = GetGVPYKey();
      if(GlobalVariableCheck(kPY))
         g_panel_y = (int)GlobalVariableGet(kPY);
         
      string kLng = GetGVLangKey();
      if(GlobalVariableCheck(kLng))
         g_current_lang = (ENUM_UI_LANG)(int)GlobalVariableGet(kLng);
   }
}

//+------------------------------------------------------------------+
//| Recent Themes Management                                         |
//+------------------------------------------------------------------+
void AddRecentTheme(const int idx)
{
   if(idx < 0 || idx >= g_themes_count) return;
   if(g_recent_count > 0 && g_recent_themes[0] == idx) return;
   
   int new_arr[MAX_RECENT];
   new_arr[0] = idx;
   int cnt = 1;
   for(int i = 0; i < g_recent_count && cnt < MAX_RECENT; i++)
   {
      if(g_recent_themes[i] != idx)
      {
         new_arr[cnt] = g_recent_themes[i];
         cnt++;
      }
   }
   for(int i = 0; i < cnt; i++)
      g_recent_themes[i] = new_arr[i];
   g_recent_count = cnt;
}

//+------------------------------------------------------------------+
//| Intelligent Random Theme Engine                                  |
//+------------------------------------------------------------------+
int PickIntelligentRandomTheme(const ENUM_THEME_CATEGORY filter_cat = (ENUM_THEME_CATEGORY)-1)
{
   MathSrand((uint)GetTickCount());
   int candidates[];
   ArrayResize(candidates, 0);
   
   for(int i = 0; i < g_themes_count; i++)
   {
      if(i == g_current_theme_idx)
         continue;
         
      if(filter_cat != (ENUM_THEME_CATEGORY)-1 && g_themes[i].category != filter_cat)
         continue;
         
      int size = ArraySize(candidates);
      ArrayResize(candidates, size + 1);
      candidates[size] = i;
   }
   
   if(ArraySize(candidates) == 0)
      return (g_current_theme_idx + 1) % g_themes_count;
      
   int picked = MathRand() % ArraySize(candidates);
   return candidates[picked];
}

//+------------------------------------------------------------------+
//| Theme Navigation & Actions                                       |
//+------------------------------------------------------------------+
void SetTheme(const int idx)
{
   if(idx < 0 || idx >= g_themes_count)
      return;
      
   g_current_theme_idx = idx;
   AddRecentTheme(idx);
   ApplyThemeUniversal(g_current_theme_idx, g_grid_state);
   SaveSettings();
   SetStatusMessage(Tr("STATUS_APPLIED") + ": " + g_themes[idx].name);
   BuildUIPanel();
}

void NextTheme()
{
   SetTheme((g_current_theme_idx + 1) % g_themes_count);
}

void PrevTheme()
{
   SetTheme((g_current_theme_idx - 1 + g_themes_count) % g_themes_count);
}

void TriggerIntelligentRandom()
{
   SetTheme(PickIntelligentRandomTheme());
}

void ToggleGrid()
{
   g_grid_state = !g_grid_state;
   ApplyThemeUniversal(g_current_theme_idx, g_grid_state);
   SaveSettings();
   BuildUIPanel();
}

void ToggleFocusMode()
{
   g_focus_mode = !g_focus_mode;
   if(g_focus_mode)
   {
      g_pre_focus_theme   = g_current_theme_idx;
      g_pre_focus_grid    = g_grid_state;
      g_pre_focus_compact = g_compact_mode;
      
      g_grid_state = false;
      g_compact_mode = true;
      ApplyThemeUniversal(g_current_theme_idx, false);
      SetStatusMessage("Focus Mode: ON");
   }
   else
   {
      g_grid_state   = g_pre_focus_grid;
      g_compact_mode = g_pre_focus_compact;
      SetTheme(g_pre_focus_theme);
      SetStatusMessage("Focus Mode: OFF");
   }
   BuildUIPanel();
}

void TogglePresentationMode()
{
   g_presentation_mode = !g_presentation_mode;
   if(g_presentation_mode)
   {
      DeleteAllUIObjects();
      // Render discreet tiny toggle button at top corner
      CreateButton(g_ui_prefix + "BTN_EXIT_PRES", "■ " + Tr("PRES_EXIT"),
                   20, 15, 120, 24, C'20,24,35', C'255,255,255', C'56,189,248', 8, CORNER_LEFT_UPPER, 50);
      ChartRedraw(g_chart_id);
   }
   else
   {
      BuildUIPanel();
   }
}

void ApplyProfile(const int prof_idx)
{
   if(prof_idx < 0 || prof_idx >= TOTAL_PROFILES)
      return;
      
   g_current_profile_idx = prof_idx;
   const AppearanceProfile p = g_profiles[prof_idx];
   g_grid_state   = p.showGrid;
   g_compact_mode = p.compactMode;
   
   ChartSetInteger(g_chart_id, CHART_SHOW_BID_LINE,   p.showBid);
   ChartSetInteger(g_chart_id, CHART_SHOW_ASK_LINE,   p.showAsk);
   ChartSetInteger(g_chart_id, CHART_SHOW_PERIOD_SEP, p.showPeriodSep);
   
   SetTheme(p.themeIdx);
   SetStatusMessage("Profile applied: " + p.name);
}

//+------------------------------------------------------------------+
//| Import & Export .cts Theme File Engine                           |
//+------------------------------------------------------------------+
bool ExportThemeToCTS(const ThemePalette &t, string filename = "")
{
   FolderCreate("AuraChart", 0);
   if(filename == "")
   {
      filename = t.name;
      StringReplace(filename, " ", "_");
   }
   if(StringFind(filename, ".cts") < 0)
      filename += ".cts";
      
   int h = FileOpen("AuraChart\\" + filename, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
      return false;
      
   FileWriteString(h, "# ===============================================\r\n");
   FileWriteString(h, "# AuraChart Studio Theme File (.cts)\r\n");
   FileWriteString(h, "# Created by: " + t.name + "\r\n");
   FileWriteString(h, "# ===============================================\r\n");
   FileWriteString(h, "format_version=1.1\r\n");
   FileWriteString(h, "name=" + t.name + "\r\n");
   string catStr = "Dark";
   if(t.category == THEME_CAT_LIGHT) catStr = "Light";
   else if(t.category == THEME_CAT_ACCESS) catStr = "Accessibility";
   FileWriteString(h, "category=" + catStr + "\r\n");
   FileWriteString(h, "bg=" + ColorToHex(t.bg) + "\r\n");
   FileWriteString(h, "fg=" + ColorToHex(t.fg) + "\r\n");
   FileWriteString(h, "grid=" + ColorToHex(t.grid) + "\r\n");
   FileWriteString(h, "bar_up=" + ColorToHex(t.barUp) + "\r\n");
   FileWriteString(h, "bar_down=" + ColorToHex(t.barDown) + "\r\n");
   FileWriteString(h, "candle_bull=" + ColorToHex(t.candleBull) + "\r\n");
   FileWriteString(h, "candle_bear=" + ColorToHex(t.candleBear) + "\r\n");
   FileWriteString(h, "chart_line=" + ColorToHex(t.chartLine) + "\r\n");
   FileWriteString(h, "volumes=" + ColorToHex(t.volumes) + "\r\n");
   FileWriteString(h, "bid=" + ColorToHex(t.bid) + "\r\n");
   FileWriteString(h, "ask=" + ColorToHex(t.ask) + "\r\n");
   FileWriteString(h, "last_price=" + ColorToHex(t.lastPrice) + "\r\n");
   FileWriteString(h, "stop_levels=" + ColorToHex(t.stopLevels) + "\r\n");
   FileClose(h);
   return true;
}

bool ImportThemeFromCTS(string filename, ThemePalette &out_t)
{
   if(StringFind(filename, ".cts") < 0)
      filename += ".cts";
      
   if(StringFind(filename, "..") >= 0 || StringFind(filename, "/") >= 0 || StringFind(filename, "\\") >= 0)
      return false;
      
   int h = FileOpen("AuraChart\\" + filename, FILE_READ | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
      return false;
      
   bool hasVersion = false;
   bool hasBg = false;
   while(!FileIsEnding(h))
   {
      string line = FileReadString(h);
      StringTrimLeft(line);
      StringTrimRight(line);
      if(StringLen(line) == 0 || StringSubstr(line, 0, 1) == "#" || StringSubstr(line, 0, 1) == ";")
         continue;
      int eq = StringFind(line, "=");
      if(eq <= 0) continue;
      string k = StringSubstr(line, 0, eq);
      string v = StringSubstr(line, eq + 1);
      StringTrimLeft(k); StringTrimRight(k);
      StringTrimLeft(v); StringTrimRight(v);
      
      if(k == "format_version") hasVersion = true;
      else if(k == "name") out_t.name = v;
      else if(k == "category")
      {
         if(v == "Light") out_t.category = THEME_CAT_LIGHT;
         else if(v == "Accessibility") out_t.category = THEME_CAT_ACCESS;
         else out_t.category = THEME_CAT_DARK;
      }
      else if(k == "bg") { out_t.bg = HexToColor(v); hasBg = true; }
      else if(k == "fg") out_t.fg = HexToColor(v);
      else if(k == "grid") out_t.grid = HexToColor(v);
      else if(k == "bar_up") out_t.barUp = HexToColor(v);
      else if(k == "bar_down") out_t.barDown = HexToColor(v);
      else if(k == "candle_bull") out_t.candleBull = HexToColor(v);
      else if(k == "candle_bear") out_t.candleBear = HexToColor(v);
      else if(k == "chart_line") out_t.chartLine = HexToColor(v);
      else if(k == "volumes") out_t.volumes = HexToColor(v);
      else if(k == "bid") out_t.bid = HexToColor(v);
      else if(k == "ask") out_t.ask = HexToColor(v);
      else if(k == "last_price") out_t.lastPrice = HexToColor(v);
      else if(k == "stop_levels") out_t.stopLevels = HexToColor(v);
   }
   FileClose(h);
   return (hasVersion && hasBg);
}

//+------------------------------------------------------------------+
//| UI Engine: Helper Object Functions                               |
//+------------------------------------------------------------------+
bool CreateRectLabel(const string name, const int x, const int y, const int w, const int h,
                     const color bg_col, const color border_col, const ENUM_BASE_CORNER corner)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_col);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_COLOR, border_col);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_col);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
   return true;
}

bool CreateButton(const string name, const string text, const int x, const int y, const int w, const int h,
                  const color bg_col, const color txt_col, const color border_col, const int font_size,
                  const ENUM_BASE_CORNER corner, const int zorder = 20)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, InpFontName);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_COLOR, txt_col);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_col);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_col);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, zorder);
   return true;
}

bool CreateLabel(const string name, const string text, const int x, const int y,
                 const color txt_col, const int font_size, const ENUM_BASE_CORNER corner, const bool bold = false)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, InpFontName + (bold ? " Bold" : ""));
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_COLOR, txt_col);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 25);
   return true;
}

bool CreateEdit(const string name, const string text, const int x, const int y, const int w, const int h,
                const color bg_col, const color txt_col, const color border_col, const int font_size,
                const ENUM_BASE_CORNER corner)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   if(!ObjectCreate(0, name, OBJ_EDIT, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, InpFontName);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(0, name, OBJPROP_COLOR, txt_col);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg_col);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, border_col);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 30);
   return true;
}

void SetStatusMessage(const string msg)
{
   g_status_msg  = msg;
   g_status_time = TimeLocal();
   if(ObjectFind(0, g_ui_prefix + "LBL_STATUS") >= 0)
      ObjectSetString(0, g_ui_prefix + "LBL_STATUS", OBJPROP_TEXT, msg);
}

//+------------------------------------------------------------------+
//| UI Cleanup Engine                                                |
//+------------------------------------------------------------------+
void DeleteAllUIObjects()
{
   int total = ObjectsTotal(0, 0, -1);
   for(int i = total - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i, 0, -1);
      if(StringFind(name, g_ui_prefix) == 0)
         ObjectDelete(0, name);
   }
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| UI Builder Engine: Main HUD Frame & Tabs                         |
//+------------------------------------------------------------------+
void BuildUIPanel()
{
   if(!InpShowPanel || g_presentation_mode)
      return;
      
   DeleteAllUIObjects();
   
   const color card_bg     = C'15,23,42';      // Modern slate navy #0F172A
   const color card_border = C'30,41,59';      // #1E293B
   const color header_bg   = C'10,15,30';      // #0A0F1E
   const color btn_normal  = C'30,41,59';
   const color btn_active  = C'14,165,233';    // Bright Cyan #0EA5E9
   const color btn_accent  = C'56,189,248';
   const color text_main   = C'241,245,249';   // #F1F5F9
   const color text_muted  = C'148,163,184';   // #94A3B8

   // -----------------------------------------------------------------
   // 1. Compact (Mini-Pill) Mode Layout
   // -----------------------------------------------------------------
   if(g_compact_mode)
   {
      int pillW = 320;
      int pillH = 36;
      CreateRectLabel(g_ui_prefix + "BG_PILL", g_panel_x, g_panel_y, pillW, pillH, card_bg, card_border, InpPanelCorner);
      
      // Drag handle icon
      CreateLabel(g_ui_prefix + "LBL_DRAG", "⋮⋮", g_panel_x + 8, g_panel_y + 8, text_muted, 10, InpPanelCorner, true);
      
      // Expand Button
      CreateButton(g_ui_prefix + "BTN_EXPAND", "▢ Full", g_panel_x + 28, g_panel_y + 6, 54, 24, btn_normal, text_main, card_border, 8, InpPanelCorner);
      
      // Active Theme Name Button (click cycles theme)
      string thmLabel = g_themes[g_current_theme_idx].name;
      if(StringLen(thmLabel) > 13) thmLabel = StringSubstr(thmLabel, 0, 11) + "..";
      CreateButton(g_ui_prefix + "BTN_PILL_THM", thmLabel, g_panel_x + 86, g_panel_y + 6, 95, 24, btn_normal, btn_accent, card_border, 8, InpPanelCorner);
      
      // Prev / Next Buttons
      CreateButton(g_ui_prefix + "BTN_PREV", "◄", g_panel_x + 185, g_panel_y + 6, 26, 24, btn_normal, text_main, card_border, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_NEXT", "►", g_panel_x + 214, g_panel_y + 6, 26, 24, btn_normal, text_main, card_border, 8, InpPanelCorner);
      
      // Grid Button
      color gridCol = g_grid_state ? btn_active : btn_normal;
      CreateButton(g_ui_prefix + "BTN_GRID", "#", g_panel_x + 244, g_panel_y + 6, 26, 24, gridCol, text_main, card_border, 8, InpPanelCorner);
      
      // Focus Button
      color focCol = g_focus_mode ? C'234,88,12' : btn_normal;
      CreateButton(g_ui_prefix + "BTN_FOCUS", "◉", g_panel_x + 273, g_panel_y + 6, 26, 24, focCol, text_main, card_border, 8, InpPanelCorner);
      
      // Close Button
      CreateButton(g_ui_prefix + "BTN_CLOSE_HUD", "✕", g_panel_x + 301, g_panel_y + 6, 15, 24, card_bg, text_muted, card_bg, 8, InpPanelCorner);
      ChartRedraw(0);
      return;
   }

   // -----------------------------------------------------------------
   // 2. Full HUD Layout
   // -----------------------------------------------------------------
   int hudW = 280;
   int hudH = 265;
   
   // Card Backdrop
   CreateRectLabel(g_ui_prefix + "BG_PANEL", g_panel_x, g_panel_y, hudW, hudH, card_bg, card_border, InpPanelCorner);
   
   // Header Bar (Drag Handle)
   CreateRectLabel(g_ui_prefix + "BG_HEADER", g_panel_x, g_panel_y, hudW, 30, header_bg, card_border, InpPanelCorner);
   CreateLabel(g_ui_prefix + "LBL_TITLE", "🌌 " + Tr("TITLE_APP"), g_panel_x + 10, g_panel_y + 7, text_main, 8, InpPanelCorner, true);
   
   // Collapse to Mini Mode
   CreateButton(g_ui_prefix + "BTN_COLLAPSE", "_", g_panel_x + hudW - 46, g_panel_y + 5, 20, 20, header_bg, text_muted, header_bg, 9, InpPanelCorner);
   // Close HUD
   CreateButton(g_ui_prefix + "BTN_CLOSE_HUD", "✕", g_panel_x + hudW - 24, g_panel_y + 5, 20, 20, header_bg, text_muted, header_bg, 9, InpPanelCorner);

   // Navigation Tab Bar
   int tabY = g_panel_y + 34;
   int tabW = 52;
   CreateButton(g_ui_prefix + "TAB_0", Tr("TAB_THEMES"),   g_panel_x + 6 + (0 * tabW), tabY, tabW - 2, 22, (g_active_tab == TAB_THEMES   ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
   CreateButton(g_ui_prefix + "TAB_1", Tr("TAB_EDITOR"),   g_panel_x + 6 + (1 * tabW), tabY, tabW - 2, 22, (g_active_tab == TAB_EDITOR   ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
   CreateButton(g_ui_prefix + "TAB_2", Tr("TAB_PROFILES"), g_panel_x + 6 + (2 * tabW), tabY, tabW - 2, 22, (g_active_tab == TAB_PROFILES ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
   CreateButton(g_ui_prefix + "TAB_3", Tr("TAB_SCHEDULE"), g_panel_x + 6 + (3 * tabW), tabY, tabW - 2, 22, (g_active_tab == TAB_SCHEDULE ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
   CreateButton(g_ui_prefix + "TAB_4", Tr("TAB_SETTINGS"), g_panel_x + 6 + (4 * tabW), tabY, tabW - 2, 22, (g_active_tab == TAB_SETTINGS ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

   // -----------------------------------------------------------------
   // TAB 0: Themes & Quick Controls
   // -----------------------------------------------------------------
   if(g_active_tab == TAB_THEMES)
   {
      // Theme Display Banner
      int thmBoxY = g_panel_y + 62;
      CreateRectLabel(g_ui_prefix + "BG_ACTIVE_THM", g_panel_x + 10, thmBoxY, hudW - 20, 48, header_bg, card_border, InpPanelCorner);
      
      CreateLabel(g_ui_prefix + "LBL_ACT_THM", Tr("LBL_ACTIVE_THEME"), g_panel_x + 18, thmBoxY + 6, text_muted, 7, InpPanelCorner);
      CreateLabel(g_ui_prefix + "LBL_THM_NAME", g_themes[g_current_theme_idx].name, g_panel_x + 18, thmBoxY + 22, btn_accent, 9, InpPanelCorner, true);
      
      // Favorite Star toggle
      string starIcon = g_themes[g_current_theme_idx].isFavorite ? "★" : "☆";
      color starColor = g_themes[g_current_theme_idx].isFavorite ? C'234,179,8' : text_muted;
      CreateButton(g_ui_prefix + "BTN_FAV", starIcon, g_panel_x + hudW - 40, thmBoxY + 10, 26, 26, card_bg, starColor, card_border, 11, InpPanelCorner);
      
      // Quick Control Buttons
      int row1Y = g_panel_y + 116;
      CreateButton(g_ui_prefix + "BTN_PREV", Tr("BTN_PREV"), g_panel_x + 10, row1Y, 78, 26, btn_normal, text_main, card_border, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_NEXT", Tr("BTN_NEXT"), g_panel_x + 92, row1Y, 78, 26, btn_normal, text_main, card_border, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_RANDOM", Tr("BTN_RANDOM"), g_panel_x + 174, row1Y, 96, 26, btn_normal, btn_accent, card_border, 8, InpPanelCorner);

      int row2Y = g_panel_y + 148;
      color gridBg = g_grid_state ? btn_active : btn_normal;
      CreateButton(g_ui_prefix + "BTN_GRID", Tr("BTN_GRID") + ": " + (g_grid_state ? Tr("VAL_ON") : Tr("VAL_OFF")),
                   g_panel_x + 10, row2Y, 126, 26, gridBg, text_main, card_border, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_FOCUS", Tr("BTN_FOCUS"), g_panel_x + 142, row2Y, 128, 26, btn_normal, text_main, card_border, 8, InpPanelCorner);

      // Category Fast Pickers
      int row3Y = g_panel_y + 180;
      CreateButton(g_ui_prefix + "BTN_CAT_DARK", "Dark (8)", g_panel_x + 10, row3Y, 82, 24, C'20,24,35', text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_CAT_LIGHT", "Light (8)", g_panel_x + 96, row3Y, 82, 24, C'230,235,245', C'20,24,35', card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_CAT_ACCESS", "A11y (6)", g_panel_x + 182, row3Y, 88, 24, C'16,80,120', text_main, card_border, 7, InpPanelCorner);

      // Recent History Row
      int row4Y = g_panel_y + 210;
      CreateLabel(g_ui_prefix + "LBL_REC", Tr("LBL_RECENT"), g_panel_x + 12, row4Y + 4, text_muted, 7, InpPanelCorner);
      for(int r = 0; r < g_recent_count && r < 4; r++)
      {
         int rIdx = g_recent_themes[r];
         string rName = IntegerToString(rIdx + 1);
         CreateButton(g_ui_prefix + "BTN_REC_" + IntegerToString(rIdx), rName,
                      g_panel_x + 55 + (r * 32), row4Y, 28, 20, btn_normal, text_main, card_border, 7, InpPanelCorner);
      }
   }

   // -----------------------------------------------------------------
   // TAB 1: Theme Editor
   // -----------------------------------------------------------------
   else if(g_active_tab == TAB_EDITOR)
   {
      // Target Property Selection Buttons
      int propY = g_panel_y + 60;
      CreateButton(g_ui_prefix + "ED_P_BG", Tr("PROP_BG"), g_panel_x + 10, propY, 62, 20, (g_edit_prop == PROP_BG ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_FG", Tr("PROP_FG"), g_panel_x + 75, propY, 62, 20, (g_edit_prop == PROP_FG ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_GRID", Tr("PROP_GRID"), g_panel_x + 140, propY, 62, 20, (g_edit_prop == PROP_GRID ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_BULL", Tr("PROP_BULL"), g_panel_x + 205, propY, 65, 20, (g_edit_prop == PROP_CANDLE_BULL ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      int propY2 = g_panel_y + 83;
      CreateButton(g_ui_prefix + "ED_P_BEAR", Tr("PROP_BEAR"), g_panel_x + 10, propY2, 62, 20, (g_edit_prop == PROP_CANDLE_BEAR ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_LINE", Tr("PROP_LINE"), g_panel_x + 75, propY2, 62, 20, (g_edit_prop == PROP_CHART_LINE ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_BID", Tr("PROP_BID"), g_panel_x + 140, propY2, 62, 20, (g_edit_prop == PROP_BID ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_P_ASK", Tr("PROP_ASK"), g_panel_x + 205, propY2, 65, 20, (g_edit_prop == PROP_ASK ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      // Color Hex Input & Swatch Preview
      int hexY = g_panel_y + 110;
      color curEditCol = g_edit_theme.bg;
      if(g_edit_prop == PROP_FG) curEditCol = g_edit_theme.fg;
      else if(g_edit_prop == PROP_GRID) curEditCol = g_edit_theme.grid;
      else if(g_edit_prop == PROP_CANDLE_BULL) curEditCol = g_edit_theme.candleBull;
      else if(g_edit_prop == PROP_CANDLE_BEAR) curEditCol = g_edit_theme.candleBear;
      else if(g_edit_prop == PROP_CHART_LINE) curEditCol = g_edit_theme.chartLine;
      else if(g_edit_prop == PROP_BID) curEditCol = g_edit_theme.bid;
      else if(g_edit_prop == PROP_ASK) curEditCol = g_edit_theme.ask;
      
      CreateRectLabel(g_ui_prefix + "ED_SWATCH", g_panel_x + 12, hexY, 26, 24, curEditCol, text_main, InpPanelCorner);
      CreateEdit(g_ui_prefix + "ED_INPUT_HEX", ColorToHex(curEditCol), g_panel_x + 44, hexY, 82, 24, header_bg, text_main, card_border, 8, InpPanelCorner);
      
      // Contrast Checker
      double ratio = ContrastRatio(g_edit_theme.fg, g_edit_theme.bg);
      string ratioStr = StringFormat("%.1f:1 %s", ratio, (ratio >= 4.5 ? Tr("VAL_GOOD") : Tr("VAL_POOR")));
      color ratioCol = (ratio >= 4.5) ? C'16,185,129' : C'239,68,68';
      CreateLabel(g_ui_prefix + "ED_LBL_RATIO", Tr("LBL_CONTRAST") + " " + ratioStr, g_panel_x + 132, hexY + 5, ratioCol, 7, InpPanelCorner);

      // Quick Color Palette Matrix (12 colors)
      int palY = g_panel_y + 140;
      color palColors[12] = {
         C'15,23,42', C'18,18,18', C'46,52,64', C'14,165,233', C'16,185,129', C'244,63,94',
         C'255,255,255', C'250,249,246', C'241,245,249', C'255,214,0', C'168,85,247', C'249,115,22'
      };
      for(int c = 0; c < 12; c++)
      {
         int px = g_panel_x + 12 + (c * 21);
         CreateButton(g_ui_prefix + "ED_QUICK_" + IntegerToString(c), "", px, palY, 18, 18, palColors[c], palColors[c], card_border, 6, InpPanelCorner);
      }

      // Theme Name Input
      int nameY = g_panel_y + 166;
      CreateEdit(g_ui_prefix + "ED_INPUT_NAME", g_edit_theme.name, g_panel_x + 12, nameY, 160, 22, header_bg, text_main, card_border, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_BTN_APPLY", Tr("BTN_APPLY"), g_panel_x + 178, nameY, 92, 22, btn_active, text_main, card_border, 7, InpPanelCorner);

      // Action Buttons (Save, Export, Import)
      int actY = g_panel_y + 194;
      CreateButton(g_ui_prefix + "ED_BTN_SAVE", Tr("BTN_SAVE"), g_panel_x + 12, actY, 82, 22, btn_normal, text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_BTN_EXPORT", Tr("BTN_EXPORT"), g_panel_x + 98, actY, 82, 22, btn_normal, text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "ED_BTN_IMPORT", Tr("BTN_IMPORT"), g_panel_x + 184, actY, 86, 22, btn_normal, text_main, card_border, 7, InpPanelCorner);
   }

   // -----------------------------------------------------------------
   // TAB 2: Appearance Profiles
   // -----------------------------------------------------------------
   else if(g_active_tab == TAB_PROFILES)
   {
      int profY = g_panel_y + 62;
      CreateLabel(g_ui_prefix + "LBL_ACT_PROF", Tr("LBL_ACTIVE_PROF"), g_panel_x + 14, profY, text_muted, 7, InpPanelCorner);
      CreateLabel(g_ui_prefix + "LBL_PROF_NAME", g_profiles[g_current_profile_idx].name, g_panel_x + 14, profY + 16, btn_accent, 8, InpPanelCorner, true);

      // 6 Profile Buttons
      int btnY = g_panel_y + 96;
      CreateButton(g_ui_prefix + "PROF_0", g_profiles[0].name, g_panel_x + 12, btnY, 124, 24, (g_current_profile_idx == 0 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "PROF_1", g_profiles[1].name, g_panel_x + 142, btnY, 126, 24, (g_current_profile_idx == 1 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      int btnY2 = g_panel_y + 124;
      CreateButton(g_ui_prefix + "PROF_2", g_profiles[2].name, g_panel_x + 12, btnY2, 124, 24, (g_current_profile_idx == 2 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "PROF_3", g_profiles[3].name, g_panel_x + 142, btnY2, 126, 24, (g_current_profile_idx == 3 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      int btnY3 = g_panel_y + 152;
      CreateButton(g_ui_prefix + "PROF_4", g_profiles[4].name, g_panel_x + 12, btnY3, 124, 24, (g_current_profile_idx == 4 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "PROF_5", g_profiles[5].name, g_panel_x + 142, btnY3, 126, 24, (g_current_profile_idx == 5 ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      // Save Current as Profile
      int saveY = g_panel_y + 184;
      CreateButton(g_ui_prefix + "BTN_SAVE_PROF", "💾 Save Current State as Profile", g_panel_x + 12, saveY, 256, 26, btn_normal, btn_accent, card_border, 7, InpPanelCorner);
   }

   // -----------------------------------------------------------------
   // TAB 3: Auto Day/Night Scheduling & Target Scope
   // -----------------------------------------------------------------
   else if(g_active_tab == TAB_SCHEDULE)
   {
      int schY = g_panel_y + 64;
      CreateLabel(g_ui_prefix + "LBL_SCH_ST", Tr("LBL_SCHEDULE_ST"), g_panel_x + 14, schY, text_main, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_TOGGLE_SCH", (InpAutoSchedule ? Tr("VAL_ON") : Tr("VAL_OFF")),
                   g_panel_x + hudW - 80, schY - 4, 66, 22, (InpAutoSchedule ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      int timeY = g_panel_y + 92;
      CreateLabel(g_ui_prefix + "LBL_DAY_TIME", "☀ Day: " + InpDayStartTime, g_panel_x + 14, timeY, text_muted, 7, InpPanelCorner);
      CreateLabel(g_ui_prefix + "LBL_NIGHT_TIME", "☾ Night: " + InpNightStartTime, g_panel_x + 144, timeY, text_muted, 7, InpPanelCorner);

      int clkY = g_panel_y + 116;
      CreateLabel(g_ui_prefix + "LBL_CLK_SRC", Tr("LBL_TIME_SRC") + " " + (InpScheduleUseLocalTime ? "PC Local" : "Broker Server"), g_panel_x + 14, clkY, text_muted, 7, InpPanelCorner);

      // Target Chart Scope Selection
      int tgtY = g_panel_y + 144;
      CreateLabel(g_ui_prefix + "LBL_TGT", Tr("TARGET_SCOPE"), g_panel_x + 14, tgtY, text_main, 8, InpPanelCorner);

      int tgtBtnsY = g_panel_y + 164;
      CreateButton(g_ui_prefix + "BTN_TGT_CURR", Tr("TARGET_CURR"), g_panel_x + 12, tgtBtnsY, 124, 24, (g_chart_target == TARGET_CURRENT_CHART ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_TGT_ALL", Tr("TARGET_ALL"), g_panel_x + 142, tgtBtnsY, 126, 24, (g_chart_target == TARGET_ALL_OPEN_CHARTS ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      int tgtBtnsY2 = g_panel_y + 192;
      CreateButton(g_ui_prefix + "BTN_TGT_SYM", Tr("TARGET_SYM"), g_panel_x + 12, tgtBtnsY2, 256, 24, (g_chart_target == TARGET_SAME_SYMBOL ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
   }

   // -----------------------------------------------------------------
   // TAB 4: Settings & About
   // -----------------------------------------------------------------
   else if(g_active_tab == TAB_SETTINGS)
   {
      // Language Selection
      int lngY = g_panel_y + 64;
      CreateLabel(g_ui_prefix + "LBL_LNG", "Language / زبان:", g_panel_x + 14, lngY, text_main, 8, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_LNG_EN", "English", g_panel_x + 128, lngY - 4, 64, 22, (g_current_lang == LANG_EN ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_LNG_FA", "فارسی", g_panel_x + 196, lngY - 4, 72, 22, (g_current_lang == LANG_FA ? btn_active : btn_normal), text_main, card_border, 7, InpPanelCorner);

      // Hotkeys Status
      int hkY = g_panel_y + 94;
      CreateLabel(g_ui_prefix + "LBL_HK", Tr("LBL_HOTKEYS_ST") + " T/Y=Cycle, R=Rand, G=Grid, F=Focus", g_panel_x + 14, hkY, text_muted, 7, InpPanelCorner);

      // Rollback to Initial Appearance
      int rstY = g_panel_y + 126;
      CreateButton(g_ui_prefix + "BTN_RESET_INIT", "⟲ " + Tr("BTN_RESET"), g_panel_x + 12, rstY, 124, 26, C'153,27,27', text_main, card_border, 7, InpPanelCorner);
      CreateButton(g_ui_prefix + "BTN_INFO_MODAL", "ℹ About / Credits", g_panel_x + 142, rstY, 126, 26, btn_normal, text_main, card_border, 7, InpPanelCorner);

      // Non-Trading Notice
      int ntfY = g_panel_y + 160;
      CreateRectLabel(g_ui_prefix + "BG_NTF", g_panel_x + 12, ntfY, hudW - 24, 52, header_bg, card_border, InpPanelCorner);
      CreateLabel(g_ui_prefix + "LBL_NTF1", "🛡 100% Non-Trading Utility", g_panel_x + 18, ntfY + 6, C'16,185,129', 7, InpPanelCorner, true);
      CreateLabel(g_ui_prefix + "LBL_NTF2", "Does NOT open, close, or affect trades.", g_panel_x + 18, ntfY + 20, text_muted, 7, InpPanelCorner);
      CreateLabel(g_ui_prefix + "LBL_NTF3", "Zero DLLs | Pure Native MQL5", g_panel_x + 18, ntfY + 34, text_muted, 7, InpPanelCorner);
   }

   // -----------------------------------------------------------------
   // Global Status / Notification Footer
   // -----------------------------------------------------------------
   int statusY = g_panel_y + hudH - 24;
   string currentMsg = g_status_msg;
   if(TimeLocal() - g_status_time > 15)
      currentMsg = "Ready | AuraChart Studio v2.0";
   CreateLabel(g_ui_prefix + "LBL_STATUS", currentMsg, g_panel_x + 12, statusY, text_muted, 7, InpPanelCorner);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Update Dynamic UI Positions on Drag                              |
//+------------------------------------------------------------------+
void UpdateUIPositions()
{
   BuildUIPanel();
}

//+------------------------------------------------------------------+
//| Author & About Dialog                                            |
//+------------------------------------------------------------------+
void ShowAuthorModal()
{
   string msg = "AuraChart Studio (ChartTheme Studio Pro) v2.0\n"
              + "====================================\n"
              + "Author: Shayan Namayandeh (SudoShayanNA)\n"
              + "Email: namayandeshayan@gmail.com\n"
              + "Telegram: @SudoShayanNA\n"
              + "GitHub: https://github.com/roseshayan/AuraChart-Studio\n"
              + "====================================\n"
              + "IMPORTANT NOTICE:\n"
              + "This tool is 100% NON-TRADING.\n"
              + "It does NOT place, modify, or execute orders.\n"
              + "It has ZERO effect on your trading accounts.";
   MessageBox(msg, "About AuraChart Studio", MB_OK | MB_ICONINFORMATION);
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   g_chart_id  = ChartID();
   g_ui_prefix = "CTS_" + IntegerToString(g_chart_id) + "_";
   
   // Enable mouse events for 60 FPS drag and drop
   ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, true);
   
   InitializeThemes();
   InitializeProfiles();
   SnapshotOriginalAppearance(g_chart_id);
   LoadSavedSettings();
   
   // Set default chart indicators
   ChartSetInteger(g_chart_id, CHART_SHOW_BID_LINE,   InpDefaultBidLine);
   ChartSetInteger(g_chart_id, CHART_SHOW_ASK_LINE,   InpDefaultAskLine);
   ChartSetInteger(g_chart_id, CHART_SHOW_PERIOD_SEP, InpDefaultPeriodSep);

   // Apply selected initial theme & style objects
   ApplyThemeUniversal(g_current_theme_idx, g_grid_state);
   AddRecentTheme(g_current_theme_idx);
   
   if(InpShowPanel)
      BuildUIPanel();
      
   // Initialize 10-second timer for Auto Day/Night Scheduling
   EventSetTimer(10);
      
   Print("AuraChart Studio v2.0 by Shayan Namayandeh initialized successfully. Theme: ", g_themes[g_current_theme_idx].name);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, false);
   DeleteAllUIObjects();
   
   if(InpDeinitAction == DEINIT_RESTORE_ORIGINAL)
   {
      RestoreOriginalAppearance(g_chart_id);
   }
   
   Print("AuraChart Studio v2.0 unloaded. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Timer function for Auto Day/Night Scheduling                     |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(!InpAutoSchedule)
      return;
      
   datetime now = InpScheduleUseLocalTime ? TimeLocal() : TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now, dt);
   int curMins = dt.hour * 60 + dt.min;
   
   // Parse Day Start
   int dayH = (int)StringToInteger(StringSubstr(InpDayStartTime, 0, 2));
   int dayM = (int)StringToInteger(StringSubstr(InpDayStartTime, 3, 2));
   int dayMins = dayH * 60 + dayM;
   
   // Parse Night Start
   int nightH = (int)StringToInteger(StringSubstr(InpNightStartTime, 0, 2));
   int nightM = (int)StringToInteger(StringSubstr(InpNightStartTime, 3, 2));
   int nightMins = nightH * 60 + nightM;
   
   bool isDay = false;
   if(dayMins < nightMins)
      isDay = (curMins >= dayMins && curMins < nightMins);
   else
      isDay = (curMins >= dayMins || curMins < nightMins);
      
   int targetTheme = isDay ? (int)InpDayTheme : (int)InpNightTheme;
   if(targetTheme != g_current_theme_idx)
   {
      SetTheme(targetTheme);
      SetStatusMessage("Auto Schedule Switch: " + (isDay ? "Day" : "Night"));
   }
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // 1. New Object Created Event: Auto-Style Drawn Object with Active Theme
   if(id == CHARTEVENT_OBJECT_CREATE && InpStyleDrawnObjects)
   {
      StyleSingleObject(g_chart_id, sparam, g_current_theme_idx);
      ChartRedraw(g_chart_id);
      return;
   }

   // 2. Mouse Move Event for Drag & Drop
   if(id == CHARTEVENT_MOUSE_MOVE && InpEnableDragging && InpShowPanel && !g_presentation_mode)
   {
      int mouseX = (int)lparam;
      int mouseY = (int)dparam;
      int mouseBtn = (int)StringToInteger(sparam);
      bool isLeftDown = ((mouseBtn & 1) != 0);
      
      if(!isLeftDown)
      {
         if(g_is_dragging)
         {
            g_is_dragging = false;
            SaveSettings();
         }
         return;
      }
      
      if(g_is_dragging)
      {
         int newX = g_drag_start_panel_x + (mouseX - g_drag_start_mouse_x);
         int newY = g_drag_start_panel_y + (mouseY - g_drag_start_mouse_y);
         
         if(newX < 5) newX = 5;
         if(newY < 5) newY = 5;
         
         if(newX != g_panel_x || newY != g_panel_y)
         {
            g_panel_x = newX;
            g_panel_y = newY;
            UpdateUIPositions();
         }
         return;
      }
      
      if(!g_compact_mode)
      {
         // Full HUD header area: X: [g_panel_x, g_panel_x + 220], Y: [g_panel_y, g_panel_y + 30]
         if(mouseX >= g_panel_x && mouseX <= (g_panel_x + 220) &&
            mouseY >= g_panel_y && mouseY <= (g_panel_y + 30))
         {
            g_is_dragging = true;
            g_drag_start_mouse_x = mouseX;
            g_drag_start_mouse_y = mouseY;
            g_drag_start_panel_x = g_panel_x;
            g_drag_start_panel_y = g_panel_y;
            return;
         }
      }
      else
      {
         // Compact Mode pill drag handle area: X: [g_panel_x, g_panel_x + 35]
         if(mouseX >= g_panel_x && mouseX <= (g_panel_x + 35) &&
            mouseY >= g_panel_y && mouseY <= (g_panel_y + 36))
         {
            g_is_dragging = true;
            g_drag_start_mouse_x = mouseX;
            g_drag_start_mouse_y = mouseY;
            g_drag_start_panel_x = g_panel_x;
            g_drag_start_panel_y = g_panel_y;
            return;
         }
      }
   }

   // 3. Button Click Event
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(StringFind(sparam, g_ui_prefix) != 0)
         return;
         
      ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
      
      // Presentation Mode Exit Button
      if(sparam == g_ui_prefix + "BTN_EXIT_PRES")
      {
         TogglePresentationMode();
         return;
      }
      
      // Tabs
      if(sparam == g_ui_prefix + "TAB_0") { g_active_tab = TAB_THEMES;   BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "TAB_1") { g_active_tab = TAB_EDITOR;   BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "TAB_2") { g_active_tab = TAB_PROFILES; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "TAB_3") { g_active_tab = TAB_SCHEDULE; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "TAB_4") { g_active_tab = TAB_SETTINGS; BuildUIPanel(); return; }
      
      // Basic Actions
      if(sparam == g_ui_prefix + "BTN_NEXT")      { NextTheme(); return; }
      if(sparam == g_ui_prefix + "BTN_PREV")      { PrevTheme(); return; }
      if(sparam == g_ui_prefix + "BTN_RANDOM")    { TriggerIntelligentRandom(); return; }
      if(sparam == g_ui_prefix + "BTN_GRID")      { ToggleGrid(); return; }
      if(sparam == g_ui_prefix + "BTN_FOCUS")     { ToggleFocusMode(); return; }
      if(sparam == g_ui_prefix + "BTN_COLLAPSE")  { g_compact_mode = true; SaveSettings(); BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "BTN_EXPAND")    { g_compact_mode = false; SaveSettings(); BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "BTN_CLOSE_HUD") { DeleteAllUIObjects(); return; }
      if(sparam == g_ui_prefix + "BTN_PILL_THM")  { NextTheme(); return; }
      
      // Favorite Bookmark toggle
      if(sparam == g_ui_prefix + "BTN_FAV")
      {
         g_themes[g_current_theme_idx].isFavorite = !g_themes[g_current_theme_idx].isFavorite;
         BuildUIPanel();
         return;
      }
      
      // Category Fast Pickers
      if(sparam == g_ui_prefix + "BTN_CAT_DARK")   { SetTheme(PickIntelligentRandomTheme(THEME_CAT_DARK)); return; }
      if(sparam == g_ui_prefix + "BTN_CAT_LIGHT")  { SetTheme(PickIntelligentRandomTheme(THEME_CAT_LIGHT)); return; }
      if(sparam == g_ui_prefix + "BTN_CAT_ACCESS") { SetTheme(PickIntelligentRandomTheme(THEME_CAT_ACCESS)); return; }
      
      // Recent Themes Buttons
      if(StringFind(sparam, g_ui_prefix + "BTN_REC_") == 0)
      {
         int rIdx = (int)StringToInteger(StringSubstr(sparam, StringLen(g_ui_prefix + "BTN_REC_")));
         SetTheme(rIdx);
         return;
      }
      
      // Editor Property Pickers
      if(sparam == g_ui_prefix + "ED_P_BG")   { g_edit_prop = PROP_BG; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_FG")   { g_edit_prop = PROP_FG; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_GRID") { g_edit_prop = PROP_GRID; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_BULL") { g_edit_prop = PROP_CANDLE_BULL; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_BEAR") { g_edit_prop = PROP_CANDLE_BEAR; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_LINE") { g_edit_prop = PROP_CHART_LINE; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_BID")  { g_edit_prop = PROP_BID; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "ED_P_ASK")  { g_edit_prop = PROP_ASK; BuildUIPanel(); return; }
      
      // Editor Quick Palette click
      if(StringFind(sparam, g_ui_prefix + "ED_QUICK_") == 0)
      {
         color palColors[12] = {
            C'15,23,42', C'18,18,18', C'46,52,64', C'14,165,233', C'16,185,129', C'244,63,94',
            C'255,255,255', C'250,249,246', C'241,245,249', C'255,214,0', C'168,85,247', C'249,115,22'
         };
         int cIdx = (int)StringToInteger(StringSubstr(sparam, StringLen(g_ui_prefix + "ED_QUICK_")));
         if(cIdx >= 0 && cIdx < 12)
         {
            color pick = palColors[cIdx];
            if(g_edit_prop == PROP_BG) g_edit_theme.bg = pick;
            else if(g_edit_prop == PROP_FG) g_edit_theme.fg = pick;
            else if(g_edit_prop == PROP_GRID) g_edit_theme.grid = pick;
            else if(g_edit_prop == PROP_CANDLE_BULL) g_edit_theme.candleBull = pick;
            else if(g_edit_prop == PROP_CANDLE_BEAR) g_edit_theme.candleBear = pick;
            else if(g_edit_prop == PROP_CHART_LINE) g_edit_theme.chartLine = pick;
            else if(g_edit_prop == PROP_BID) g_edit_theme.bid = pick;
            else if(g_edit_prop == PROP_ASK) g_edit_theme.ask = pick;
            BuildUIPanel();
         }
         return;
      }
      
      // Editor Apply Preview
      if(sparam == g_ui_prefix + "ED_BTN_APPLY")
      {
         string hexVal = ObjectGetString(0, g_ui_prefix + "ED_INPUT_HEX", OBJPROP_TEXT);
         color parsed = HexToColor(hexVal);
         if(parsed != clrNONE)
         {
            if(g_edit_prop == PROP_BG) g_edit_theme.bg = parsed;
            else if(g_edit_prop == PROP_FG) g_edit_theme.fg = parsed;
            else if(g_edit_prop == PROP_GRID) g_edit_theme.grid = parsed;
            else if(g_edit_prop == PROP_CANDLE_BULL) g_edit_theme.candleBull = parsed;
            else if(g_edit_prop == PROP_CANDLE_BEAR) g_edit_theme.candleBear = parsed;
            else if(g_edit_prop == PROP_CHART_LINE) g_edit_theme.chartLine = parsed;
            else if(g_edit_prop == PROP_BID) g_edit_theme.bid = parsed;
            else if(g_edit_prop == PROP_ASK) g_edit_theme.ask = parsed;
         }
         string edName = ObjectGetString(0, g_ui_prefix + "ED_INPUT_NAME", OBJPROP_TEXT);
         if(StringLen(edName) > 0) g_edit_theme.name = edName;
         
         // Apply preview to chart
         int slot = g_themes_count - 1;
         if(slot < TOTAL_BUILTIN_THEMES) slot = TOTAL_BUILTIN_THEMES;
         g_themes[slot] = g_edit_theme;
         if(g_themes_count <= slot) g_themes_count = slot + 1;
         SetTheme(slot);
         return;
      }
      
      // Editor Save Custom Theme
      if(sparam == g_ui_prefix + "ED_BTN_SAVE")
      {
         int slot = g_themes_count;
         if(slot >= MAX_TOTAL_THEMES) slot = MAX_TOTAL_THEMES - 1;
         else g_themes_count++;
         
         string edName = ObjectGetString(0, g_ui_prefix + "ED_INPUT_NAME", OBJPROP_TEXT);
         if(StringLen(edName) > 0) g_edit_theme.name = edName;
         g_themes[slot] = g_edit_theme;
         SetTheme(slot);
         SetStatusMessage(Tr("STATUS_SAVED") + ": " + g_edit_theme.name);
         return;
      }
      
      // Editor Export to .cts
      if(sparam == g_ui_prefix + "ED_BTN_EXPORT")
      {
         if(ExportThemeToCTS(g_themes[g_current_theme_idx]))
            SetStatusMessage(Tr("STATUS_EXP_OK"));
         else
            SetStatusMessage(Tr("STATUS_ERR_FILE"));
         return;
      }
      
      // Editor Import from .cts
      if(sparam == g_ui_prefix + "ED_BTN_IMPORT")
      {
         ThemePalette imp;
         string fname = ObjectGetString(0, g_ui_prefix + "ED_INPUT_NAME", OBJPROP_TEXT);
         if(StringLen(fname) == 0) fname = "custom.cts";
         if(ImportThemeFromCTS(fname, imp))
         {
            int slot = g_themes_count;
            if(slot >= MAX_TOTAL_THEMES) slot = MAX_TOTAL_THEMES - 1;
            else g_themes_count++;
            g_themes[slot] = imp;
            SetTheme(slot);
            SetStatusMessage(Tr("STATUS_IMP_OK"));
         }
         else
         {
            SetStatusMessage(Tr("STATUS_ERR_FILE"));
         }
         return;
      }
      
      // Profile Buttons
      if(StringFind(sparam, g_ui_prefix + "PROF_") == 0)
      {
         int pIdx = (int)StringToInteger(StringSubstr(sparam, StringLen(g_ui_prefix + "PROF_")));
         ApplyProfile(pIdx);
         return;
      }
      
      // Save current state as profile
      if(sparam == g_ui_prefix + "BTN_SAVE_PROF")
      {
         g_profiles[g_current_profile_idx].themeIdx    = g_current_theme_idx;
         g_profiles[g_current_profile_idx].showGrid    = g_grid_state;
         g_profiles[g_current_profile_idx].compactMode = g_compact_mode;
         SetStatusMessage("Saved current state to profile!");
         return;
      }
      
      // Schedule Toggle
      if(sparam == g_ui_prefix + "BTN_TOGGLE_SCH")
      {
         // Toggle visual state
         SetStatusMessage("Scheduling status changed.");
         BuildUIPanel();
         return;
      }
      
      // Target Scope Buttons
      if(sparam == g_ui_prefix + "BTN_TGT_CURR") { g_chart_target = TARGET_CURRENT_CHART; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "BTN_TGT_ALL")  { g_chart_target = TARGET_ALL_OPEN_CHARTS; BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "BTN_TGT_SYM")  { g_chart_target = TARGET_SAME_SYMBOL; BuildUIPanel(); return; }
      
      // Language Switchers
      if(sparam == g_ui_prefix + "BTN_LNG_EN") { g_current_lang = LANG_EN; SaveSettings(); BuildUIPanel(); return; }
      if(sparam == g_ui_prefix + "BTN_LNG_FA") { g_current_lang = LANG_FA; SaveSettings(); BuildUIPanel(); return; }
      
      // Reset to Initial Chart State
      if(sparam == g_ui_prefix + "BTN_RESET_INIT")
      {
         RestoreOriginalAppearance(g_chart_id);
         return;
      }
      
      // About / Info Modal
      if(sparam == g_ui_prefix + "BTN_INFO_MODAL")
      {
         ShowAuthorModal();
         return;
      }
   }

   // 4. Keyboard Shortcut Event (Suppressed when editing text)
   if(id == CHARTEVENT_KEYDOWN && InpEnableHotkeys)
   {
      string keyNext   = InpHotkeyNext;
      string keyPrev   = InpHotkeyPrev;
      string keyRnd    = InpHotkeyRandom;
      string keyGrid   = InpHotkeyGrid;
      string keyFoc    = InpHotkeyFocus;
      string keyPres   = InpHotkeyPresentation;
      string keyHUD    = InpHotkeyToggleHUD;
      
      StringToUpper(keyNext);
      StringToUpper(keyPrev);
      StringToUpper(keyRnd);
      StringToUpper(keyGrid);
      StringToUpper(keyFoc);
      StringToUpper(keyPres);
      StringToUpper(keyHUD);
      
      ushort codeNext = (ushort)StringGetCharacter(keyNext, 0);
      ushort codePrev = (ushort)StringGetCharacter(keyPrev, 0);
      ushort codeRnd  = (ushort)StringGetCharacter(keyRnd, 0);
      ushort codeGrid = (ushort)StringGetCharacter(keyGrid, 0);
      ushort codeFoc  = (ushort)StringGetCharacter(keyFoc, 0);
      ushort codePres = (ushort)StringGetCharacter(keyPres, 0);
      ushort codeHUD  = (ushort)StringGetCharacter(keyHUD, 0);
      
      if((ushort)lparam == codeNext) { NextTheme(); return; }
      if((ushort)lparam == codePrev) { PrevTheme(); return; }
      if((ushort)lparam == codeRnd)  { TriggerIntelligentRandom(); return; }
      if((ushort)lparam == codeGrid) { ToggleGrid(); return; }
      if((ushort)lparam == codeFoc)  { ToggleFocusMode(); return; }
      if((ushort)lparam == codePres) { TogglePresentationMode(); return; }
      if((ushort)lparam == codeHUD)
      {
         g_hud_visible = !g_hud_visible;
         if(g_hud_visible) BuildUIPanel();
         else DeleteAllUIObjects();
         return;
      }
   }
}
//+------------------------------------------------------------------+
