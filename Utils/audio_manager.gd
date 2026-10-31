extends Node

const POOL_SIZE := 16

var _pool: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in POOL_SIZE:
		var player := AudioStreamPlayer2D.new()
		add_child(player)
		_pool.append(player)

func play_sfx_at(effect: SoundEffect, position: Vector2) -> void:
	if effect == null:
		return
	var stream := effect.pick_stream()
	if stream == null:
		return
	var player := _get_free_player()
	if player == null:
		return # pool exhausted: drop the sound
	player.stream = stream
	player.global_position = position
	player.volume_db = effect.volume_db
	player.pitch_scale = randf_range(effect.pitch_min, effect.pitch_max)
	player.bus = effect.bus
	player.max_distance = effect.max_distance
	player.attenuation = effect.attenuation
	player.play()

func _get_free_player() -> AudioStreamPlayer2D:
	for player in _pool:
		if not player.playing:
			return player
	return null
