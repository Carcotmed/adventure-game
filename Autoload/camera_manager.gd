extends Node

var active: GameCamera


func register(camera: GameCamera) -> void:
	active = camera


func unregister(camera: GameCamera) -> void:
	if active == camera:
		active = null


func set_default_target(target: Node2D) -> void:
	if active:
		active.default_target = target


## Se puede esperar: await CameraManager.focus(door, 1.5)
func focus(target: Variant, duration: float = 0.0) -> void:
	if active:
		await active.focus(target, duration)


func release() -> void:
	if active:
		active.release()


func snap() -> void:
	if active:
		active.snap()


func set_room_limits(rect: Rect2) -> void:
	if active:
		active.set_room_limits(rect)
