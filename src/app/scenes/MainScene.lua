local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self:initInstances()
	self:initBackground()
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)    
end

function MainScene:Update(dt)
	print("exe")
end

function MainScene:__delete()
	--BuildingsManager.instance:__delete()
end

function MainScene:initInstances()
	--BuildingsManager = require("app.controllers.BuildingsManager").new()
end

function MainScene:initBackground()	
	--BuildingsManager.instance:CreateRandomLayer(self)
end

function MainScene:onEnter()

end

function MainScene:onExit()
end

return MainScene
