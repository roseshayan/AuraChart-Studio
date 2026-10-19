//+------------------------------------------------------------------+
//|                                     ChartThemeStudio_MT4.mq4     |
//|                          Copyright 2026, Shayan Namayandeh       |
//|                                   https://github.com/roseshayan  |
//+------------------------------------------------------------------+
#property copyright   "Shayan Namayandeh (SudoShayanNA)"
#property link        "https://github.com/roseshayan/AuraChart-Studio"
#property version     "1.10"
#property description "AuraChart Studio (ChartTheme Studio Pro) - Visual & Theme Manager"
#property description "Author: Shayan Namayandeh | Telegram: @SudoShayanNA | Email: namayandeshayan@gmail.com"
#property description "NOTE: 100% Non-Trading Utility. Does NOT open, close, or affect your trades."
#property icon        "icon.ico"
#property strict

//+------------------------------------------------------------------+
//| Enums and Constants                                              |
//+------------------------------------------------------------------+
enum ENUM_THEME_CATEGORY
{
   THEME_CAT_DARK,   // Dark Theme
   THEME_CAT_LIGHT   // Light Theme
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
   THEME_MINIMAL_LIGHT        // Minimal Light (High contrast monochrome)
};

enum ENUM_DEINIT_ACTION
{
   DEINIT_KEEP_CURRENT_THEME = 0, // Keep current theme
   DEINIT_RESTORE_ORIGINAL   = 1  // Restore original chart appearance
};

//+------------------------------------------------------------------+
//| Palette Definition Structure                                     |
//+------------------------------------------------------------------+
struct ThemePalette
{
   string               name;          // Display name
   ENUM_THEME_CATEGORY  category;      // Dark or Light
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
   color                stopLevels;    // Trade & Stop levels
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
   color stopLevels;
   bool  showGrid;
   bool  showPeriodSep;
   bool  showBid;
   bool  showAsk;
   bool  isValid;
};

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
//--- [ 1. Theme Selection & Core Settings ]
input ENUM_PRESET_THEME InpInitialTheme          = THEME_MIDNIGHT_NAVY;  // Initial Theme
input bool              InpRestoreSavedTheme     = true;                 // Restore Last Saved Theme
input bool              InpAutoSaveSettings      = true;                 // Auto-Save Theme & Grid Choice
input bool              InpApplyToAllOpenCharts  = false;                // Apply Theme to All Open Charts
input bool              InpStyleDrawnObjects     = true;                 // Auto-Apply Theme Colors to Drawn Objects

//--- [ 2. UI Panel Appearance & Dragging ]
input bool              InpShowPanel             = true;                 // Show On-Chart HUD Panel
input bool              InpStartCompact          = false;                // Start in Compact (Mini) Mode
input bool              InpEnableDragging        = true;                 // Enable Drag & Drop for Panel
input ENUM_BASE_CORNER  InpPanelCorner           = CORNER_LEFT_UPPER;    // Default Placement Corner
input int               InpPanelOffsetX          = 20;                   // Initial Panel X (pixels)
input int               InpPanelOffsetY          = 30;                   // Initial Panel Y (pixels)
input string            InpFontName              = "Segoe UI";           // UI Font Family

//--- [ 3. Keyboard Shortcuts ]
input bool              InpEnableHotkeys         = true;                 // Enable Keyboard Shortcuts
input string            InpHotkeyNext            = "T";                  // Key: Next Theme
input string            InpHotkeyPrev            = "Y";                  // Key: Previous Theme
input string            InpHotkeyRandom          = "R";                  // Key: Intelligent Random Theme
input string            InpHotkeyGrid            = "G";                  // Key: Toggle Grid

//--- [ 4. Chart Elements Default State ]
input bool              InpDefaultGrid           = false;                // Default Grid Visible
input bool              InpDefaultBidLine        = true;                 // Default Show Bid Line
input bool              InpDefaultAskLine        = false;                // Default Show Ask Line
input bool              InpDefaultPeriodSep      = false;                // Default Show Period Separators

//--- [ 5. Deinitialization Behavior ]
input ENUM_DEINIT_ACTION InpDeinitAction         = DEINIT_RESTORE_ORIGINAL; // On EA Removal

