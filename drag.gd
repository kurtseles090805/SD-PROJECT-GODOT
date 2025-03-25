extends Node2D

var selected = false 
var rest_point = Vector2.ZERO  # Ensure it's always a valid Vector2
var rest_nodes = [] 

func _ready(): 
	rest_nodes = get_tree().get_nodes_in_group("zone")

	if rest_nodes.size() > 0:
		rest_point = rest_nodes[0].global_position
		rest_nodes[0].select()
	else:
		print("Error: No nodes found in group 'zone'.")

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected = true
		global_position = get_global_mouse_position()  # Instantly move to click position

func _physics_process(delta: float) -> void:
	if selected: 
		# Lerp towards the global mouse position
		global_position = lerp(global_position, get_global_mouse_position(), 0.3)  # Faster lerp for better accuracy
		look_at(get_global_mouse_position())
	else: 
		# Ensure rest_point is valid
		global_position = lerp(global_position, rest_point, 0.2)  # Smoother return to rest point
		rotation = lerp_angle(rotation, 0, 10 * delta)

func _input(event): 
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed: 
			selected = false
			if rest_nodes.size() > 0:
				var shortest_dist = 75
				var closest_node = null
				for child in rest_nodes: 
					var distance = global_position.distance_to(child.global_position) 
					if distance < shortest_dist: 
						closest_node = child
						shortest_dist = distance
				if closest_node:
					closest_node.select() 
					rest_point = closest_node.global_position
