
require("config")
require("cocos.init")
require("framework.init")

require("app.GameUtils")
require("app.controllers.BuildingsManager")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:InitInstances()
	self.BuildingsManager = BuildingsManager.new()

	local manager = ccs.ArmatureDataManager:getInstance()
	manager:addArmatureFileInfo("fat_boy.ExportJson")
end

function MyApp:DestroyInstances()
	self.BuildingsManager:__delete()
	self.BuildingsManager = nil
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")

    self:InitInstances()
    
    self:enterScene("MainScene")
end

function MyApp:exit()
	self:DestroyInstances()
	self.super.exit(self)
end

return MyApp
