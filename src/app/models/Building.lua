-- 用于被BuildingsManager使用
local Building = class("Building", function (x, y)
	local ret = display.newSprite("#wood.png", x, y)
	ret:setScaleX(BUILDING_WIDTH / ret:getContentSize().width)
	ret:setScaleY(BUILDING_MAX_HEIGHT / ret:getContentSize().height)

	local physics_body = cc.PhysicsBody:createEdgeBox({width = BUILDING_WIDTH, height = BUILDING_MAX_HEIGHT})		
	physics_body:setGravityEnable(false)
	physics_body:setDynamic(false)
	physics_body:setMass(10000)	
	physics_body:setContactTestBitmask(GAME_CONTACT_TEST_BIT_MASK.BUILDING_MASK)

    ret:setPhysicsBody(physics_body)
	ret:setTag(GAME_OBJECT_TAG.BUILDING)

	return ret
end)

function Building:Reset()
	self:stopAllActions()
	self.hitted = false
end

function Building:clone()
	return Building.new(self:getPositionX(), self:getPositionY())
end

function Building:startMove()	
	local move_action = cc.RepeatForever:create(cc.MoveBy:create(BUILDING_MOVE_TIME, cc.p(-CONFIG_SCREEN_WIDTH, 0))) 
	move_action:setTag(GAME_ACTION_TAG.BUILDING_MOVE)
	self:runAction(move_action)
end

return Building