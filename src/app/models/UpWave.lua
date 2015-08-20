-- 上升下降浪
local UpWave = class("UpWave", function()
	local wave_sprite = display.newSprite("#up_wave.png")
	wave_sprite:setScaleX(CONFIG_SCREEN_WIDTH / wave_sprite:getContentSize().width)
	wave_sprite:setScaleY(CONFIG_SCREEN_HEIGHT / wave_sprite:getContentSize().height)
	wave_sprite:setAnchorPoint(cc.p(0.5, 1))
	wave_sprite:setPosition(display.cx, 0)
	return wave_sprite
end)

local UpWaveState = {
	RAISE = 1,
	AT_HEIGHT = 2,
	FALL = 3,
	AT_DOWN = 4,
}

local SPEED_X = CONFIG_SCREEN_WIDTH / 4

function UpWave:ctor()
	self.x = display.cx
	self.min_height = GROUND_Y
	self.y = self.min_height
	self.max_height = GROUND_Y + BUILDING_MAX_HEIGHT + 40
	self.state_times = {}
	self.raise_speed = 0
	self.fall_speed = 0
	self.cur_state = UpWaveState.AT_DOWN
	self.state_timer = 0

	self:SetStatesTime({
		{UpWaveState.RAISE, 4},
		{UpWaveState.AT_HEIGHT, 2},
		{UpWaveState.FALL, 3},
		{UpWaveState.AT_DOWN, 1},
	})
end

-- 设置退潮最低高度
function UpWave:SetMinHeight(min_height)
	self.min_height = min_height
	self.y = self.min_height

	self:setPositionY(self.y)
end

-- 设置涨潮最大高度
function UpWave:SetMaxHeight(max_height)
	self.max_height = max_height or 0
	if self.state_times[UpWaveState.RAISE] then
		self.raise_speed = (self.max_height - self.min_height) / self.state_times[UpWaveState.RAISE]
	end

	if self.state_times[UpWaveState.FALL] then
		self.fall_speed = (self.max_height - self.min_height) / self.state_times[UpWaveState.FALL]
	end
end

-- 设置潮起潮落每个阶段持续时间
function UpWave:SetStateTime(wave_state, time_sec)
	self.state_times[wave_state] = time_sec or 0
	if wave_state == UpWaveState.RAISE then
		self.raise_speed = (self.max_height - self.min_height) / time_sec
	elseif wave_state == UpWaveState.FALL then
		self.fall_speed = (self.max_height - self.min_height) / time_sec
	end
end

--　一次设置几个阶段的持续时间
function UpWave:SetStatesTime(data_list)
	for i = 1, #data_list do
		local state = data_list[i][1]
		local time = data_list[i][2]
		self:SetStateTime(state, time)
	end
end

function UpWave:SetCurState(state)
	self.cur_state = state
	self.state_timer = 0
end

function UpWave:SetGetXFunc(func)
	self.get_new_x = func
end

function UpWave:Update(dt)
	local new_x = self:getPositionX() - SPEED_X * dt
	if new_x < -CONFIG_SCREEN_WIDTH / 2 then
		if self.get_new_x then		
			self:setPositionX(self:get_new_x())
		end
	else
		self:setPositionX(new_x)
	end

	local state = self.cur_state
	if state == UpWaveState.RAISE then
		local new_y = self:getPositionY() + self.raise_speed * dt
		if new_y < self.max_height then
			self:setPositionY(new_y)
		end
	elseif state == UpWaveState.AT_HEIGHT then

	elseif state == UpWaveState.FALL then
		local new_y = self:getPositionY() - self.fall_speed * dt
		if new_y > self.min_height then
			self:setPositionY(new_y)
		end
	elseif state == UpWaveState.AT_DOWN then

	end

	self.state_timer = self.state_timer + dt
	if self.state_timer > self.state_times[self.cur_state] then
		self.state_timer = 0

		if self.cur_state == UpWaveState.AT_DOWN then
			self.cur_state = UpWaveState.RAISE
			self.state_times[UpWaveState.AT_HEIGHT] = self.state_times[UpWaveState.AT_HEIGHT] + 0.2
		else
			self.cur_state = self.cur_state + 1
		end

		if self.cur_state == UpWaveState.FALL then
			WaveController.instance:ShowWaveTip(false)
		elseif self.cur_state == UpWaveState.RAISE then
			WaveController.instance:ShowWaveTip(true)
			MusicController.instance:PlaySound(MUSIC_TYPE.WAVE_UP)
		end
	end
end

return UpWave