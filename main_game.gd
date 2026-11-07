extends Node

@onready var world: Node = $World
@onready var transition: Node = $TransitionLayer

func _ready() -> void:
	LevelManager.world = world
	LevelManager.transition = transition
	GameManager.go_to(GameManager.GameState.MAIN_MENU)
