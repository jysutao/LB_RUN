require("app.GameUtils")

BuildingsManager = class("BuildingsManager")

local Building = require("app.models.Building")

function BuildingsManager:ctor()
	if BuildingsManager.instance then
		error("[BuildingsManager] attempt to construct instance twice")
	end
	BuildingsManager.instance = self

	self.create_by_random = false
	self.start_object = nil
	self.end_object = nil
	self.building_pool = LB_ObjectPool.new(Building.new(), BUILDING_MAX_NUM)

	self.right_is_building = false
	self.cur_height = BUILDING_MAX_HEIGHT + GROUND_Y
end

function BuildingsManager:__delete()
	self.building_pool:__delete()
	self.building_pool = nil

	BuildingsManager.instance = nil
end

function BuildingsManager:CreateFlatLayer(layer)
	self.layer = layer

	self:AddOneBuilding(true)
	for i = 2, BUILDING_MAX_NUM do
		self:AddOneBuilding(false)
	end
end

function BuildingsManager:CreateRandomLayer(layer)	
	self.layer = layer	

	for i = 1, BUILDING_MAX_NUM do
		self:AddNextObject()
	end
end

function BuildingsManager:SetCurBuildingHeight(building)
	self.cur_height = building:getPositionY() + BUILDING_MAX_HEIGHT / 2
end

function BuildingsManager:GetCurBuildingHeight()
	return self.cur_height
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
	
	local end_x = 0
	local pos_y = GROUND_Y + BUILDING_MAX_HEIGHT / 2
	if not has_pre_hole then  -- 前一格是房子
		end_x = self.end_object:getPositionX() + BUILDING_INTERVAL
		pos_y = self.end_object:getPositionY() - 0.5
	else  -- 前一格是洞
		if self.end_object then
			end_x = self.end_object:getPositionX() + HOLE_WIDTH + BUILDING_INTERVAL
		end
	end

	new_building:setPosition(cc.p(end_x, pos_y))
	new_building:startMove()
	self.layer:addChild(new_building, GAME_Z_ORDER.BUILDING)

	if not self.end_object then
		self.end_object = new_building
	else
		self.end_object.next = new_building
		self.end_object = self.end_object.next
	end

	if not self.start_object then
		self.start_object = new_building	
	end
end

function BuildingsManager:CheckBuildingFrontOutside()
	local building = self.start_object
	if building then
		local x = building:getPositionX()
		if x < -BUILDING_WIDTH then
			self:RemoveFrontBuilding()
		end
	end
end

function BuildingsManager:RemoveFrontBuilding()	
	local building = self.start_object
	self.start_object = self.start_object.next
	-- 删除一个
	self.layer:removeChild(building)
	building:Reset()
	self.building_pool:PushBack(building)

	-- 删除一个的同时加入一个保证无穷完尽
	if self.create_by_random then		
		if math.random() > 0.3 then			
			self:AddOneBuilding(true) 		-- 加一个洞
		else			
			self:AddOneBuilding(false)
		end
	else
		self:AddOneBuilding(false)
	end
end

function BuildingsManager:UpdateState(game_state)
 	if game_state == GAME_STATE.START then
 		self.create_by_random = true
 	else
 		self.create_by_random = false
 	end
 end 

function BuildingsManager:Update(dt)
	self:CheckBuildingFrontOutside()
end