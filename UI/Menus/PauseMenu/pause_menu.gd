extends BaseMenu

@export var resume_button: Button

func _ready() -> void:
	resume_button.pressed.connect(_close)

func _on_enter(_params: Dictionary) -> void:
	GameManager.request_pause(&"pause_menu")
	resume_button.grab_focus()

func _on_covered() -> void:
	set_process_unhandled_input(false)

func _on_uncovered() -> void:
	set_process_unhandled_input(true)
	resume_button.grab_focus()  # luego: el botón que abrió el menú tapador

func _on_exit() -> void:
	GameManager.release_pause(&"pause_menu")
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"pause"):
		get_viewport().set_input_as_handled()
		_close()

func _close() -> void:
	MenuManager.pop()
