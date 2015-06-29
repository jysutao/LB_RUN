LB_Queue = class("LB_Queue", nil)

function LB_Queue:ctor()
	self.MAX_SIZE = 10000	--用于构造循环数组
	self.front_index = 1
	self.tail_index = 0
	self.array = {}
end

function LB_Queue:__delete()
	self:clear()
end

function LB_Queue:clear()
	while(not self:IsEmpty())
	do
		self:Pop()
	end
end

function LB_Queue:Push(object)
	if self.array[self.tail_index] then
		self.array[self.tail_index]:__delete()
		self.array[self.tail_index] = nil
	end
	
	self.tail_index = self.tail_index + 1
	self.array[self.tail_index] = object	

	if self.tail_index > self.MAX_SIZE then
		self.tail_index = 1
	end
end

function LB_Queue:GetFront()	
	return self.array[self.front_index]	
end

function LB_Queue:Pop()	
	if not self:IsEmpty() then
		self.array[self.front_index]:__delete()
		self.array[self.front_index] = nil

		self.front_index = self.front_index + 1	
		if self.front_index > self.MAX_SIZE then
			self.front_index = 1
		end
	end
end

function LB_Queue:GetSize()
	return self.tail_index - self.front_index + 1
end

function LB_Queue:IsEmpty()
	return self.tail_index > self.front_index
end