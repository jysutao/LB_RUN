BgController = class("BgController")

function BgController:ctor()
	if BgController.instance then
		error("[BgController] attempt to construct instance twice")
	end
	BgController.instance = self
	self.sprite = {}
end

function BgController:Init(layer)
	self:ReleaseResource()
	self.layer = layer
end

function BgController:ReleaseResource()
	for index, sprite in pairs(self.sprite) do
		sprite:release()
		sprite = nil
	end
	self.sprite = {}
end

function BgController:SetBgSprite(sprite , z_order ,index)
	local index = index or 1
	sprite:retain()
	self.sprite[index] = sprite
	local z_order = z_order or GAME_Z_ORDER.BACKGROUND
	self.layer:addChild(sprite, z_order)
end

-- speed为一秒移动的距离, > 0 为向左移动的速度
function BgController:SetBgSpeed(speed, index)
	local index = index or 1
	if self.sprite[index] then
		self.sprite[index].move_speed = speed
	end
end

function BgController:MoveBg(dt)
	-- for _, sprite in pairs(self.sprite) do
	-- 	if sprite.move_speed then
	-- 		sprite:setPositionX(sprite:getPositionX() - sprite.move_speed * dt)
	-- 	end
	-- end 
end