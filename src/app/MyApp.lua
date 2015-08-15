
require("config")
require("cocos.init")
require("framework.init")

require("app.GameUtils")
require("app.controllers.BuildingsManager")
require("app.controllers.FlyObjectManager")
require("app.controllers.BgController")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:InitInstances()
	tonumber(tostring(os.time()):reverse():sub(1,6)) 
	
	self.BuildingsManager = BuildingsManager.new()
	self.FlyObjectManager = FlyObjectManager.new()
	self.BgController = BgController.new()
end

function MyApp:DestroyInstances()
	self.BuildingsManager:__delete()
	self.BuildingsManager = nil
	self.FlyObjectManager:__delete()
	self.FlyObjectManager = nil
	self.BgController:__delete()
	self.BgController = nil
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")

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
