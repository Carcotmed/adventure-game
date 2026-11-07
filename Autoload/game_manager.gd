extends Node

enum GameState { BOOT, MAIN_MENU, HUB, EXPEDITION, RESULTS }

signal state_changed(old_state: GameState, new_state: GameState)
signal pause_changed(is_paused: bool)

# Único sitio con las rutas de los niveles. Cambia estas por tus rutas o UIDs.
const LEVELS: Dictionary = {
	GameState.MAIN_MENU: "uid://dmltc0cnfnpk3",
	#GameState.HUB: "res://world/hub/hub.tscn",
	#GameState.EXPEDITION: "res://world/expedition/expedition.tscn",
	#GameState.RESULTS: "res://ui/levels/results.tscn",
}

# Transiciones permitidas: de dónde se puede ir desde cada estado.
const ALLOWED: Dictionary = {
	GameState.BOOT: [GameState.MAIN_MENU],
	GameState.MAIN_MENU: [GameState.HUB],
	GameState.HUB: [GameState.MAIN_MENU, GameState.EXPEDITION],
	GameState.EXPEDITION: [GameState.RESULTS, GameState.HUB, GameState.MAIN_MENU],
	GameState.RESULTS: [GameState.HUB, GameState.MAIN_MENU],
}

var state: GameState = GameState.BOOT
var run: RunState = null  # null fuera de expedición/resultados

var _pause_reasons: Dictionary[StringName, bool] = {}


func _ready() -> void:
	LevelManager.level_changed.connect(_on_level_changed)


# --- Estados -----------------------------------------------------------

## Devuelve true si el cambio se realizó.
func go_to(new_state: GameState, params: Dictionary = {}) -> bool:
	if not LEVELS.has(new_state):
		push_error("Game: el estado %s no tiene escena" % GameState.keys()[new_state])
		return false
	if not _can_transition(state, new_state):
		push_warning("Game: transición no permitida %s -> %s" % [
			GameState.keys()[state], GameState.keys()[new_state]])
		return false
	if LevelManager.is_busy():
		return false

	# Limpiar lo transitorio.
	MenuManager.clear()
	_pause_reasons.clear()
	get_tree().paused = false

	# Preparar datos antes de cargar, para que el nivel ya los vea en setup().
	var previous_run := run
	match new_state:
		GameState.EXPEDITION:
			run = RunState.new(params.get("seed", 0))
		GameState.HUB, GameState.MAIN_MENU:
			run = null
		# RESULTS conserva el run actual.

	var ok: bool = await LevelManager.change_level(LEVELS[new_state], params)
	if not ok:
		run = previous_run
		return false

	var old := state
	state = new_state
	state_changed.emit(old, new_state)
	return true


func _can_transition(from: GameState, to: GameState) -> bool:
	return ALLOWED.has(from) and to in ALLOWED[from]


func _on_level_changed(level: Node) -> void:
	if level is BaseLevel:
		level.finished.connect(_on_level_finished, CONNECT_ONE_SHOT)


func _on_level_finished(result: Dictionary) -> void:
	match state:
		GameState.EXPEDITION:
			go_to(GameState.RESULTS, result)
		GameState.RESULTS:
			go_to(GameState.HUB)


# --- Pausa por razones -------------------------------------------------

func request_pause(reason: StringName) -> void:
	_pause_reasons[reason] = true
	_apply_pause()


func release_pause(reason: StringName) -> void:
	_pause_reasons.erase(reason)
	_apply_pause()


func is_paused() -> bool:
	return not _pause_reasons.is_empty()


func _apply_pause() -> void:
	var paused := not _pause_reasons.is_empty()
	if get_tree().paused != paused:
		get_tree().paused = paused
		pause_changed.emit(paused)
