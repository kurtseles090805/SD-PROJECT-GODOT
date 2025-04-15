extends Control
class_name CircuitGame

# Scene Constants
const COMPONENT_SCENES := {
	"battery": preload("res://scenes/final game scene diff approach (not working)/Scenes/components/BatteryComponent.tscn"),
	"resistor": preload("res://scenes/final game scene diff approach (not working)/Scenes/components/ResistorComponent.tscn"),
	"bulb": preload("res://scenes/final game scene diff approach (not working)/Scenes/components/BulbComponent.tscn")
}
const WIRE_SCENE := preload("res://scenes/final game scene diff approach (not working)/Scenes/Wire.tscn")

# Node References
@onready var canvas: Control = $MainContainer/MainLayout/Canvas
@onready var canvas_bg: ColorRect = $MainContainer/MainLayout/Canvas/ColorRect
@onready var components_panel: Control = $MainContainer/MainLayout/ComponentsPanel
@onready var button_panel: HBoxContainer = $MainContainer/ButtonPanel

# Game State
var current_component: BaseComponent = null
var current_wire: Wire = null
var components: Array = []
var wires: Array = []
var simulating: bool = false

# Drag state
var dragged_component: Control = null
var drag_offset: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("circuit_game")

	# Setup component buttons
	$MainContainer/MainLayout/ComponentsPanel/BatteryButton.pressed.connect(_on_battery_button_pressed)
	$MainContainer/MainLayout/ComponentsPanel/ResistorButton.pressed.connect(_on_resistor_button_pressed)
	$MainContainer/MainLayout/ComponentsPanel/BulbButton.pressed.connect(_on_bulb_button_pressed)

func _on_battery_button_pressed():
	_spawn_component("battery")

func _on_resistor_button_pressed():
	_spawn_component("resistor")

func _on_bulb_button_pressed():
	_spawn_component("bulb")

func _spawn_component(component_type: String):
	var scene = COMPONENT_SCENES.get(component_type)
	if scene:
		var instance = scene.instantiate()
		canvas.add_child(instance)
		instance.position = canvas.get_local_mouse_position()
		components.append(instance)
		instance.mouse_filter = Control.MOUSE_FILTER_STOP  # Needed for mouse interaction

# --- ACTION BUTTON HANDLERS ---
func _on_clear_button_pressed():
	for child in canvas.get_children():
		if child != canvas_bg:
			child.queue_free()
	components.clear()
	wires.clear()
	canvas_bg.color = Color.LIGHT_GRAY
	simulating = false

func _on_start_button_pressed():
	simulating = true
	canvas_bg.color = Color.GREEN if !_has_short_circuit() else Color.RED
	_simulate_circuit()

func _on_stop_button_pressed():
	simulating = false
	canvas_bg.color = Color.LIGHT_GRAY
	_reset_component_states()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging if mouse is over a component
				for component in components:
					if component.get_global_rect().has_point(get_viewport().get_mouse_position()):
						dragged_component = component
						drag_offset = component.global_position - get_viewport().get_mouse_position()
						break
			else:
				# Stop dragging
				dragged_component = null

	elif event is InputEventMouseMotion and dragged_component:
		# Continue dragging
		dragged_component.global_position = get_viewport().get_mouse_position() + drag_offset


func _get_component_at_position(pos: Vector2) -> BaseComponent:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collision_mask = 1 << 0  # Make sure terminals are on correct layer
	
	for result in space.intersect_point(query, 1):
		var collider = result.collider
		if collider.is_in_group("component_terminal"):
			return collider.get_parent().get_parent() # Terminal -> Component
	return null

func _get_terminal_index_at_position(component: BaseComponent, pos: Vector2) -> int:
	for i in range(component.terminals.size()):
		if component.terminals[i].get_global_rect().has_point(pos):
			return i
	return -1

# --- CIRCUIT LOGIC ---
func _has_short_circuit() -> bool:
	# Build connection graph
	var graph = {}
	for wire in wires:
		if !is_instance_valid(wire):
			continue
			
		var start_node = str(wire.connection.start.component.get_instance_id()) + "_" + str(wire.connection.start.terminal_idx)
		var end_node = str(wire.connection.end.component.get_instance_id()) + "_" + str(wire.connection.end.terminal_idx)
		
		if not graph.has(start_node):
			graph[start_node] = []
		graph[start_node].append(end_node)
		
		if not graph.has(end_node):
			graph[end_node] = []
		graph[end_node].append(start_node)
	
	# Check for paths between battery terminals
	for component in components:
		if component is BatteryComponent and is_instance_valid(component):
			var battery = component as BatteryComponent
			var pos_node = str(component.get_instance_id()) + "_" + str(battery.positive_terminal_idx)
			var neg_node = str(component.get_instance_id()) + "_" + str(1 - battery.positive_terminal_idx)
			
			if _path_exists(graph, pos_node, neg_node, []):
				return true
	return false

func _path_exists(graph, start, end, visited) -> bool:
	if start == end:
		return true
	if start in visited:
		return false
		
	visited.append(start)
	
	if not graph.has(start):
		return false
		
	for neighbor in graph[start]:
		if _path_exists(graph, neighbor, end, visited):
			return true
			
	return false

func _simulate_circuit():
	if _has_short_circuit():
		print("Short circuit detected!")
		return
	
	# Simple simulation - show visual feedback
	for component in components:
		if !is_instance_valid(component):
			continue
			
		if component is BatteryComponent:
			component.modulate = Color.YELLOW
		elif component is BulbComponent:
			component.modulate = Color.YELLOW if _is_in_complete_circuit(component) else Color.WHITE

func _is_in_complete_circuit(component: BaseComponent) -> bool:
	# Basic check if component is connected to a battery
	for wire in wires:
		if !is_instance_valid(wire):
			continue
			
		if wire.connection.start.component == component or wire.connection.end.component == component:
			var other_component = wire.connection.start.component if wire.connection.end.component == component else wire.connection.end.component
			if other_component is BatteryComponent:
				return true
			if _is_connected_to_battery(other_component, [component]):
				return true
	return false

func _start_wire_connection(from_component: BaseComponent, terminal_pos: Vector2, terminal_idx: int):
	current_wire = WIRE_SCENE.instantiate()
	current_wire.setup(terminal_pos, from_component, terminal_idx)
	canvas.add_child(current_wire)
	
func _is_connected_to_battery(component: BaseComponent, visited: Array) -> bool:
	if !is_instance_valid(component):
		return false
		
	if component is BatteryComponent:
		return true
		
	visited.append(component)
	
	for wire in wires:
		if !is_instance_valid(wire):
			continue
			
		if wire.connection.start.component == component and not wire.connection.end.component in visited:
			if _is_connected_to_battery(wire.connection.end.component, visited):
				return true
		elif wire.connection.end.component == component and not wire.connection.start.component in visited:
			if _is_connected_to_battery(wire.connection.start.component, visited):
				return true
	return false

func _reset_component_states():
	for component in components:
		if is_instance_valid(component):
			component.modulate = Color.WHITE
	
