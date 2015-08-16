WaveController = class("WaveController")

function WaveController:ctor()
	if WaveController.instance then
		error("[WaveController] attempt to construct instance twice")
	end
	WaveController.instance = self

	self:Init()
end

function WaveController:Init()
	self.waves = {}
end

function WaveController:__delete()
	WaveController.instance = nil
end

function WaveController:AddWaveTipToLayer(layer, z_order)
	self.up_arrow = display.newSprite("#up_arrow.png", display.cx, display.height * 0.6)
	self.up_arrow:setVisible(false)
	self.up_arrow:setScale(1.5)
	layer:addChild(self.up_arrow, z_order)

	self.down_arrow = display.newSprite("#down_arrow.png", display.cx, display.height * 0.6)
	self.down_arrow:setVisible(false)
	self.down_arrow:setScale(1.5)
	layer:addChild(self.down_arrow, z_order)
end

function WaveController:ShowWaveTip(is_up)
	self.up_arrow:stopAllActions()
	self.down_arrow:stopAllActions()
	local blink_action = cc.Blink:create(2, 4)
	if is_up then
		self.up_arrow:setVisible(true)
		self.up_arrow:runAction(cc.Sequence:create(blink_action, cc.Hide:create()))
		self.down_arrow:setVisible(false)
	else
		self.up_arrow:setVisible(false)
		self.down_arrow:setVisible(true)
		self.down_arrow:runAction(cc.Sequence:create(blink_action, cc.Hide:create()))
	end
end

function WaveController:AddWave(layer, wave_object, z_order, index)
	local index = index or 1
	self.waves[index] = wave_object
	if layer then
		layer:addChild(wave_object, z_order or GAME_Z_ORDER.FOREGROUND)
	end
end

function WaveController:UpdateWaves(dt)
	for _, v in pairs(self.waves) do
		v:Update(dt)
	end
end

function WaveController:InitUpWave(layer)
	local UpWave = require("app.models.UpWave")
    local up_wave_1 = UpWave.new()
    up_wave_1:setPositionX(CONFIG_SCREEN_WIDTH * 0.5)
    self:AddWave(layer, up_wave_1, GAME_Z_ORDER.FOREGROUND, 1)

    local up_wave_2 = UpWave.new()
    up_wave_2:setPositionX(CONFIG_SCREEN_WIDTH * 1.5 - 20)
    self:AddWave(layer, up_wave_2, GAME_Z_ORDER.FOREGROUND, 2)

    up_wave_1:SetGetXFunc(function()
    	return up_wave_2:getPositionX() + CONFIG_SCREEN_WIDTH - 20
    end)

    up_wave_2:SetGetXFunc(function()
    	return up_wave_1:getPositionX() + CONFIG_SCREEN_WIDTH - 20
    end)
end

