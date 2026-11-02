class_name SoundEffect
extends Resource

@export var streams: Array[AudioStream] = []
@export_range(-40.0, 6.0) var volume_db: float = 0.0
@export_range(0.5, 2.0) var pitch_min: float = 0.95
@export_range(0.5, 2.0) var pitch_max: float = 1.05
@export var bus: StringName = &"SFX"
@export var max_distance: float = 600.0
@export var attenuation: float = 1.0

var _last_index := -1

func pick_stream() -> AudioStream:
	if streams.is_empty():
		return null
	if streams.size() == 1:
		return streams[0]
	var index := randi() % streams.size()
	if index == _last_index:
		index = (index + 1) % streams.size()
	_last_index = index
	return streams[index]
