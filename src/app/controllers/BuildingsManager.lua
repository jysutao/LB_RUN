local Building = require("app.models.Building")
local BuildingsManager = class("BuildingsManager", nil)

function BuildingsManager:ctor()
	print("create BuildingsManager")
	if BuildingsManager.instance then
		error("[BuildingsManager] attempt to construct instance twice")
	end
	BuildingsManager.instance = self

	self.end_x = display.right
	self.start_y = GROUND_Y
	self.building_width = BUILDING_WIDTH
	self.building_list = LB_Queue.new()	
end

function BuildingsManager:__delete()
	self.building_list = nil
	BuildingsManager.instance = nil
end

function BuildingsManager:CreateRandomLayer(layer)	
	
	math.randomseed(os.time())
	local num = 100
	local pre_is_hole = false
	self:AddBuilding(layer)

	local random = math.random
	for k = 1, num - 1 do
		if random() > 0.7 then			
			self:AddBuilding(layer)
			pre_is_hole = false
		elseif pre_is_hole then
			self:AddBuilding(layer)
			pre_is_hole = false
		else
			self:AddHole()
			pre_is_hole = true
		end
	end
end

function BuildingsManager:AddBuilding(layer)
	if not layer then
		error("[BuildingsManager] layer is nil")
		return
	end

	local new_building = Building.new(self.end_x, self.start_y)	
	new_building:Blink()	
	new_building:startMove()	
	self.building_list:Push(new_building)
	layer:addChild(new_building)

	self.end_x = self.end_x + self.building_width
end

function BuildingsManager:AddHole()
	self.end_x = self.end_x + self.building_width
end

function BuildingsManager:RemoveFrontBuilding()
	local building = BuildingsManager.instance.building_list:GetFront()
	building:removeFromParent()	
	BuildingsManager.instance.building_list:Pop()
end

return BuildingsManager