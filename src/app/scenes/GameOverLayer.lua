local rect_width = display.width / 3
local rect_height = display.height / 2

local btn_width = rect_width / 3
local btn_height = rect_height / 5

local replay_btn_cx = display.cx + rect_width / 4
local replay_btn_cy = display.cy - rect_height / 4 

local return_btn_cx = display.cx - rect_width / 4
local return_btn_cy = display.cy - rect_height / 4 

local GameOverLayer = class("GameOverLayer", function()
    return display.newLayer()
end)

function GameOverLayer:ctor(value , max_value)
	self.value = value 
	self.max_value = max_value

    local bg = display.newRect(cc.rect(display.cx - rect_width / 2, display.cy - rect_height / 2, rect_width, rect_height), 
        {fillColor = cc.c4f(1,1,1,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 5})
    self:addChild(bg)

    cc.ui.UILabel.new({
        UILabelType = 2, text = string.format("最高分:%d", self.max_value), size = 30 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.cy + 100)
    :addTo(self)

    cc.ui.UILabel.new({
        UILabelType = 2, text = string.format("得分:%d", self.value), size = 50 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.cy + 40)
    :addTo(self)

    -- "重玩按钮"
    self.replay_btn = display.newRect(cc.rect(replay_btn_cx - btn_width / 2, replay_btn_cy - btn_height / 2, btn_width, btn_height), 
        {fillColor = cc.c4f(1,1,1,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 3})
    self:addChild(self.replay_btn)

    cc.ui.UILabel.new({
        UILabelType = 2, text = "重玩", size = 24 , color = cc.c3b(0, 0, 0) })
    :align(display.CENTER, replay_btn_cx, replay_btn_cy)
    :addTo(self)

    -- "返回按钮“
    self.return_btn = display.newRect(cc.rect(return_btn_cx - btn_width / 2, return_btn_cy - btn_height / 2, btn_width, btn_height), 
        {fillColor = cc.c4f(1,1,1,1), borderColor = cc.c4f(0,1,0,1), borderWidth = 3})
    self:addChild(self.return_btn)

    cc.ui.UILabel.new({
        UILabelType = 2, text = "返回", size = 24 , color = cc.c3b(0, 0, 0) })
    :align(display.CENTER, return_btn_cx, return_btn_cy)
    :addTo(self)
end

function GameOverLayer:onTouch(event, x, y)
    local isClickBtn = function (x, y, btn_cx, btn_cy, btn_width, btn_height)
        if x >= btn_cx - btn_width / 2 and x <= btn_cx + btn_width / 2 and
            y >= btn_cy - btn_height / 2 and y <= btn_cy + btn_height / 2 then
            return true
        end
        return false
    end

    if event == "began" then
        if isClickBtn(x, y, replay_btn_cx, replay_btn_cy, btn_width, btn_height) then   -- 重玩
            local new_scene = require("app.scenes.MainScene").new()
            new_scene:UpdateState(GAME_STATE.START)
            cc.Director:getInstance():replaceScene(new_scene)
        elseif isClickBtn(x, y, return_btn_cx, return_btn_cy, btn_width, btn_height) then -- 返回
            local new_scene = require("app.scenes.MainScene").new()
            cc.Director:getInstance():replaceScene(new_scene)
        end
    end
end

return GameOverLayer