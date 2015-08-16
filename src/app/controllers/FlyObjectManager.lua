FlyObjectManager = class("FlyObjectManager")

local FlyObjectType = {
	STAR = 1,
	CLOUD = 2,
	PLANE = 3,	
	ROCKET = 4,
}

local FlyDir = {
	LEFT = 1,
	UP = 2,
	LEFT_UP = 3,
}

function FlyObjectManager:ctor()
	if FlyObjectManager.instance then
		error("[FlyObjectManager] attempt to construct instance twice")
	end
	FlyObjectManager.instance = self
end

function FlyObjectManager:__delete()
	FlyObjectManager.instance = nil
end

function FlyObjectManager:AddRandomFlyObject(layer)
	self:AddFlyObject(math.random(1, 4), layer)
end

function FlyObjectManager:AddFlyObject(object_type, layer)
	object_type = FlyObjectType.CLOUD
	local fly_oject = nil
	local dir = FlyDir.LEFT
	local move_time
	if object_type == FlyObjectType.STAR then
		fly_oject = display.newSprite("#star.png")
		fly_oject:setScale(0.5)
		fly_oject:setRotation(math.random() * 360)
		move_time = math.random(12, 15)
	elseif object_type == FlyObjectType.CLOUD then
		fly_oject = display.newSprite(string.format("#cloud_%d.png", math.random(1, 3)))
	elseif object_type == FlyObjectType.PLANE then		
		fly_oject = display.newSprite("#plane.png")
	elseif object_type == FlyObjectType.ROCKET then
		fly_oject = display.newSprite("#rocket.png")
		move_time = math.random(4, 6)
		dir = FlyDir.LEFT_UP
	end

	if fly_oject then
		if dir == FlyDir.LEFT then
			fly_oject:setPosition(cc.p(display.right + 100, math.random(display.height * 2 / 3, display.height)))
		elseif dir == FlyDir.LEFT_UP then
			local width = display.width / 4
			fly_oject:setPosition(cc.p(width + math.random(width, width * 2), 0))
		end
		self:StartFly(fly_oject, move_time, dir)
		layer:addChild(fly_oject, GAME_Z_ORDER.FLY_OBJECT)
	end
end

function FlyObjectManager:StartFly(fly_oject, move_time, dir)
	local move_time = move_time or math.random(5,8)
	local move_action = nil
	local remove_action = nil
	if dir == FlyDir.LEFT then
		move_action = cc.MoveBy:create(move_time, cc.p(- (display.width + fly_oject:getContentSize().width), 0))
		remove_action = cc.CallFunc:create(function()
			fly_oject:removeFromParent()		
		end)
	elseif dir == FlyDir.LEFT_UP then
		move_action = cc.MoveBy:create(move_time, cc.p(-display.width / 6, display.top + fly_oject:getContentSize().height))
		remove_action = cc.CallFunc:create(function()
			fly_oject:removeFromParent()		
		end)
	end
	fly_oject:runAction(cc.Sequence:create(move_action, remove_action))
end