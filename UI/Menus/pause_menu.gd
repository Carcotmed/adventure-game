extends Control

@export var resume_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GameManager.game_state_changed.connect(_on_game_state_changed)
	resume_button.pressed.connect(_on_resume_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_resume_button_pressed() -> void:
	GameManager.resume_game()

func _on_game_state_changed(game_paused: bool) -> void:
	visible = game_paused
