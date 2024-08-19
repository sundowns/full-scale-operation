extends AudioStreamPlayer

const bgm = preload("res://audio/sfx/background_music_epic.tres")

func _play_music(effect: SoundEffect):
	if stream == effect.sfx:
		return
		
	stream = effect.sfx
	volume_db = effect.decibels
	play()

func play_sfx(effect: SoundEffect):
	if not effect: return
	assert(effect.sfx)
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = effect.sfx
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = effect.decibels
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func play_sfx_at(effect: SoundEffect, location: Vector3) -> void:
	if not effect: return
	assert(effect.sfx)
	var fx_player = AudioStreamPlayer3D.new()
	fx_player.stream = effect.sfx
	fx_player.volume_db = effect.decibels
	fx_player.max_db = 100
	add_child(fx_player)
	fx_player.global_position = location
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func play_background_music():
	_play_music(bgm)
