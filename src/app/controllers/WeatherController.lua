require("app.models.Weather")

WeatherController = class("WeatherController")

function WeatherController:ctor()
	if WeatherController.instance then
		error("[WeatherController] attempt to construct instance twice")
	end
	WeatherController.instance = self

	self.total_time = 0
	self.state = GAME_STATE.READY
end

function WeatherController:__delete()
	WeatherController.instance = nil
end

function WeatherController:Update(dt)
	if self.state == GAME_STATE.START then
		self.total_time = self.total_time + dt
		if self.total_time > 10 then -- 多少秒变一次黑夜
			self.weather_black:UpdateState(WEATHER_STATE.HAPPEN) 
			self.total_time = 0
		end
	end
end

function WeatherController:UpdateState(state)
	self.total_time = 0
	self.state = state
	if self.state == GAME_STATE.END then
		self.weather_black:UpdateState(WEATHER_STATE.REMOVE)
	end
end

function WeatherController:InitWeathers(layer, z_order)
	self.weather_black = WeatherBlack.new()
	layer:addChild(self.weather_black, z_order)
end