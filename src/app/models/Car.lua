local CAR_BODY_WIDTH = 80
local CAR_BODY_HEIGHT = 60
local CAR_WHEEL_RADIUS = 10
local CAR_WHEEL_POSITION_X = 15
local CAR_MASS = 200
local CAR_TOTAL_HEIGHT = CAR_BODY_HEIGHT + CAR_WHEEL_RADIUS * 2

Car = class("Car", function(x, y)
	if not x then
		x = display.cx
	end

	if not y then
		y = display.cy
	end
	local root = cc.Node:create()
	root:setAnchorPoint(cc.p(1, 0))
	root:setPositionX(x)
	root:setPositionY(y)

	local left_x = - CAR_BODY_WIDTH / 2
	local bottom_y = - CAR_TOTAL_HEIGHT / 2

	local body = display.newSprite("car_body.png")
	body:setAnchorPoint(cc.p(0.5, 0))
	body:setPositionY(bottom_y + 2 * CAR_WHEEL_RADIUS)
	body:setScaleX(CAR_BODY_WIDTH / body:getContentSize().width)
	body:setScaleY(CAR_BODY_HEIGHT / body:getContentSize().height)
	root:addChild(body)

	local wheel_l = display.newSprite("car_wheel.png", left_x + CAR_WHEEL_POSITION_X, bottom_y + CAR_WHEEL_RADIUS)
	wheel_l:setScale(CAR_WHEEL_RADIUS * 2 / wheel_l:getContentSize().width)
	wheel_l:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 180)))
	root:addChild(wheel_l)

	local wheel_r = display.newSprite("car_wheel.png", left_x + CAR_BODY_WIDTH - CAR_WHEEL_POSITION_X, bottom_y + CAR_WHEEL_RADIUS)
	wheel_r:setScale(CAR_WHEEL_RADIUS * 2 / wheel_l:getContentSize().width)
	wheel_r:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 180)))
	root:addChild(wheel_r)

	local physics_body = cc.PhysicsBody:createBox({width = CAR_BODY_WIDTH, height = CAR_TOTAL_HEIGHT})			
	physics_body:setMass(CAR_MASS)
	physics_body:setRotationEnable(false)
	physics_body:setVelocityLimit(GAME_PHYSICS_CAR_JUMP_VELOCITY)
	physics_body:setContactTestBitmask(GAME_CONTACT_TEST_BIT_MASK.CAR_MASK)	
    root:setPhysicsBody(physics_body)

    root:setTag(GAME_OBJECT_TAG.CAR)
	return root
end)

function Car:Jump()
	local y = self:getPositionY() - CAR_TOTAL_HEIGHT / 2
	local building_y = BuildingsManager.instance:GetCurBuildingHeight()
	if y >= building_y - 2 and y < building_y + 30 then
		self:getPhysicsBody():setVelocity(cc.p(0, GAME_PHYSICS_CAR_JUMP_VELOCITY))
	end	
end