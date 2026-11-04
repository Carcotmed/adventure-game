extends Node

var random = RandomNumberGenerator.new()

var game_paused := false
signal game_state_changed(game_paused: bool)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause_game() -> void:
	game_paused = true
	get_tree().paused = true
	game_state_changed.emit(game_paused)
	
func resume_game() -> void:
	game_paused = false
	get_tree().paused = false
	game_state_changed.emit(game_paused)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if game_paused:
			resume_game()
		else:
			pause_game()
