require("app.models.Car")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self:InitGameObjects()
	
end

function MainScene:InitDesc()
    cc.ui.UILabel.new({
        UILabelType = 2, text = "黑夜给了一辆白色的小车，我将用它驶向光明", size = 48 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.top / 3)
    :addTo(self, GAME_Z_ORDER.FOREGROUND)  

    local touch_txt = cc.ui.UILabel.new({
        UILabelType = 2, text = "点击屏幕开始", size = 64 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.top * 2 / 3)
    :addTo(self, GAME_Z_ORDER.FOREGROUND)  
    local bigger = cc.ScaleBy:create(0.5, 1.2)
    touch_txt:runAction(cc.RepeatForever:create(cc.Sequence:create(bigger, bigger:reverse())))

end

function MainScene:InitScore(score)
	self.score = score or 0
	cc.ui.UILabel.new({
            UILabelType = 2, text = self.score, size = 64})
        :align(display.RIGHT_TOP, display.width, display.top)
        :addTo(self)
end

function MainScene:Update(dt)

end

function MainScene:InitGameObjects()	
	-- 添加房子
	BuildingsManager.instance:CreateRandomLayer(self)

	-- 添加英雄
	self.car = Car.new(display.width / 4, GROUND_Y + BUILDING_MAX_HEIGHT)
	self:addChild(self.car, GAME_Z_ORDER.HERO)

	self:InitDesc()

	self:InitScore()
end

function MainScene:onEnter()

end

function MainScene:onExit()
end

return MainScene
