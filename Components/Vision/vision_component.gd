class_name VisionComponent
extends Area2D

signal body_sighted
signal body_lost

@export var line_of_sight_max_length: int = 100
@export var out_of_sight_time: float = 5.0

var line_of_sight: RayCast2D
var out_of_sight_timer: Timer
var detected_body: Player
var is_sighted := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	line_of_sight = RayCast2D.new()
	line_of_sight.enabled = false # only used through force_raycast_update()
	line_of_sight.set_collision_mask_value(1, true)
	line_of_sight.set_collision_mask_value(2, true)
	add_child(line_of_sight)

	out_of_sight_timer = Timer.new()
	out_of_sight_timer.one_shot = true
	add_child(out_of_sight_timer)
	out_of_sight_timer.timeout.connect(_on_timer_timeout)

	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	var sees_player := _can_see(detected_body)
	if not is_sighted:
		if sees_player:
			is_sighted = true
			body_sighted.emit()
		return
	if sees_player:
		out_of_sight_timer.stop()
	elif out_of_sight_timer.is_stopped():
		out_of_sight_timer.start(out_of_sight_time)

func _can_see(body: Node2D) -> bool:
	var to_body := line_of_sight.to_local(body.global_position)
	line_of_sight.target_position = to_body.limit_length(line_of_sight_max_length)
	line_of_sight.force_raycast_update()
	return line_of_sight.get_collider() == body

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	detected_body = body
	out_of_sight_timer.stop()
	set_physics_process(true)

func _on_body_exited(body: Node2D) -> void:
	# If the enemy is already chasing, keep tracking until the timer runs out.
	if body == detected_body and not is_sighted:
		detected_body = null
		set_physics_process(false)

func _on_timer_timeout() -> void:
	is_sighted = false
	body_lost.emit()
	# If the player is still inside the area, keep checking so they can be re-sighted.
	if not overlaps_body(detected_body):
		detected_body = null
		set_physics_process(false)
