class_name MainMenu
extends BaseLevel

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	start_button.disabled = true  # evita doble pulsación
	if not await GameManager.go_to(GameManager.GameState.HUB):
		start_button.disabled = false
		start_button.grab_focus()
