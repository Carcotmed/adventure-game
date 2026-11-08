class_name GameCamera
extends Camera2D

var default_target: Node2D
var _focus: Variant = null   # Node2D, Vector2 o null


func _ready() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = 6.0
	zoom = Vector2(2, 2)
	CameraManager.register(self)


func _exit_tree() -> void:
	CameraManager.unregister(self)


func _physics_process(_delta: float) -> void:
	var pos: Variant = _get_target_position()
	if pos != null:
		global_position = pos


func focus(target: Variant, duration: float = 0.0) -> void:
	_focus = target
	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		if _focus == target:   # si hubo otro enfoque entremedias, no lo pises
			release()


func release() -> void:
	_focus = null


func snap() -> void:
	var pos: Variant = _get_target_position()
	if pos != null:
		global_position = pos
		reset_smoothing()


func set_room_limits(rect: Rect2) -> void:
	limit_left = int(rect.position.x)
	limit_top = int(rect.position.y)
	limit_right = int(rect.end.x)
	limit_bottom = int(rect.end.y)


func _get_target_position() -> Variant:
	if _focus is Vector2:
		return _focus
	if is_instance_valid(_focus):
		return _focus.global_position
	_focus = null   # el nodo enfocado se liberó: vuelve al por defecto
	if is_instance_valid(default_target):
		return default_target.global_position
	return null