//+------------------------------------------------------------------+
//| Global Variables & State                                         |
//+------------------------------------------------------------------+
#define TOTAL_THEMES 16

ThemePalette           g_themes[TOTAL_THEMES];
ChartAppearanceBackup  g_backup;
int                    g_current_theme_idx   = 0;
bool                   g_grid_state          = false;
bool                   g_compact_mode        = false;
bool                   g_palette_menu_open   = false;
string                 g_ui_prefix           = "";
long                   g_chart_id            = 0;

// Drag & drop state
int                    g_panel_x             = 20;
int                    g_panel_y             = 30;
bool                   g_is_dragging         = false;
int                    g_drag_start_mouse_x  = 0;
int                    g_drag_start_mouse_y  = 0;
int                    g_drag_start_panel_x  = 0;
int                    g_drag_start_panel_y  = 0;

// Forward declaration
void BuildUIPanel();
void UpdateUIPositions();
void BuildPaletteMenu();
void ClosePaletteMenu();
void StyleAllDrawnObjects(const long chart_id, const int theme_idx);
void StyleSingleObject(const long chart_id, const string obj_name, const int theme_idx);

//+------------------------------------------------------------------+
//| Palette Initialization Engine                                    |
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
   g_themes[0].stopLevels  = C'249,115,22';    // #F97316

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
   g_themes[1].stopLevels  = C'255,145,0';

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
   g_themes[2].stopLevels  = C'208,135,112';   // #D08770

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
   g_themes[3].volumes     = C'117,113,94';    // #75715E
   g_themes[3].bid         = C'102,217,239';
   g_themes[3].ask         = C'249,38,114';
   g_themes[3].stopLevels  = C'174,129,255';   // #AE81FF

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
   g_themes[4].stopLevels  = C'247,127,0';

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
   g_themes[5].stopLevels  = C'230,126,34';    // #E67E22

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
   g_themes[6].stopLevels  = C'255,159,10';

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
   g_themes[7].volumes     = C'88,48,65';
   g_themes[7].bid         = C'52,211,153';
   g_themes[7].ask         = C'251,113,133';
   g_themes[7].stopLevels  = C'248,113,113';

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
   g_themes[8].volumes     = C'148,163,184';   // #94A3B8
   g_themes[8].bid         = C'16,185,129';
   g_themes[8].ask         = C'239,68,68';
   g_themes[8].stopLevels  = C'234,88,12';     // #EA580C

   // 9: Ivory Pro (Light)
   g_themes[9].name        = "Ivory Pro";
   g_themes[9].category    = THEME_CAT_LIGHT;
   g_themes[9].bg          = C'250,249,246';   // #FAF9F6
   g_themes[9].fg          = C'44,53,64';      // #2C3540
   g_themes[9].grid        = C'228,225,218';   // #E4E1DA
   g_themes[9].barUp       = C'13,148,136';    // #0D9488
   g_themes[9].barDown     = C'225,29,72';     // #E11D48
   g_themes[9].candleBull  = C'15,118,110';
   g_themes[9].candleBear  = C'190,18,60';
   g_themes[9].chartLine   = C'13,148,136';
   g_themes[9].volumes     = C'168,162,158';   // #A8A29E
   g_themes[9].bid         = C'13,148,136';
   g_themes[9].ask         = C'225,29,72';
   g_themes[9].stopLevels  = C'217,119,6';

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
   g_themes[10].stopLevels = C'123,31,162';

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
   g_themes[11].stopLevels = C'234,88,12';

   // 12: Morning Sky (Light)
   g_themes[12].name       = "Morning Sky";
   g_themes[12].category   = THEME_CAT_LIGHT;
   g_themes[12].bg         = C'240,248,255';   // #F0F8FF
   g_themes[12].fg         = C'27,38,59';      // #1B263B
   g_themes[12].grid       = C'218,230,242';   // #DAE6F2
   g_themes[12].barUp      = C'2,132,199';     // #0284C7
   g_themes[12].barDown    = C'234,88,12';     // #EA580C
   g_themes[12].candleBull = C'14,165,233';    // #0EA5E9
   g_themes[12].candleBear = C'249,115,22';    // #F97316
   g_themes[12].chartLine  = C'2,132,199';
   g_themes[12].volumes    = C'141,166,193';
   g_themes[12].bid        = C'2,132,199';
   g_themes[12].ask        = C'234,88,12';
   g_themes[12].stopLevels = C'220,38,38';

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
   g_themes[13].stopLevels = C'210,105,30';

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
   g_themes[14].stopLevels = C'136,14,79';

   // 15: Minimal Light (Light)
   g_themes[15].name       = "Minimal Light";
   g_themes[15].category   = THEME_CAT_LIGHT;
   g_themes[15].bg          = C'248,249,250';   // #F8F9FA
   g_themes[15].fg          = C'33,37,41';      // #212529
   g_themes[15].grid        = C'233,236,239';   // #E9ECEF
   g_themes[15].barUp       = C'13,110,253';    // #0D6EFD
   g_themes[15].barDown     = C'108,117,125';   // #6C757D
   g_themes[15].candleBull  = C'13,110,253';
   g_themes[15].candleBear  = C'108,117,125';
   g_themes[15].chartLine   = C'13,110,253';
   g_themes[15].volumes     = C'173,181,189';
   g_themes[15].bid         = C'13,110,253';
   g_themes[15].ask         = C'220,53,69';
   g_themes[15].stopLevels  = C'253,126,20';
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
   g_backup.stopLevels = (color)ChartGetInteger(chart_id, CHART_COLOR_STOP_LEVEL);
   
   g_backup.showGrid      = (bool)ChartGetInteger(chart_id, CHART_SHOW_GRID);
   g_backup.showPeriodSep = (bool)ChartGetInteger(chart_id, CHART_SHOW_PERIOD_SEP);
   g_backup.showBid       = (bool)ChartGetInteger(chart_id, CHART_SHOW_BID_LINE);
   g_backup.showAsk       = (bool)ChartGetInteger(chart_id, CHART_SHOW_ASK_LINE);
   
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
   ChartSetInteger(chart_id, CHART_COLOR_STOP_LEVEL,  g_backup.stopLevels);
   
   ChartSetInteger(chart_id, CHART_SHOW_GRID,         g_backup.showGrid);
   ChartSetInteger(chart_id, CHART_SHOW_PERIOD_SEP,   g_backup.showPeriodSep);
   ChartSetInteger(chart_id, CHART_SHOW_BID_LINE,     g_backup.showBid);
   ChartSetInteger(chart_id, CHART_SHOW_ASK_LINE,     g_backup.showAsk);
   
   ChartRedraw(chart_id);
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
      
   int total = ObjectsTotal(chart_id, -1, -1);
   for(int i = 0; i < total; i++)
   {
      string name = ObjectName(chart_id, i, -1, -1);
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
   if(theme_idx < 0 || theme_idx >= TOTAL_THEMES)
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
   ChartSetInteger(chart_id, CHART_COLOR_STOP_LEVEL,  t.stopLevels);
   
   ChartSetInteger(chart_id, CHART_SHOW_GRID,         set_grid);
   
   StyleAllDrawnObjects(chart_id, theme_idx);
   
   ChartRedraw(chart_id);
}

