require("app.GameUtils")

BuildingsManager = class("BuildingsManager")

local Building = require("app.models.Building")

function BuildingsManager:ctor()
	if BuildingsManager.instance then
		error("[BuildingsManager] attempt to construct instance twice")
	end
	BuildingsManager.instance = self

	self.end_object = nil
	self.building_pool = LB_ObjectPool.new(Building.new(), BUILDING_MAX_NUM)

	self.right_is_building = false
end

function BuildingsManager:__delete()
	self.building_pool:__delete()
	self.building_pool = nil

	BuildingsManager.instance = nil
end

function BuildingsManager:Update()

end

function BuildingsManager:CreateRandomLayer(layer)	
	self.layer = layer

	math.randomseed(os.time())

	for i = 1, BUILDING_MAX_NUM do
		self:AddNextObject()
	end
end

function BuildingsManager:AddNextObject()
	if self.right_is_building == false then --如果是洞则添加一个房
		self:AddOneBuilding(true)
		self.right_is_building = true
	else
		local is_add_building = math.random(0, 1)
		if is_add_building == 1 then
			self:AddOneBuilding(false)
			self.right_is_building = true
		else
			self.right_is_building = false
		end
	end
end

function BuildingsManager:AddOneBuilding(has_pre_hole)
	local new_building = self.building_pool:GetObject()
	
	local end_x = CONFIG_SCREEN_WIDTH
	if not has_pre_hole then  -- 前一格是房子
		end_x = self.end_object:getPositionX() + BUILDING_WIDTH
	else  -- 前一格是洞
		if self.end_object then
			end_x = self.end_object:getPositionX() + 2 * BUILDING_WIDTH
		end
	end

	new_building:setPosition(cc.p(end_x, GROUND_Y))
	new_building:startMove()
	self.layer:addChild(new_building, GAME_Z_ORDER.BUILDING)

	self.end_object = new_building
end

function BuildingsManager:RemoveBuilding(building)
	-- 删除一个
	self.layer:removeChild(building)
	self.building_pool:PushBack(building)

	-- 删除一个的同时加入一个保证无穷完尽
	if math.random(0, 1) == 1 then
		self:AddOneBuilding(false)
	else
		self:AddOneBuilding(true)
	end
end