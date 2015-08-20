local rect_width = display.width * 0.4
local rect_height = display.height * 0.7
local btn_width = rect_width * 0.33
local btn_height = rect_height * 0.2
local btn_y = display.cy - rect_height * 0.16
local replay_btn_cx = display.cx + rect_width * 0.25
local exit_btn_cx = display.cx - rect_width * 0.25
local new_record_icon_width = rect_width * 0.35

local GameOverLayer = class("GameOverLayer", function()
    return display.newLayer()
end)

function GameOverLayer:ctor()
    local score_controller = ScoreController.instance
    -- 设置当前分数
    local score = score_controller:GetScore()
    local highest_score = score_controller:GetHighestScore()

    -- 背影
    local bg = display.newSprite("#result_bg.png", display.cx, display.cy)
    bg:setScaleX(rect_width / bg:getContentSize().width)
    bg:setScaleY(rect_height / bg:getContentSize().height)
    self:addChild(bg)

    -- 重玩按钮
    self.replay_btn = display.newSprite("#continue_btn.png", replay_btn_cx, btn_y)
    self.replay_btn:setScaleX(btn_width / self.replay_btn:getContentSize().width)
    self.replay_btn:setScaleY(btn_height / self.replay_btn:getContentSize().height)
    self:addChild(self.replay_btn)

    -- 退出按钮
    self.exit_btn = display.newSprite("#exit_btn.png", exit_btn_cx, btn_y)
    self.exit_btn:setScaleX(btn_width / self.exit_btn:getContentSize().width)
    self.exit_btn:setScaleY(btn_height / self.exit_btn:getContentSize().height)
    self:addChild(self.exit_btn)

    -- 弹出动画
    local action_time = 0.3
    local delta_y = CONFIG_SCREEN_HEIGHT / 4
    local appear_action = cc.Spawn:create(cc.MoveBy:create(action_time, cc.p(0, delta_y)), cc.ScaleTo:create(action_time, 1))
    self:setPositionY(self:getPositionY() - delta_y)
    self:setScale(0.3)
    if score > highest_score then
        self:runAction(cc.Sequence:create(appear_action, cc.CallFunc:create(handler(self, self.AddNewRecordIcon) )))
    else
        self:runAction(appear_action)
    end
    
    -- 显示得分文本
    highest_score = math.max(highest_score, score)
    score_controller:SaveHighestScore(highest_score)
    cc.ui.UILabel.new({
        UILabelType = 2, text = string.format("%d", score), size = 80 , color = cc.c3b(255, 50, 50) })
    :align(display.CENTER, display.cx, display.cy + 100)
    :addTo(self)

    cc.ui.UILabel.new({
        UILabelType = 2, text = string.format("历史最高:%d", highest_score), size = 30 , color = cc.c3b(0, 0, 0) })
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)
end

function GameOverLayer:AddNewRecordIcon()
    local new_record = display.newSprite("#new_record.png", display.cx + rect_width / 2 - 20, display.cy + rect_height / 2 - 20)
    local normal_scale = new_record_icon_width / new_record:getContentSize().width
    new_record:setScale(8)
    self:addChild(new_record)
    new_record:runAction(cc.ScaleTo:create(0.5, normal_scale))
    MusicController:PlaySound(MUSIC_TYPE.BEAT)
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
        if isClickBtn(x, y, replay_btn_cx, btn_y, btn_width, btn_height) then   -- 重玩
            local new_scene = require("app.scenes.MainScene").new()
            new_scene:UpdateState(GAME_STATE.START)
            local trans = cc.TransitionFadeTR:create(0.6, new_scene)
            cc.Director:getInstance():replaceScene(trans)
        elseif isClickBtn(x, y, exit_btn_cx, btn_y, btn_width, btn_height) then -- 退出
            os.exit()
        end
    end
end

return GameOverLayer