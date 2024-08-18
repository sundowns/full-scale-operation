extends AudioStreamPlayer

const bgm = preload("res://audio/Battle-TheOath_loop.ogg")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_sfx(sfx: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = sfx
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
	
func play_background_music():
	print("playing bgm")
	_play_music(bgm, -25)
