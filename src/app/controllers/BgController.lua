BgController = class("BgController")

function BgController:ctor()
	if BgController.instance then
		error("[BgController] attempt to construct instance twice")
	end
	BgController.instance = self
	
	self:Init()
end

function BgController:__delete()
	BgController.instance = nil
end

function BgController:Init()
	self.sprite = {}
end

function BgController:SetBgSprite(layer, sprite , z_order ,index)
	local index = index or 1
	self.sprite[index] = sprite
	local z_order = z_order or GAME_Z_ORDER.BACKGROUND
	layer:addChild(sprite, z_order)
end

-- speed为一秒移动的距离, > 0 为向左移动的速度
function BgController:SetBgSpeed(speed, index)
	local index = index or 1
	if self.sprite[index] then
		self.sprite[index].move_speed = speed
	end
end