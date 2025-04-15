extends Control
class_name BaseComponent

@export var component_type := ""
@export var resistance := 1000.0

@onready var terminals := [$Terminal1, $Terminal2]
var connected_wires := []
var is_dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	if not terminals or terminals.size() < 2:
		push_error("Component is missing terminals!")
	
	for i in terminals.size():
		terminals[i].input_event.connect(_on_terminal_event.bind(i))
		terminals[i].add_to_group("component_terminal")
	
	# Ensure component can receive input
	mouse_filter = MOUSE_FILTER_STOP

func _on_terminal_event(_vp, event: InputEvent, _idx, terminal_idx: int):
	if event is InputEventScreenTouch and event.pressed:
		modulate = Color(1, 1, 1, 0.8)
		var circuit_game = get_tree().get_nodes_in_group("circuit_game")[0]
		circuit_game._start_wire_connection(self, terminals[terminal_idx].global_position, terminal_idx)

func _gui_input(event):
	print("Input event received: ", event)
	if event is InputEventScreenTouch:
		if event.pressed:
			print("Drag started")
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
			# Bring to front when dragging starts
			z_index = 1
			get_viewport().set_input_as_handled()
		elif event.released:
			print("Drag ended")
			is_dragging = false
			# Reset z-index when dragging ends
			z_index = 0
			get_viewport().set_input_as_handled()
			
	if event is InputEventScreenDrag and is_dragging:
		print("Dragging to position: ", get_global_mouse_position())
		global_position = get_global_mouse_position() - drag_offset
		# Update connected wires
		for wire in connected_wires:
			if is_instance_valid(wire):
				if wire.connection.start.component == self:
					wire.set_point_position(0, terminals[wire.connection.start.terminal_idx].global_position)
				if wire.connection.end.component == self:
					wire.set_point_position(1, terminals[wire.connection.end.terminal_idx].global_position)
		get_viewport().set_input_as_handled()
