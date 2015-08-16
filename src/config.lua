
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
CONFIG_SCREEN_WIDTH  = 720
CONFIG_SCREEN_HEIGHT = 480

CONFIG_BASE_WIDTH = 720
CONFIG_BASE_HEIGHT = 480

CONFIG_SCREEN_ORIENTATION = "landscape"
-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

GAME_STATE = {
	LOADING = 0,
	READY = 1,
	START = 2,
	PAUSE = 3,
	END = 4,

	CUR_STATE = 0,
}

GAME_ACTION_TAG = {
	BUILDING_MOVE = 1,
}

GAME_Z_ORDER = {
	BACKGROUND = 1,
	FLY_OBJECT = 2,
	BUILDING = 3,
	HERO = 4,
	FOREGROUND = 5,
	TOUCH_LAYER = 6,
}

GAME_OBJECT_TAG = {
	CAR = 1,
	BUILDING = 2,	
	GROUND = 3,
	SKY = 4,
}

GAME_CONTACT_TEST_BIT_MASK = {
	CAR_MASK = 0xffff,
	BUILDING_MASK = 0x0001,
	GROUND_MASK = 0x0010,
	SKY_MASK = 0x0100
}

GAME_EVENT_TYPE = {
	GAME_RESTART = "restart",
}

-- 房子宽度
BUILDING_WIDTH = CONFIG_SCREEN_WIDTH / 10
HOLE_WIDTH = BUILDING_WIDTH * 1.6
-- 房子间距
BUILDING_INTERVAL = BUILDING_WIDTH + BUILDING_WIDTH / 10
BUILDING_MAX_HEIGHT = CONFIG_SCREEN_HEIGHT / 3
BUILDING_MAX_NUM = 12
--移过一屏所用的时间
BUILDING_MOVE_TIME = 5
BUILDING_CHANGE_COLOR_X = CONFIG_SCREEN_WIDTH / 3
GROUND_Y = 0

GAME_PHYSICS_GRAVITY = -500
GAME_PHYSICS_CAR_JUMP_VELOCITY = 250

STORE_KEY_HIGHEST_SCORE = "highest_score"
RES_PLIST_FILE_NAME = "images.plist"
RES_PNG_FILE_NAME = "images.png"