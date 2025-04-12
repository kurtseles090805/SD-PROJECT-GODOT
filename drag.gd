extends Node2D

var selected = false
var rest_point: Vector2
var rest_nodes = []
var _drag_offset: Vector2 = Vector2.ZERO
var dropped_into_zone = false  # Track if the component is dropped into a zone

# Electronic component variables
var error_color: Color = Color(1, 0, 0, 1)  # Red color for error feedback

# Track invalid drop attempts
var invalid_drop_attempts = 0
var max_invalid_drops = 3  # Set a limit for how many invalid drops are allowed

# Glowing effect during dragging
var glow_effect: Color = Color(1, 1, 0, 0.5)  # Glowing yellow for aesthetic
var glow_strength: float = 0.0  # For controlling glow intensity

# Called when the node enters the scene tree for the first time
func _ready(): 
	# Get nodes in "zone" group (drop zones)
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = global_position  # Start at the original position

	# Set the mouse filter to allow interaction with this object (collision with mouse)
	set_process_input(true)  # Start processing input events

	# Log the rest position (simulating component identification)
	print("Component placed at: ", rest_point)

# Handles mouse button input to start dragging the component
func _input(event): 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if the mouse click is inside the bounds of the node (based on its position and size)
			if is_mouse_inside(event.position):
				_drag_offset = global_position - get_global_mouse_position()
				selected = true
				dropped_into_zone = false  # Reset the dropped state when we start dragging
				print("Dragging started.")
			else:
				print("Mouse click not on the object.")
		elif not event.pressed:
			selected = false
			# If the component was not already dropped into a zone, we check for snapping
			if not dropped_into_zone:
				var shortest_dist = 150  # Maximum distance for snapping to a zone
				var closest_node = null
				
				# Loop through all drop zones to find the closest one
				for child in rest_nodes: 
					var distance = global_position.distance_to(child.global_position) 
					if distance < shortest_dist:
						closest_node = child
						shortest_dist = distance
					
				# If a drop zone is found, snap the object to it
				if closest_node:
					rest_point = closest_node.global_position  # Set rest point to the drop zone position
					dropped_into_zone = true  # Mark that the object has been dropped into a zone

			# If the object is near no drop zone, keep it where it was dropped
			else:
				rest_point = global_position  # Keep the object where it was last dropped

# Helper function to check if the mouse is inside the bounds of the component
func is_mouse_inside(mouse_position: Vector2) -> bool:
	var size = get_size()  # Get the size of the node (you can adjust this based on your node's shape)
	var rect = Rect2(global_position - size / 2, size)  # Define the bounding box around the node
	return rect.has_point(mouse_position)  # Check if the mouse is inside the bounding box

# Helper function to get the size of the component
func get_size() -> Vector2:
	# You can adjust this part based on how your node's size is defined.
	# If you have a texture, you can use texture size. For now, we will assume a default size.
	return Vector2(64, 64)  # Adjust the size accordingly to your node's dimensions

# Called during the physics process to smoothly move the object (for dragging)
func _process(delta: float): 
	if selected: 
		# Update the position based on the mouse position
		global_position = get_global_mouse_position() + _drag_offset
		
		# Optionally, add a subtle scaling effect while dragging
		scale = Vector2(1.1, 1.1)  # Slightly increase the scale
		glow_strength = lerp(glow_strength, 1.0, 0.1)  # Smooth transition to full glow
	else: 
		# Reset the scale when dropped
		scale = Vector2(1, 1)
		# Smoothly return the object to its resting position (drop zone or original position)
		global_position = lerp(global_position, rest_point, 10 * delta)
		glow_strength = lerp(glow_strength, 0.0, 0.1)  # Fade out glow

	# Highlight drop zones when dragging
	highlight_drop_zone()

# Highlight drop zones when the draggable object is over them
func highlight_drop_zone():
	var closest_node = null
	var shortest_dist = 150  # Maximum distance for highlighting
	# Loop through all drop zones to find the closest one
	for child in rest_nodes: 
		var distance = global_position.distance_to(child.global_position) 
		if distance < shortest_dist:
			closest_node = child
			shortest_dist = distance

	# Highlight the closest drop zone
	if closest_node and closest_node.has_method("highlight"):
		closest_node.highlight()  # Custom function to apply visual feedback (e.g., border, color change)

# Custom method for drop zones to apply highlighting
func highlight():
	modulate = Color(0, 1, 0, 0.5)  # Example: Set a transparent green color when highlighted

# Error handling for invalid drop zone
func handle_invalid_component_drop() -> void:
	modulate = error_color  # Change color to red to indicate an error
	print("Error: Invalid drop area!")  # Debug message
	rest_point = global_position  # Keep the object where it was last dropped
	dropped_into_zone = false  # Reset the drop status
	invalid_drop_attempts += 1  # Increment invalid drop attempts

	# If maximum invalid drops are reached, reset component to start position
	if invalid_drop_attempts >= max_invalid_drops:
		print("Too many invalid drops, resetting to start position.")
		rest_point = Vector2(0, 0)  # Reset to a default position or initial location

# Add glowing effect to the component while dragging
func _draw() -> void:
	# Add glowing effect during dragging
	if selected:
		draw_circle(global_position, 20, glow_effect)  # Draw a glowing circle effect around the component
