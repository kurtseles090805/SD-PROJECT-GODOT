extends Node2D

# If the object is selected for dragging
var selected = false  

# The point where the object will rest after dragging (resting position)
var rest_point = Vector2.ZERO  

# List of all drop zones (nodes in group "zone")
var rest_nodes = []  

# Offset between the mouse position and object center during dragging
var _drag_offset: Vector2 = Vector2.ZERO  

# Called when the node enters the scene tree for the first time.
func _ready(): 
	# Get all nodes in the "zone" group (these will be the drop zones)
	rest_nodes = get_tree().get_nodes_in_group("zone")
	
	# Ensure there's at least one drop zone
	if rest_nodes.is_empty():
		push_error("No nodes found in group 'zone'.")
		return
	
	# Set initial rest point to the first node's position (first drop zone)
	rest_point = rest_nodes[0].global_position

# Called when the input event happens in an Area2D (e.g., mouse click)
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Check if the left mouse button was pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Start dragging the object, calculate the offset from the mouse click to object position
			_drag_offset = global_position - get_global_mouse_position()
			selected = true

# Called during the physics process (for smooth movement of the object)
func _physics_process(delta: float) -> void:
	if selected: 
		# Smoothly move the object towards the mouse position, considering the drag offset
		var target_pos = get_global_mouse_position() + _drag_offset
		global_position = lerp(global_position, target_pos, 20 * delta)  # Faster lerp for better accuracy
	else: 
		# Smoothly return the object to the rest point (drop zone or initial position)
		global_position = lerp(global_position, rest_point, 10 * delta)

# Handles mouse button release and determines which drop zone to snap to
func _input(event): 
	if event is InputEventMouseButton: 
		# When the mouse button is released
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed: 
			selected = false
			# Check if the object is near any drop zone
			if rest_nodes.size() > 0:
				var shortest_dist = 150  # Define the maximum distance to snap to a zone
				var closest_node = null
				# Loop through all drop zones to find the closest one
				for child in rest_nodes: 
					var distance = global_position.distance_to(child.global_position) 
					if distance < shortest_dist:
						closest_node = child
						shortest_dist = distance
				# If a valid drop zone is found, snap to it
				if closest_node:
					closest_node.select()  # Optional: Add visual feedback for the selected drop zone
					rest_point = closest_node.global_position  # Set rest point to the drop zone position