void ApplyThemeUniversal(const int theme_idx, const bool set_grid)
{
   if(InpApplyToAllOpenCharts)
   {
      long cid = ChartFirst();
      while(cid >= 0)
      {
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

void SaveSettings()
{
   if(!InpAutoSaveSettings)
      return;
      
   GlobalVariableSet(GetGVThemeKey(), (double)g_current_theme_idx);
   GlobalVariableSet(GetGVGridKey(), g_grid_state ? 1.0 : 0.0);
   GlobalVariableSet(GetGVCompactKey(), g_compact_mode ? 1.0 : 0.0);
   GlobalVariableSet(GetGVPXKey(), (double)g_panel_x);
   GlobalVariableSet(GetGVPYKey(), (double)g_panel_y);
}

void LoadSavedSettings()
{
   g_current_theme_idx = (int)InpInitialTheme;
   g_grid_state        = InpDefaultGrid;
   g_compact_mode      = InpStartCompact;
   g_panel_x           = InpPanelOffsetX;
   g_panel_y           = InpPanelOffsetY;
   
   if(InpRestoreSavedTheme)
   {
      string kTheme = GetGVThemeKey();
      if(GlobalVariableCheck(kTheme))
      {
         int saved = (int)GlobalVariableGet(kTheme);
         if(saved >= 0 && saved < TOTAL_THEMES)
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
   }
}

//+------------------------------------------------------------------+
//| Intelligent Random Theme Engine                                  |
//+------------------------------------------------------------------+
int PickIntelligentRandomTheme(const ENUM_THEME_CATEGORY filter_cat = (ENUM_THEME_CATEGORY)-1)
{
   MathSrand((uint)GetTickCount());
   int candidates[];
   ArrayResize(candidates, 0);
   
   for(int i = 0; i < TOTAL_THEMES; i++)
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
      return (g_current_theme_idx + 1) % TOTAL_THEMES;
      
   int picked = MathRand() % ArraySize(candidates);
   return candidates[picked];
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
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, zorder);
   return true;
}

bool CreateLabel(const string name, const string text, const int x, const int y,
                 const color txt_col, const int font_size, const bool bold,
                 const ENUM_BASE_CORNER corner, const int zorder = 20)
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
   ObjectSetInteger(0, name, OBJPROP_ZORDER, zorder);
   return true;
}

//+------------------------------------------------------------------+
//| UI Engine: Build Full HUD Panel                                  |
//+------------------------------------------------------------------+
void DeleteAllUIObjects()
{
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i, -1, -1);
      if(StringFind(name, g_ui_prefix) == 0)
         ObjectDelete(0, name);
   }
   ChartRedraw(0);
}

