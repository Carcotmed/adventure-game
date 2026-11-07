extends Node

signal level_changed(level: Node)

var world: Node
var transition: Node   # con fade_out() y fade_in() que se pueden esperar con await
var current_level: Node

var _busy: bool = false


func is_busy() -> bool:
	return _busy


## Devuelve true si el nivel se cargó correctamente.
func change_level(path: String, params: Dictionary = {}) -> bool:
	if _busy:
		return false

	if not ResourceLoader.exists(path):
		push_error("LevelManager: no existe '%s'" % path)
		return false
	var packed := load(path) as PackedScene
	if packed == null:
		push_error("LevelManager: no se pudo cargar '%s'" % path)
		return false

	_busy = true

	await transition.fade_out()

	if current_level:
		current_level.queue_free()
		await current_level.tree_exited
		current_level = null

	var level := packed.instantiate()
	if level is BaseLevel:
		level.setup(params)       # antes de add_child
	world.add_child(level)
	current_level = level
	level_changed.emit(level)

	await transition.fade_in()
	_busy = false
	return true
