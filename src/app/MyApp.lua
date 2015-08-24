
require("config")
require("cocos.init")
require("framework.init")

require("app.GameUtils")
require("app.controllers.BuildingsManager")
require("app.controllers.FlyObjectManager")
require("app.controllers.BgController")
require("app.controllers.WaveController")
require("app.controllers.ScoreController")
require("app.controllers.MusicController")
require("app.controllers.WeatherController")
require("app.controllers.TipController")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:InitInstances()
	tonumber(tostring(os.time()):reverse():sub(1,6)) 
	
	self.BuildingsManager = BuildingsManager.new()
	self.FlyObjectManager = FlyObjectManager.new()
	self.BgController = BgController.new()
	self.WaveController = WaveController.new()
	self.ScoreController = ScoreController.new()
	self.MusicController = MusicController.new()
	self.WeatherController = WeatherController.new()
	self.TipController = TipController.new()

	self.MusicController:Init()
end

function MyApp:DestroyInstances()
	if self.BuildingsManager then
		self.BuildingsManager:__delete()
		self.BuildingsManager = nil
	end
	if self.FlyObjectManager then
		self.FlyObjectManager:__delete()
		self.FlyObjectManager = nil
	end
	if self.BgController then
		self.BgController:__delete()
		self.BgController = nil
	end
	if self.WaveController then
		self.WaveController:__delete()
		self.WaveController = nil
	end
	if self.ScoreController then
		self.ScoreController:__delete()
		self.ScoreController = nil
	end
	if self.MusicController then
		self.MusicController:__delete()
		self.MusicController = nil
	end
	if self.WeatherController then
		self.WeatherController:__delete()
		self.WeatherController = nil
	end
	if self.TipController then
		self.TipController:__delete()
		self.TipController = nil
	end
end

function MyApp:run()
	cc.Director:getInstance():setAnimationInterval(1 / GAME_FPS)

    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames(RES_PLIST_FILE_NAME, RES_PNG_FILE_NAME)

    self:InitInstances()
    self:StarGame()
end

function MyApp:StarGame()
	self:enterScene("MainScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:exit()
	self:DestroyInstances()
	self.super.exit(self)
end

return MyApp
