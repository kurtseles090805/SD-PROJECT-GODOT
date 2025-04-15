extends Control

# Nodes
@onready var components_container = $"COMPONENTS CONTROL"
@onready var dropzones_container = $"DROP ZONE CONTROL"
@onready var pause_button = $PAUSE
@onready var show_circuit_button = $"Show circuit"

# Drag tracking
var dragged_component: Node = null

func _ready() -> void:
	# Connect UI buttons
	pause_button.pressed.connect(_pause_Tab)
	show_circuit_button.pressed.connect(_show_Circuit_Clue)

	# Connect component signals
	for component in components_container.get_children():
		if component.has_signal("dropped_on_zone"):
			component.dropped_on_zone.connect(_on_component_dropped)

func _pause_Tab() -> void: 
	get_tree().change_scene_to_file("res://PauseTab.tscn")

func _show_Circuit_Clue() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitClue.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if dragged_component:
			var drop_zone := get_drop_zone_under_mouse()
			if drop_zone:
				dragged_component._on_drop_zone_detected(drop_zone)
				drop_zone.set_component(dragged_component)
			dragged_component = null

func get_drop_zone_under_mouse() -> Node:
	var mouse_pos = get_viewport().get_mouse_position()
	for dz in dropzones_container.get_children():
		if dz.get_global_rect().has_point(mouse_pos):
			return dz
	return null

func _on_component_dropped(component: Node, drop_zone: Node) -> void:
	print("Component dropped on zone: ", drop_zone.name)
