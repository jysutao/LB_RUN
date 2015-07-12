
Role = class("Role" , function(x, y)
	local armature = ccs.Armature:create("fat_boy")
	if x then
		armature:setPositionX(x)
	else
		armature:setPositionX(display.cx)
	end
	if y then
		armature:setPositionY(y)
	else
		armature:setPositionY(display.cy)
	end
	armature:setScale(0.5)
	armature:getAnimation():setSpeedScale(1.0)
	return armature
end)

function Role:ctor()
	self:getAnimation():play("run")
end
