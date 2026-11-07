extends CanvasLayer

var menu_stack: Array[BaseMenu] = []
var menus: Dictionary[StringName, String] = {
	&"pause": "uid://drpcf26x7u1k6",
}

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS

func is_empty() -> bool:
	return menu_stack.is_empty()

func top() -> BaseMenu:
	return null if menu_stack.is_empty() else menu_stack.back()

func has_menu(id: StringName) -> bool:
	for menu in menu_stack:
		if menu.menu_id == id:
			return true
	return false

func push(id: StringName, params: Dictionary = {}) -> BaseMenu:
	if not menus.has(id):
		push_error("MenuManager: no existe el menú '%s'" % id)
		return null
	if has_menu(id):
		return null

	var scene := load(menus[id]) as PackedScene
	var menu := scene.instantiate() as BaseMenu
	menu.menu_id = id

	if not menu_stack.is_empty():
		var below: BaseMenu = menu_stack.back()
		below._on_covered()
		if menu.hides_below:
			below.hide()

	menu_stack.append(menu)
	add_child(menu)
	menu._on_enter(params)
	return menu

func pop() -> void:
	if menu_stack.is_empty():
		return

	var menu: BaseMenu = menu_stack.pop_back()
	menu._on_exit()
	menu.queue_free()

	if not menu_stack.is_empty():
		var below: BaseMenu = menu_stack.back()
		below.show()
		below._on_uncovered()

func clear() -> void:
	while not menu_stack.is_empty():
		pop()
