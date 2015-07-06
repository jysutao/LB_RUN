-- 用于被BuildingsManager使用
local BLACK_LAYER_NAME = "black_layer"
local COLOR_LAYER_NAME = "color_layer"

local Building = class("Building", function (x, y)
	local black_layer = cc.LayerColor:create(cc.c4b(0xff, 0xff, 0xff, 0xff), BUILDING_WIDTH, BUILDING_MAX_HEIGHT)
	black_layer:setName(BLACK_LAYER_NAME)	
	local color_layer = cc.LayerColor:create(cc.c4b(0, 0xff, 0, 0xff), BUILDING_WIDTH, BUILDING_MAX_HEIGHT)	
	color_layer:setVisible(false)
	color_layer:setName(COLOR_LAYER_NAME)
	local ret = cc.Node:create()
	ret:setAnchorPoint(0, 0)
	ret:addChild(color_layer)
	ret:addChild(black_layer)	
	ret:setPosition(x, y)
	return ret
end)

function Building:Blink(duration)	
	duration = duration or 3

	local black_layer = self:getChildByName(BLACK_LAYER_NAME)
	local color_layer = self:getChildByName(COLOR_LAYER_NAME)

	local fade_out_action = cc.FadeOut:create(duration / 3)	
	local delay_action = cc.DelayTime:create(duration / 8)
	local fade_in_action = cc.FadeIn:create(duration / 3)

	local action_sequence = cc.Sequence:create(fade_out_action, delay_action, fade_in_action)
	action_sequence:setTag(GAME_ACTION_TAG.BUILDING_BLINK)	

	black_layer:stopActionByTag(GAME_ACTION_TAG.BUILDING_BLINK)
	black_layer:runAction(action_sequence)
	
	if color_layer:isVisible() then
		color_layer:stopActionByTag(GAME_ACTION_TAG.BUILDING_BLINK)
		color_layer:runAction(action_sequence:clone())	
	end
end

function Building:ChangeColor()
	local black_layer = self:getChildByName(BLACK_LAYER_NAME)
	local color_layer = self:getChildByName(COLOR_LAYER_NAME)

	black_layer:stopActionByTag(GAME_ACTION_TAG.BUILDING_BLINK)
	color_layer:setVisible(true)
end

function Building:startMove()
	local move_time = self:getPositionX() / CONFIG_SCREEN_WIDTH * BUILDING_MOVE_TIME
	local move_action = cc.Sequence:create(cc.MoveTo:create(move_time, cc.p(-BUILDING_WIDTH, GROUND_Y)),
									cc.CallFunc:create(BuildingsManager.instance.RemoveFrontBuilding))
	move_action:setTag(GAME_ACTION_TAG.BUILDING_MOVE)
	self:runAction(move_action)
end

return Building