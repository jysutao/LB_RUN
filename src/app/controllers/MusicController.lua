MusicController = class("MusicController")

function MusicController:ctor()
	if MusicController.instance then
		error("[MusicController] attempt to construct instance twice")
	end
	MusicController.instance = self
	self.audio = audio
end

function MusicController:Init()
	self:PreLoadSound({
		MUSIC_TYPE.JUMP, 
		MUSIC_TYPE.DIE,
		MUSIC_TYPE.BEAT,
	})
	audio.setSoundsVolume(0.3)
end

function MusicController:GetMusicName(music_enum)
	if music_enum == MUSIC_TYPE.JUMP then
		return "jump.mp3"
	elseif music_enum == MUSIC_TYPE.DIE then
		return "die.mp3"
	elseif music_enum == MUSIC_TYPE.BEAT then
		return "beat.mp3"
	end	
end

function MusicController:__delete()
	self:UnLoadAllSound()

	MusicController.instance = nil	
end

function MusicController:UnLoadAllSound()
	for i = 1, #self.sound_types do
		local file_name = self:GetMusicName(self.sound_types[i])
		audio.unloadSound(file_name)
	end
end

function MusicController:PreLoadSound(music_enums)
	self.sound_types = music_enums
	for i = 1, #music_enums do
		local file_name = self:GetMusicName(music_enums[i])
		audio.preloadSound(file_name)
	end
end

function MusicController:StopAllSound()
	audio.stopAllSounds()
end

function MusicController:PlaySound(music_enum)
	local file_name = self:GetMusicName(music_enum)
	audio.playSound(file_name)
end