void BuildUIPanel()
{
   DeleteAllUIObjects();
   
   if(!InpShowPanel)
      return;
      
   const int baseX = g_panel_x;
   const int baseY = g_panel_y;
   const ENUM_BASE_CORNER c = InpPanelCorner;
   
   // HUD Colors
   color hudBg     = C'22,27,34';
   color hudBorder = C'48,54,61';
   color hudTxt    = C'230,237,243';
   color btnBg     = C'33,38,45';
   color accentCol = C'88,166,255';
   color greenCol  = C'46,160,67';
   color redCol    = C'248,81,73';

   if(g_compact_mode)
   {
      // Compact Floating Pill Mode (width: 320, height: 34)
      CreateRectLabel(g_ui_prefix + "BG", baseX, baseY, 320, 34, hudBg, hudBorder, c);
      
      // Expand Button
      CreateButton(g_ui_prefix + "BTN_EXPAND", "+", baseX + 5, baseY + 5, 24, 24, btnBg, accentCol, hudBorder, 10, c);
      
      // Drag Handle
      CreateLabel(g_ui_prefix + "DRAG_HINT", "::", baseX + 32, baseY + 9, C'139,148,158', 8, true, c);
      
      // Theme Indicator Button
      string title = "[" + IntegerToString(g_current_theme_idx + 1) + "/" + IntegerToString(TOTAL_THEMES) + "] " + g_themes[g_current_theme_idx].name;
      CreateButton(g_ui_prefix + "BTN_COMPACT_THM", title, baseX + 45, baseY + 5, 135, 24, hudBg, hudTxt, hudBorder, 8, c);
      
      // Prev / Next
      CreateButton(g_ui_prefix + "BTN_PREV", "<", baseX + 184, baseY + 5, 24, 24, btnBg, hudTxt, hudBorder, 9, c);
      CreateButton(g_ui_prefix + "BTN_NEXT", ">", baseX + 211, baseY + 5, 24, 24, btnBg, hudTxt, hudBorder, 9, c);
      
      // Rnd
      CreateButton(g_ui_prefix + "BTN_RND", "Rnd", baseX + 238, baseY + 5, 36, 24, btnBg, accentCol, hudBorder, 8, c);
      
      // Grid
      string gridTxt = g_grid_state ? "G:On" : "G:Off";
      color gridCol = g_grid_state ? greenCol : hudBorder;
      CreateButton(g_ui_prefix + "BTN_GRID", gridTxt, baseX + 277, baseY + 5, 38, 24, btnBg, gridCol, hudBorder, 8, c);
      
      ChartRedraw(0);
      return;
   }

   // Full Expanded Panel (width: 254, height: 212)
   const int panelW = 254;
   const int panelH = 212;
   CreateRectLabel(g_ui_prefix + "BG", baseX, baseY, panelW, panelH, hudBg, hudBorder, c);
   
   // Header Drag Bar
   CreateRectLabel(g_ui_prefix + "HDR", baseX, baseY, panelW, 28, C'16,20,24', hudBorder, c);
   CreateLabel(g_ui_prefix + "LBL_DRAG_DOTS", ":::", baseX + 8, baseY + 6, C'139,148,158', 8, true, c);
   CreateLabel(g_ui_prefix + "LBL_TITLE", "ChartTheme Studio", baseX + 26, baseY + 6, accentCol, 9, true, c);
   
   // Author badge / info button
   CreateButton(g_ui_prefix + "BTN_INFO", "i", baseX + panelW - 44, baseY + 5, 18, 18, btnBg, C'139,148,158', hudBorder, 7, c);
   
   // Compact collapse button
   CreateButton(g_ui_prefix + "BTN_COLLAPSE", "_", baseX + panelW - 22, baseY + 5, 18, 18, btnBg, hudTxt, hudBorder, 8, c);

   // Active Theme Display Card
   CreateRectLabel(g_ui_prefix + "CARD", baseX + 10, baseY + 35, panelW - 20, 38, C'28,33,40', hudBorder, c);
   
   string categoryBadge = (g_themes[g_current_theme_idx].category == THEME_CAT_DARK) ? "[Dark]" : "[Light]";
   string themeDisplay = IntegerToString(g_current_theme_idx + 1) + ". " + g_themes[g_current_theme_idx].name;
   CreateLabel(g_ui_prefix + "LBL_THM_NAME", themeDisplay, baseX + 18, baseY + 41, hudTxt, 9, true, c);
   CreateLabel(g_ui_prefix + "LBL_THM_TYPE", categoryBadge, baseX + 18, baseY + 56, accentCol, 7, false, c);

   // Color Swatches
   CreateRectLabel(g_ui_prefix + "SWATCH_BULL", baseX + panelW - 48, baseY + 44, 14, 18, g_themes[g_current_theme_idx].candleBull, hudBorder, c);
   CreateRectLabel(g_ui_prefix + "SWATCH_BEAR", baseX + panelW - 30, baseY + 44, 14, 18, g_themes[g_current_theme_idx].candleBear, hudBorder, c);

   // Row 1: Nav Buttons (Y: 80)
   CreateButton(g_ui_prefix + "BTN_PREV", "< Prev", baseX + 10, baseY + 80, 72, 26, btnBg, hudTxt, hudBorder, 8, c);
   CreateButton(g_ui_prefix + "BTN_NEXT", "Next >", baseX + 87, baseY + 80, 72, 26, btnBg, hudTxt, hudBorder, 8, c);
   CreateButton(g_ui_prefix + "BTN_RND", "Random", baseX + 164, baseY + 80, 80, 26, btnBg, accentCol, hudBorder, 8, c);

   // Row 2: Category Quick Jumps & Palette Menu (Y: 112)
   CreateButton(g_ui_prefix + "BTN_DARK", "Dark (8)", baseX + 10, baseY + 112, 68, 24, btnBg, C'163,190,140', hudBorder, 8, c);
   CreateButton(g_ui_prefix + "BTN_LIGHT", "Light (8)", baseX + 82, baseY + 112, 68, 24, btnBg, C'235,203,139', hudBorder, 8, c);
   CreateButton(g_ui_prefix + "BTN_PALETTE", "Palette...", baseX + 154, baseY + 112, 90, 24, btnBg, hudTxt, hudBorder, 8, c);

   // Row 3: Utility Buttons (Y: 142)
   string gridCaption = g_grid_state ? "Grid: ON" : "Grid: OFF";
   color gridColorState = g_grid_state ? greenCol : hudTxt;
   CreateButton(g_ui_prefix + "BTN_GRID", gridCaption, baseX + 10, baseY + 142, 72, 24, btnBg, gridColorState, hudBorder, 8, c);
   CreateButton(g_ui_prefix + "BTN_RESET", "Reset Init", baseX + 87, baseY + 142, 72, 24, btnBg, redCol, hudBorder, 8, c);
   
   string scopeTxt = InpApplyToAllOpenCharts ? "All Charts" : "This Chart";
   CreateButton(g_ui_prefix + "BTN_SCOPE", scopeTxt, baseX + 164, baseY + 142, 80, 24, C'28,33,40', C'139,148,158', hudBorder, 7, c);

   // Footer: Author & Hotkey info (Y: 172 & 190)
   CreateLabel(g_ui_prefix + "LBL_FOOTER", "Hotkeys: T/Y/R/G  v1.10", baseX + 12, baseY + 172, C'110,118,129', 7, false, c);
   CreateLabel(g_ui_prefix + "LBL_AUTHOR", "By: Shayan Namayandeh (SudoShayanNA)", baseX + 12, baseY + 189, accentCol, 7, false, c);

   // If Palette Menu was opened, overlay the list
   if(g_palette_menu_open)
      BuildPaletteMenu();

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| UI Engine: Build Palette Picker Menu                             |
//+------------------------------------------------------------------+
void BuildPaletteMenu()
{
   const int baseX = g_panel_x + 260;
   const int baseY = g_panel_y;
   const ENUM_BASE_CORNER c = InpPanelCorner;
   const int menuW = 280;
   const int menuH = 225;
   
   color hudBg     = C'22,27,34';
   color hudBorder = C'48,54,61';
   color hudTxt    = C'230,237,243';
   color btnBg     = C'33,38,45';
   color accentCol = C'88,166,255';
   
   CreateRectLabel(g_ui_prefix + "MNU_BG", baseX, baseY, menuW, menuH, hudBg, hudBorder, c);
   CreateRectLabel(g_ui_prefix + "MNU_HDR", baseX, baseY, menuW, 26, C'16,20,24', hudBorder, c);
   CreateLabel(g_ui_prefix + "MNU_LBL_TITLE", "Select Theme Palette", baseX + 10, baseY + 5, accentCol, 8, true, c);
   CreateButton(g_ui_prefix + "MNU_BTN_CLOSE", "X", baseX + menuW - 22, baseY + 4, 18, 18, btnBg, hudTxt, hudBorder, 8, c);

   CreateLabel(g_ui_prefix + "MNU_LBL_DARK", "-- Dark Themes --", baseX + 15, baseY + 30, C'163,190,140', 7, true, c);
   CreateLabel(g_ui_prefix + "MNU_LBL_LIGHT", "-- Light Themes --", baseX + 148, baseY + 30, C'235,203,139', 7, true, c);

   // 8 Dark Themes (Left Column)
   for(int i = 0; i < 8; i++)
   {
      int itemY = baseY + 46 + (i * 21);
      string bName = g_ui_prefix + "MNU_THM_" + IntegerToString(i);
      color tCol = (i == g_current_theme_idx) ? accentCol : hudTxt;
      color bCol = (i == g_current_theme_idx) ? C'45,55,72' : btnBg;
      string label = IntegerToString(i + 1) + ". " + g_themes[i].name;
      CreateButton(bName, label, baseX + 10, itemY, 126, 19, bCol, tCol, hudBorder, 7, c, 30);
   }

   // 8 Light Themes (Right Column)
   for(int j = 8; j < 16; j++)
   {
      int itemY = baseY + 46 + ((j - 8) * 21);
      string bName = g_ui_prefix + "MNU_THM_" + IntegerToString(j);
      color tCol = (j == g_current_theme_idx) ? accentCol : hudTxt;
      color bCol = (j == g_current_theme_idx) ? C'45,55,72' : btnBg;
      string label = IntegerToString(j + 1) + ". " + g_themes[j].name;
      CreateButton(bName, label, baseX + 144, itemY, 126, 19, bCol, tCol, hudBorder, 7, c, 30);
   }
}

void ClosePaletteMenu()
{
   g_palette_menu_open = false;
   for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i, -1, -1);
      if(StringFind(name, g_ui_prefix + "MNU_") == 0)
         ObjectDelete(0, name);
   }
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Fast Smooth Drag & Drop Position Updater                         |
//+------------------------------------------------------------------+
void UpdateUIPositions()
{
   BuildUIPanel();
}

