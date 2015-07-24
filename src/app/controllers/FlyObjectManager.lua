FlyObjectManager = class("FlyObjectManager")

FlyObjectType = {
	STAR = 1,
	CLOUD = 2,
	PLANE = 3,	
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
	self:AddFlyObject(math.random(1, 3), layer)
end

function FlyObjectManager:AddFlyObject(object_type, layer)
	local fly_oject = nil
	if object_type == FlyObjectType.STAR then
		fly_oject = display.newSprite("star.png")		
		fly_oject:setRotation(math.random() * 360)
	elseif object_type == FlyObjectType.CLOUD then
		fly_oject = display.newSprite("cloud.png")
		fly_oject:setRotation(math.random() * 360)
	elseif object_type == FlyObjectType.PLANE then		
		fly_oject = display.newSprite("plane.png")		
	end
	if fly_oject then
		fly_oject:setPosition(cc.p(display.right + 100, math.random(display.height * 2 / 3, display.height )))
		self:StartFly(fly_oject)
		layer:addChild(fly_oject, GAME_Z_ORDER.FLY_OBJECT)
	end
end

function FlyObjectManager:StartFly(fly_oject)
	local move_time = math.random(5,8)
	local move_action = cc.MoveBy:create(move_time, cc.p(- (display.width + 100), 0))
	local remove_action = cc.CallFunc:create(function()
		fly_oject:removeFromParent()		
	end)
	fly_oject:runAction(cc.Sequence:create(move_action, remove_action))
end