ScoreController = class("ScoreController")

function ScoreController:ctor()
	if ScoreController.instance then
		error("[ScoreController] attempt to construct instance twice")
	end
	ScoreController.instance = self
end

function ScoreController:__delete()
	ScoreController.instance = nil
end

function ScoreController:Init()
	self.score = 0
	self.highest_score = cc.UserDefault:getInstance():getIntegerForKey(STORE_KEY_HIGHEST_SCORE, 0)
end

function ScoreController:CreateScoreLayer(parent_layer, z_order)
	self.score_label = cc.ui.UILabel.new({
            UILabelType = 2, text = self.score, size = 66})
        :align(display.RIGHT_TOP, display.width, display.top)
        :addTo(parent_layer, z_order)
end

function ScoreController:GetHighestScore()
	return self.highest_score
end

function ScoreController:SaveHighestScore(score)
	self.highest_score = score
	cc.UserDefault:getInstance():setIntegerForKey(STORE_KEY_HIGHEST_SCORE, score)
end

function ScoreController:GetScore()
	return self.score
end

function ScoreController:IncScore()
	self.score = self.score + 1
	if self.score_label then
		self.score_label:setString(self.score)
	end
end