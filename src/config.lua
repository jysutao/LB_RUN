
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = true

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 960
CONFIG_SCREEN_HEIGHT = 640

CONFIG_SCREEN_ORIENTATION = "landscape"

BUILDING_WIDTH = CONFIG_SCREEN_WIDTH / 10
BUILDING_MAX_HEIGHT = CONFIG_SCREEN_HEIGHT / 3
GROUND_Y = 10

GAME_ACTION_TAG = {
	BUILDING_MOVE = 1,
	BUILDING_BLINK = 2,
}

GAME_Z_ORDER = {
	BACKGROUND = 1,
	BUILDING = 2,
	HERO = 3,
	FOREGROUND = 4,
}

BUILDING_MAX_NUM = 15
--移过一屏所用的时间
BUILDING_MOVE_TIME = 5  

BUILDING_CHANGE_COLOR_X = CONFIG_SCREEN_WIDTH / 3

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
