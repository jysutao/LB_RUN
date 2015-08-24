TipController = class("TipController", function ()
	return display.newLayer()
end)

function TipController:ctor()
	if TipController.instance then
		error("[TipController] attempt to construct instance twice")
	end
	TipController.instance = self
end

function TipController:UpdateState(game_state, parent)
	if game_state == GAME_STATE.READY then
		-- 挑衅提示
		local provoke = cc.ui.UILabel.new({
	        UILabelType = 2, text = "据说没人能过50个木桩!", size = 32 , color = cc.c3b(255, 0, 0) })
	    :align(display.LEFT_TOP, 0, display.top)
	    :addTo(self)  

	    -- 遭遇提示
	    cc.ui.UILabel.new({
	        UILabelType = 2, text = "你可能会遭遇 : 涨潮, 黑夜, 小车失控! 敢来挑战吗!", size = 32 , color = cc.c3b(255, 0, 0) })
	    :align(display.LEFT_TOP, provoke:getPositionX(), provoke:getPositionY() - 40)
	    :addTo(self)

	    local touch_txt = cc.ui.UILabel.new({
	        UILabelType = 2, text = "点击屏幕开始", size = 40 , color = cc.c3b(0, 255, 0) })
	    :align(display.CENTER, display.cx, display.top / 2)
	    :addTo(self)  
	    local bigger = cc.ScaleBy:create(0.6, 1.2)
	    touch_txt:runAction(cc.RepeatForever:create(cc.Sequence:create(bigger, bigger:reverse())))

	    -- 退出按钮
	    local btn_width = display.width * 0.14
		local btn_height = display.height * 0.14
	    local exit_btn = display.newSprite("#exit_btn.png")
	    exit_btn:setScaleX(btn_width / exit_btn:getContentSize().width)
	    exit_btn:setScaleY(btn_height / exit_btn:getContentSize().height)
	    exit_btn:setAnchorPoint(cc.p(0, 0))
	    exit_btn:setPosition(10 , 10)
	    self:addChild(exit_btn)
	    self.exit_btn = {x = exit_btn:getPositionX(), y = exit_btn:getPositionY(), 
					    width = exit_btn:getContentSize().width, height = exit_btn:getContentSize().height}


	    parent:addChild(self, GAME_Z_ORDER.TOUCH_LAYER)
	elseif game_state == GAME_STATE.START then
		parent:removeChild(self, true)
		self.exit_btn = nil
	end
end

function TipController:onTouch(event, x, y)
    if GAME_STATE.CUR_STATE == GAME_STATE.READY then      
       	if self.exit_btn and 
       		x >= self.exit_btn.x and x <= self.exit_btn.x + self.exit_btn.width and
       		y >= self.exit_btn.y and y <= self.exit_btn.y + self.exit_btn.height then
       			os.exit()
       	end
    end
end