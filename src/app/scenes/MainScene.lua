require("app.models.Car")

local MainScene = class("MainScene", function()
    return display.newPhysicsScene("MainScene")
end)

local scheduler = require("framework.scheduler")

function MainScene:ctor()
	self:UpdateState(GAME_STATE.LOADING)
end

function MainScene:__delete()
    BuildingsManager.instance:UpdateState(GAME_STATE.END)
    self:StopSceneAction()
    self:removeAllChildren()
end

function MainScene:InitGameObjects()
    -- 添加世界
    self.world = self:getPhysicsWorld() 
    self.world:setGravity(cc.p(0, GAME_PHYSICS_GRAVITY))
    self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    local ground = display.newNode()
    local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, 0), cc.p(display.width, 0))
    bodyBottom:setContactTestBitmask(GAME_CONTACT_TEST_BIT_MASK.GROUND_MASK)
    ground:setPhysicsBody(bodyBottom)
    ground:setTag(GAME_OBJECT_TAG.GROUND)
    self:addChild(ground)

    -- 添加背景
    local bg = display.newSprite("#bg.png", display.cx, display.cy)
    bg:setScaleX(CONFIG_SCREEN_WIDTH / bg:getContentSize().width)
    bg:setScaleY(CONFIG_SCREEN_HEIGHT / bg:getContentSize().height)
    BgController.instance:Init()
    BgController.instance:SetBgSprite(self, bg)

    -- 获得分数控制器的引用
    self.score_controller = ScoreController.instance
    self.score_controller:Init()
    self.score_controller:CreateScoreLayer(self, GAME_Z_ORDER.FOREGROUND)

    -- 添加房子
    BuildingsManager.instance:Init()
    BuildingsManager.instance:CreateFlatLayer(self)

    -- 添加英雄
    self.car = Car.new(display.width / 4, display.cy - 15)
    self:addChild(self.car, GAME_Z_ORDER.HERO)

    -- 添加海浪
    WaveController.instance:Init()
    WaveController.instance:InitUpWave(self)
    WaveController.instance:AddWaveTipToLayer(self, GAME_Z_ORDER.FOREGROUND)

    self:AddTipLayer()
    self:AddTouchLayer()     
end

-- 状态更新
function MainScene:UpdateState(state)
    GAME_STATE.CUR_STATE = state
    BuildingsManager.instance:UpdateState(state)
    if state == GAME_STATE.LOADING then
        self:InitGameObjects()  
        -- 注册帧事件处理函数
        self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) self:Update(dt) end)
        self:scheduleUpdate()
        -- 添加飞行背影物品
        self.fly_handle = scheduler.scheduleGlobal(function()
            FlyObjectManager.instance:AddRandomFlyObject(self)
        end, 5.0)
        GAME_STATE.CUR_STATE = GAME_STATE.READY
    elseif state == GAME_STATE.START then
        self.tip_layer:setVisible(false)
        self:AddCollision()
    elseif state == GAME_STATE.END then
        self:StopSceneAction()
        self.result_layer = require("app.scenes.GameOverLayer").new()
        self:addChild(self.result_layer, GAME_Z_ORDER.FOREGROUND)
    end
end

function MainScene:StopSceneAction()
    if self.contactListener then
        local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
        eventDispatcher:removeEventListener(self.contactListener)    
        self.contactListener = nil
    end

    if self.fly_handle then
        scheduler.unscheduleGlobal(self.fly_handle)
        self.fly_handle = nil
    end

    self:removeNodeEventListener(cc.NODE_ENTER_FRAME_EVENT)
    self:unscheduleUpdate()

    self:getActionManager():removeAllActions()
end

function MainScene:AddTipLayer()
    self.tip_layer = display.newLayer()

    cc.ui.UILabel.new({
        UILabelType = 2, text = "长江后浪推前浪,你会倒在哪一浪", size = 28 , color = cc.c3b(0, 255, 0) })
    :align(display.LEFT_TOP, 0, display.top)
    :addTo(self.tip_layer)  

    local touch_txt = cc.ui.UILabel.new({
        UILabelType = 2, text = "点击屏幕开始", size = 40 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.top / 2)
    :addTo(self.tip_layer)  
    local bigger = cc.ScaleBy:create(0.6, 1.2)
    touch_txt:runAction(cc.RepeatForever:create(cc.Sequence:create(bigger, bigger:reverse())))

    self:addChild(self.tip_layer, GAME_Z_ORDER.FOREGROUND)

    self.tip_layer:setVisible(true)
end

function MainScene:AddTouchLayer()
    -- touchLayer 用于接收触摸事件
    self.touchLayer = display.newLayer()
    self:addChild(self.touchLayer, GAME_Z_ORDER.TOUCH_LAYER)
    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    self.touchLayer:setTouchEnabled(true)

    -- 监听Android返回和主菜单键
    self.touchLayer:setKeypadEnabled(true)
    self.touchLayer:addNodeEventListener(cc.KEYPAD_EVENT, function (event)  
        if event.key == "back" then  --返回键
            device.showAlert("退出", "你确定要退出游戏吗?", {"确定", "取消"}, function (event)
                if event.buttonIndex == 1 then  
                    os.exit()
                else  
                    device.cancelAlert()  --取消对话框
                end  
            end)
        elseif event.key == "menu" then  --菜单键
            self:UpdateState(GAME_STATE.END)
        end        
    end)
end

-- 添加碰撞事件检测
function MainScene:AddCollision()
    local function contactLogic(node)      
        if node:getTag() == GAME_OBJECT_TAG.CAR then
            self.car.can_jump = true
        elseif node:getTag() == GAME_OBJECT_TAG.BUILDING then
            if not node.hitted then
                BuildingsManager.instance:SetCurBuildingHeight(node)
                self.score_controller:IncScore()
                node.hitted = true
            end
        elseif node:getTag() == GAME_OBJECT_TAG.GROUND then
            self:UpdateState(GAME_STATE.END)
        end
    end
 
    local function onContactBegin(contact)        
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()
 
        contactLogic(a)
        contactLogic(b)
        return true
    end
 
    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.contactListener, 1)
end

-- 触摸事件处理
function MainScene:onTouch(event, x, y)
    if GAME_STATE.CUR_STATE == GAME_STATE.READY then      
        self:UpdateState(GAME_STATE.START)
    elseif GAME_STATE.CUR_STATE == GAME_STATE.START then  
        if self.car.can_jump then
            self.car:Jump()
            self.car.can_jump = false
        end
    elseif GAME_STATE.CUR_STATE == GAME_STATE.END then
        if self.result_layer then
            self.result_layer:onTouch(event, x, y)
        end
    end
end

function MainScene:Update(dt)
    BgController.instance:MoveBg(dt)
    BuildingsManager.instance:Update(dt)
    WaveController.instance:UpdateWaves(dt)
end

return MainScene