//+------------------------------------------------------------------+
//| Theme Navigation Functions                                       |
//+------------------------------------------------------------------+
void SetTheme(const int new_idx)
{
   if(new_idx < 0 || new_idx >= TOTAL_THEMES)
      return;
      
   g_current_theme_idx = new_idx;
   ApplyThemeUniversal(g_current_theme_idx, g_grid_state);
   SaveSettings();
   BuildUIPanel();
}

void NextTheme()
{
   SetTheme((g_current_theme_idx + 1) % TOTAL_THEMES);
}

void PrevTheme()
{
   SetTheme((g_current_theme_idx - 1 + TOTAL_THEMES) % TOTAL_THEMES);
}

void ToggleGrid()
{
   g_grid_state = !g_grid_state;
   ChartSetInteger(g_chart_id, CHART_SHOW_GRID, g_grid_state);
   if(InpApplyToAllOpenCharts)
   {
      long cid = ChartFirst();
      while(cid >= 0)
      {
         ChartSetInteger(cid, CHART_SHOW_GRID, g_grid_state);
         ChartRedraw(cid);
         cid = ChartNext(cid);
      }
   }
   else
   {
      ChartRedraw(g_chart_id);
   }
   SaveSettings();
   BuildUIPanel();
}

void QuickCategorySelect(const ENUM_THEME_CATEGORY cat)
{
   int target = PickIntelligentRandomTheme(cat);
   SetTheme(target);
}

