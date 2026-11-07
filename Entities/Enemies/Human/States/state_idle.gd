extends State

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var idle_timer: Timer = $IdleTimer

@export var state_wandering: State

func _ready() -> void:
	idle_timer.timeout.connect(on_idle_end)

func enter() -> void:
	sprite.play("idle")
	var rand_time = GameManager.random.randf_range(Constants.ENEMY_MIN_IDLE_TIME, Constants.ENEMY_MAX_IDLE_TIME)
	idle_timer.start(rand_time)
	
func on_idle_end() -> void:
	state_manager.change_state(state_wandering)
