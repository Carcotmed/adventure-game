class_name TransitionLayer
extends CanvasLayer

const DURATION: float = 0.3

@onready var color_rect: ColorRect = %ColorRect

var _tween: Tween


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	color_rect.color.a = 0.0
	hide()


## Transparente -> negro.
func fade_out() -> void:
	show()
	await _fade_to(1.0)


## Negro -> transparente.
func fade_in() -> void:
	await _fade_to(0.0)
	hide()


func _fade_to(target_alpha: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(color_rect, "color:a", target_alpha, DURATION)
	await _tween.finished
