WeatherBlack = class("WeatherBlack", function()
    local color_layer = display.newSprite("weather_black.png")
    color_layer:setAnchorPoint(cc.p(0.5, 0.5))
    color_layer:setPosition(display.cx, display.cy)
    color_layer:setScaleX(CONFIG_SCREEN_WIDTH / color_layer:getContentSize().width)
    color_layer:setScaleY(CONFIG_SCREEN_HEIGHT / color_layer:getContentSize().height)
    return color_layer
end)

function WeatherBlack:ctor()
	self:setOpacity(0)
	self.state = WEATHER_STATE.READY
end

function WeatherBlack:UpdateState(state)
	self.state = state
	if state == WEATHER_STATE.READY then
		self:setOpacity(0)
	elseif state == WEATHER_STATE.HAPPEN then
		self:stopAllActions()
		self:setOpacity(0)
		local action = cc.Sequence:create(cc.FadeIn:create(2), cc.DelayTime:create(0.5), cc.FadeOut:create(2))
		self:runAction(action)
	elseif state == WEATHER_STATE.STOP then
		self:stopAllActions()
		self:runAction(cc.FadeOut:create(0.5))
	elseif state == WEATHER_STATE.REMOVE then
		self:stopAllActions()
		self:setOpacity(0)
	end
end