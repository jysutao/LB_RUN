require("app.models.Car")

local MainScene = class("MainScene", function()
    return display.newPhysicsScene("MainScene")
end)

local scheduler = require("framework.scheduler")

function MainScene:ctor()
	self:InitGameObjects()	

    -- 注册帧事件处理函数
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt) self:Update(dt) end)
    self:scheduleUpdate()

    local function _addFlyObject()
        FlyObjectManager.instance:AddRandomFlyObject(self)
    end
    self.fly_handle = scheduler.scheduleGlobal(_addFlyObject, 5.0)
end

function MainScene:onEnter()
    GAME_STATE.CUR_STATE = GAME_STATE.READY
end

function MainScene:onExit()
    scheduler.unscheduleGlobal(self.fly_handle)
end

function MainScene:AddTipLayer()
    self.tip_layer = display.newLayer()

    cc.ui.UILabel.new({
        UILabelType = 2, text = "黑夜给了一辆白色的小车，我将用它驶向光明", size = 28 , color = cc.c3b(0, 255, 0) })
    :align(display.LEFT_TOP, 0, display.top)
    :addTo(self.tip_layer)  

    local touch_txt = cc.ui.UILabel.new({
        UILabelType = 2, text = "点击屏幕开始", size = 40 , color = cc.c3b(0, 255, 0) })
    :align(display.CENTER, display.cx, display.top / 2)
    :addTo(self.tip_layer)  
    local bigger = cc.ScaleBy:create(0.6, 1.2)
    touch_txt:runAction(cc.RepeatForever:create(cc.Sequence:create(bigger, bigger:reverse())))

    self:addChild(self.tip_layer, GAME_Z_ORDER.FOREGROUND)
end

function MainScene:AddTouchLayer()
    -- touchLayer 用于接收触摸事件
    self.touchLayer = display.newLayer()
    self:addChild(self.touchLayer, GAME_Z_ORDER.TOUCH_LAYER)

    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    self.touchLayer:setTouchEnabled(true)
end

function MainScene:InitScore(score)
	self.score = score or 0
	self.score_label = cc.ui.UILabel.new({
            UILabelType = 2, text = self.score, size = 64})
        :align(display.RIGHT_TOP, display.width, display.top)
        :addTo(self, GAME_Z_ORDER.FOREGROUND)
end

function MainScene:AddScore()
    self.score = self.score + 1
    self.score_label:setString(self.score)
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

	-- 添加房子
	BuildingsManager.instance:CreateFlatLayer(self)

	-- 添加英雄
	self.car = Car.new(display.width / 4, display.cy - 15)
	self:addChild(self.car, GAME_Z_ORDER.HERO)

	self:AddTipLayer()
    self:AddTouchLayer()    
	self:InitScore()   
end

function MainScene:AddCollision()
    local function contactLogic(node)      
        if node:getTag() == GAME_OBJECT_TAG.CAR then
            self.car.can_jump = true
        elseif node:getTag() == GAME_OBJECT_TAG.BUILDING then
            if not node.hitted then
                BuildingsManager.instance:SetCurBuildingHeight(node)
                node:ChangeColor()
                self:AddScore()
                node.hitted = true
            end
        elseif node:getTag() == GAME_OBJECT_TAG.GROUND then
            GAME_STATE.CUR_STATE = GAME_STATE.END            
            self:EndGame()
        end
    end
 
    local function onContactBegin(contact)        
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()
 
        contactLogic(a)
        contactLogic(b)
        return true
    end
 
    local function onContactSeperate(contact)        
    end
 
    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    self.contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(self.contactListener, 1)
end

function MainScene:onTouch(event, x, y)
    if GAME_STATE.CUR_STATE == GAME_STATE.READY then
        GAME_STATE.CUR_STATE = GAME_STATE.START        
        BuildingsManager.instance:UpdateState(GAME_STATE.CUR_STATE)
        self:removeChild(self.tip_layer)
        self:AddCollision()
    elseif GAME_STATE.CUR_STATE == GAME_STATE.START then  
        if self.car.can_jump then
            self.car:Jump()
            self.car.can_jump = false
        end
    elseif GAME_STATE.CUR_STATE == GAME_STATE.END then

    end
end

function MainScene:EndGame()    
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:removeEventListener(self.contactListener)    

    scheduler.unscheduleGlobal(self.fly_handle)
    self:unscheduleUpdate()

    cc.Director:getInstance():pause()
end

function MainScene:Update(dt)
    BuildingsManager.instance:Update(dt)
end

return MainScene