void TriggerIntelligentRandom()
{
   int target = PickIntelligentRandomTheme();
   SetTheme(target);
}

void ResetToInitialChartState()
{
   if(g_backup.isValid)
   {
      RestoreOriginalAppearance(g_chart_id);
      g_grid_state = g_backup.showGrid;
      BuildUIPanel();
   }
}

void ShowAuthorModal()
{
   string msg = "AuraChart Studio v1.10 (ChartTheme Studio Pro)\n"
              + "====================================\n"
              + "Author: Shayan Namayandeh (SudoShayanNA)\n"
              + "Telegram: @SudoShayanNA\n"
              + "Email: namayandeshayan@gmail.com\n"
              + "GitHub: https://github.com/roseshayan/AuraChart-Studio\n"
              + "====================================\n"
              + "IMPORTANT NOTICE:\n"
              + "This tool is 100% NON-TRADING.\n"
              + "It does NOT open, close, or manage any orders.\n"
              + "It has NO effect on your trades or trading accounts.";
   MessageBox(msg, "About AuraChart Studio", MB_OK | MB_ICONINFORMATION);
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   g_chart_id  = ChartID();
   g_ui_prefix = "CTS_" + IntegerToString(g_chart_id) + "_";
   
   // Enable mouse events for drag and drop
   ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, true);
   
   InitializeThemes();
   SnapshotOriginalAppearance(g_chart_id);
   LoadSavedSettings();
   
   // Set default chart indicators
   ChartSetInteger(g_chart_id, CHART_SHOW_BID_LINE,   InpDefaultBidLine);
   ChartSetInteger(g_chart_id, CHART_SHOW_ASK_LINE,   InpDefaultAskLine);
   ChartSetInteger(g_chart_id, CHART_SHOW_PERIOD_SEP, InpDefaultPeriodSep);

   // Apply selected initial theme & style objects
   ApplyThemeUniversal(g_current_theme_idx, g_grid_state);
   
   if(InpShowPanel)
      BuildUIPanel();
      
   Print("ChartThemeStudio MT4 v1.10 by Shayan Namayandeh initialized successfully. Theme: ", g_themes[g_current_theme_idx].name);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ChartSetInteger(g_chart_id, CHART_EVENT_MOUSE_MOVE, false);
   DeleteAllUIObjects();
   
   if(InpDeinitAction == DEINIT_RESTORE_ORIGINAL)
   {
      RestoreOriginalAppearance(g_chart_id);
   }
   
   Print("ChartThemeStudio MT4 unloaded. Reason: ", reason);
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
   if(id == CHARTEVENT_MOUSE_MOVE && InpEnableDragging && InpShowPanel)
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
      
      // If left button is down and we are already dragging
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
      
      // If not dragging yet, check if mouse down started inside header drag bar
      if(!g_compact_mode)
      {
         // Full HUD header area: X: [g_panel_x, g_panel_x + 200], Y: [g_panel_y, g_panel_y + 28]
         if(mouseX >= g_panel_x && mouseX <= (g_panel_x + 200) &&
            mouseY >= g_panel_y && mouseY <= (g_panel_y + 28))
         {
            g_is_dragging = true;
            g_drag_start_mouse_x = mouseX;
            g_drag_start_mouse_y = mouseY;
            g_drag_start_panel_x = g_panel_x;
            g_drag_start_panel_y = g_panel_y;
            if(g_palette_menu_open)
               ClosePaletteMenu();
            return;
         }
      }
      else
      {
         // Compact Mode pill drag handle area: X: [g_panel_x, g_panel_x + 40]
         if(mouseX >= g_panel_x && mouseX <= (g_panel_x + 40) &&
            mouseY >= g_panel_y && mouseY <= (g_panel_y + 34))
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
      
      if(sparam == g_ui_prefix + "BTN_NEXT")
      {
         NextTheme();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_PREV")
      {
         PrevTheme();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_RND")
      {
         TriggerIntelligentRandom();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_GRID")
      {
         ToggleGrid();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_DARK")
      {
         QuickCategorySelect(THEME_CAT_DARK);
         return;
      }
      if(sparam == g_ui_prefix + "BTN_LIGHT")
      {
         QuickCategorySelect(THEME_CAT_LIGHT);
         return;
      }
      if(sparam == g_ui_prefix + "BTN_COLLAPSE")
      {
         g_compact_mode = true;
         g_palette_menu_open = false;
         SaveSettings();
         BuildUIPanel();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_EXPAND")
      {
         g_compact_mode = false;
         SaveSettings();
         BuildUIPanel();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_COMPACT_THM")
      {
         NextTheme();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_PALETTE")
      {
         g_palette_menu_open = !g_palette_menu_open;
         if(g_palette_menu_open)
            BuildPaletteMenu();
         else
            ClosePaletteMenu();
         return;
      }
      if(sparam == g_ui_prefix + "MNU_BTN_CLOSE")
      {
         ClosePaletteMenu();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_RESET")
      {
         ResetToInitialChartState();
         return;
      }
      if(sparam == g_ui_prefix + "BTN_INFO")
      {
         ShowAuthorModal();
         return;
      }
      
      // Palette menu selection
      if(StringFind(sparam, g_ui_prefix + "MNU_THM_") == 0)
      {
         string sub = StringSubstr(sparam, StringLen(g_ui_prefix + "MNU_THM_"));
         int pickedIdx = (int)StringToInteger(sub);
         if(pickedIdx >= 0 && pickedIdx < TOTAL_THEMES)
         {
            SetTheme(pickedIdx);
            ClosePaletteMenu();
         }
         return;
      }
   }

   // 4. Keyboard Shortcut Event
   if(id == CHARTEVENT_KEYDOWN && InpEnableHotkeys)
   {
      string keyNext   = InpHotkeyNext;
      string keyPrev   = InpHotkeyPrev;
      string keyRnd    = InpHotkeyRandom;
      string keyGrid   = InpHotkeyGrid;
      
      StringToUpper(keyNext);
      StringToUpper(keyPrev);
      StringToUpper(keyRnd);
      StringToUpper(keyGrid);
      
      ushort codeNext = (ushort)StringGetCharacter(keyNext, 0);
      ushort codePrev = (ushort)StringGetCharacter(keyPrev, 0);
      ushort codeRnd  = (ushort)StringGetCharacter(keyRnd, 0);
      ushort codeGrid = (ushort)StringGetCharacter(keyGrid, 0);
      
      if((ushort)lparam == codeNext)
      {
         NextTheme();
         return;
      }
      if((ushort)lparam == codePrev)
      {
         PrevTheme();
         return;
      }
      if((ushort)lparam == codeRnd)
      {
         TriggerIntelligentRandom();
         return;
      }
      if((ushort)lparam == codeGrid)
      {
         ToggleGrid();
         return;
      }
   }
}
//+------------------------------------------------------------------+
