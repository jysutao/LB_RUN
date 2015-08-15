--[[
--队列
以单向链表的方式进行实现
]] 
LB_Queue = class("LB_Queue")

function LB_Queue:ctor()
	self.front_object = nil
	self.back_object = nil
	self.size = 0
end

function LB_Queue:__delete()
	self:clear()
end

function LB_Queue:clear()
	while not self:IsEmpty() do
		self:Pop()
	end
end

function LB_Queue:Push(object)
	local new_object = {
		next = nil,
		data = object,
	}
	if not self.back_object then
		self.front_object = new_object
		self.back_object = new_object
		return
	end
	self.back_object.next = new_object

	self.back_object = self.back_object.next
	self.size = self.size + 1

end

function LB_Queue:GetFront()	
	return self.front_object.data
end

function LB_Queue:Pop()	
	local next_object = self.front_object.next
	self.front_object.next = nil
	self.front_object.data = nil
	self.front_object = next_object
	self.size = self.size - 1
end

function LB_Queue:GetSize()
	return self.size
end

function LB_Queue:IsEmpty()
	return (self.front_object == nil)
end

--[[
--栈
注意：下标从1开始
]] 
LB_STACK = class("LB_STACK")

function LB_STACK:ctor()
	self.list = {} 
	self.size = 0
end

function LB_STACK:__delete()
	self:Clear()
end

function LB_STACK:Clear()
	while not self:IsEmpty() do
		self:Pop()
	end
	self.list = {}
end

function LB_STACK:Push(object)
	self.size = self.size + 1
	self.list[self.size] = object
end

function LB_STACK:PopObject()
	local ret = nil
	if self.size >= 1 then
		ret = self.list[self.size]
		self.size = self.size - 1
	end
	return ret
end

function LB_STACK:Pop()
	if not self:IsEmpty() then
		self.list[self.size]:__delete()
		self.list[self.size] = nil

		self.size = self.size - 1
	end
end

function LB_STACK:GetSize()
	return self.size
end

function LB_STACK:IsEmpty()
	return self:GetSize() <= 0
end

--[[
-- 用于存放Node对象的对象池
]] 
LB_ObjectPool = class("LB_ObjectPool")

function LB_ObjectPool:ctor(cc_node_object, size)
	if not cc_node_object.clone then
		error("[LB_ObjectPool] no clone function define!")
	end
	print("pool ctor")
	print(cc_node_object == nil)
	self.base_object = cc_node_object
	self.objects = {}
	self.used = {}
	self.size = 0
	local new_object = nil
	for i = 1, size do
		self:AddObject(i)
	end
end

function LB_ObjectPool:AddObject(idx)
	self.used[idx] = false
	local clone_object = self.base_object:clone()
	clone_object:retain()
	clone_object.id = idx
	self.objects[idx] = clone_object
	self.size = self.size + 1
end


function LB_ObjectPool:__delete()
	self.base_object = nil
	for i = 1, self.size do
		self.objects[i]:release()
		self.objects[i] = nil
	end
	self.objects = {}
	self.used = {}
end

-- 删除元素时把调用此方法元素把元素重新放入对象池中
function LB_ObjectPool:PushBack(cc_node_object)
	if cc_node_object.stopAllActions then
		cc_node_object:stopAllActions()
	end
	
	for i = 1, self.size do
		if self.objects[i].id == cc_node_object.id then
			self.used[i] = false
			return
		end
	end
	error("[LB_ObjectPool] object not in pool yet")
end

function LB_ObjectPool:GetObject()
	for i = 1, self.size do
		if self.used[i] == false then
			self.used[i] = true
			return self.objects[i]
		end
	end
	self:AddObject(self.size + 1)
	self.used[self.size] = true
	return self.objects[self.size]
end

ScreenHelper = {}
function ScreenHelper.AutoScale(sprite)
	sprite:setScaleX(CONFIG_SCREEN_WIDTH / CONFIG_BASE_WIDTH)
	sprite:setScaleY(CONFIG_SCREEN_HEIGHT / CONFIG_BASE_HEIGHT)
end




