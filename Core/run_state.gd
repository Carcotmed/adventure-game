class_name RunState
extends RefCounted

var seed_value: int
var floor_index: int = 0

func _init(p_seed: int = 0) -> void:
	seed_value = p_seed if p_seed != 0 else randi()
