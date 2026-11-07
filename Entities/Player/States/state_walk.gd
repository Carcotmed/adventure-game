extends State

@export var state_idle: State
@export var state_roll: State
@export var state_attack: State
@onready var sprite: AnimatedSprite2D = %Sprite

func on_process(delta: float) -> void:
	if Input.is_action_just_pressed("roll"):
		state_manager.change_state(state_roll)
	elif Input.is_action_just_pressed("attack"):
		state_manager.change_state(state_attack)

func on_physics_process(delta: float) -> void:
	var horizontal_axis = Input.get_axis("left", "right")
	var vertical_axis = Input.get_axis("up", "down")
	
	if !horizontal_axis && !vertical_axis:
		state_manager.change_state(state_idle)
	else:
		if sprite.animation != "walk":
			sprite.play("walk")
		
		var direction = Vector2(horizontal_axis, vertical_axis)
		parent.velocity = direction.normalized() * Constants.PLAYER_WALK_SPEED
		parent.move_and_slide()
