local CAR_BODY_WIDTH = 80
local CAR_BODY_HEIGHT = 60
local CAR_WHEEL_RADIUS = 10
local CAR_WHEEL_POSITION_X = 15

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

	local body = display.newRect(cc.rect(0, CAR_WHEEL_RADIUS * 2, CAR_BODY_WIDTH, CAR_BODY_HEIGHT),{fillColor = cc.c4f(1,1,1,1)})
	root:addChild(body)

	local wheel_l = display.newSolidCircle(CAR_WHEEL_RADIUS, {x = CAR_WHEEL_POSITION_X, y = CAR_WHEEL_RADIUS, color = cc.c4f(1, 1, 1, 1)})
	root:addChild(wheel_l)

	local line_1 = display.newLine({{CAR_WHEEL_POSITION_X, 0}, {CAR_WHEEL_POSITION_X, CAR_WHEEL_RADIUS} },
		{borderColor = cc.c4f(1, 0, 0, 1), borderWidth = 2})
	wheel_l:addChild(line_1)

	local wheel_r = display.newSolidCircle(CAR_WHEEL_RADIUS, {x = CAR_BODY_WIDTH - CAR_WHEEL_POSITION_X, y = CAR_WHEEL_RADIUS, color = cc.c4f(1, 1, 1, 1)})
	root:addChild(wheel_r)

	local line_2 = display.newLine({{CAR_BODY_WIDTH - CAR_WHEEL_POSITION_X, 0}, {CAR_BODY_WIDTH - CAR_WHEEL_POSITION_X, CAR_WHEEL_RADIUS} },
		{borderColor = cc.c4f(1, 0, 0, 1), borderWidth = 2})
	wheel_r:addChild(line_2)

	return root
end)