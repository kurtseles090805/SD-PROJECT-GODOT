extends Node2D

var selected = false
var rest_point: Vector2
var rest_nodes = []
var _drag_offset: Vector2 = Vector2.ZERO
var dropped_into_zone = false  # Track if the component is dropped into a zone
var drag_outline: Color = Color(1, 1, 0, 1)  # Yellow outline when dragging (aesthetic)

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
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = global_position  # Start at the original position

	# Log the rest position (simulating component identification)
	print("Component placed at: ", rest_point)

# Handles mouse button input to start dragging the component
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_drag_offset = global_position - get_global_mouse_position()
			selected = true
			dropped_into_zone = false  # Reset the dropped state when we start dragging

			# Log when dragging starts
			print("Dragging started.")

# Called during the physics process to smoothly move the object (for dragging)
func _physics_process(delta: float) -> void:
	if selected: 
		# Add a subtle scaling effect when dragging (increase size slightly)
		scale = Vector2(1.1, 1.1)  # Slightly increase the scale
		global_position = lerp(global_position, get_global_mouse_position() + _drag_offset, 20 * delta)
		
		# Increase glow effect strength
		glow_strength = lerp(glow_strength, 1.0, 0.1)  # Smooth transition to full glow
	else: 
		# Reset the scale when dropped
		scale = Vector2(1, 1)
		# Smoothly return the object to its resting position (drop zone or original position)
		global_position = lerp(global_position, rest_point, 10 * delta)
		
		# Gradually reduce glow effect when not dragging
		glow_strength = lerp(glow_strength, 0.0, 0.1)  # Fade out glow

	# Optional: If near a drop zone, apply outline or highlight
	highlight_drop_zone()

# Handles mouse button release, checking if the object is near any drop zone to snap to it
func _input(event): 
	if event is InputEventMouseButton: 
		# When the mouse button is released
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed: 
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
					# Check if the closest node has the 'select' function before calling it
					if closest_node.has_method("select"):
						closest_node.select()  # Optional: Visual feedback for the selected drop zone
					rest_point = closest_node.global_position  # Set rest point to the drop zone position
					dropped_into_zone = true  # Mark that the object has been dropped into a zone

			# If the object is near no drop zone, stay where it is
			else:
				rest_point = global_position  # Keep the object where it was last dropped

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
	# Optionally, reset position or handle error logic here
	rest_point = global_position  # Keep the object where it was last dropped
	dropped_into_zone = false  # Reset the drop status
	invalid_drop_attempts += 1  # Increment invalid drop attempts

	# If maximum invalid drops are reached, reset component to start position
	if invalid_drop_attempts >= max_invalid_drops:
		print("Too many invalid drops, resetting to start position.")
		rest_point = Vector2(0, 0)  # Reset to a default position or initial location

# Additional functionality: Check if the correct component is dropped in a valid zone
func _on_drop_area(area: Node) -> void:
	# Only handle drop if it's a valid zone (no component type validation)
	if area.is_in_group("valid_zone"):
		# Component is dropped in a valid zone, allow drop
		print("Component dropped in a valid zone.")
		invalid_drop_attempts = 0  # Reset invalid attempts after a successful drop
	else:
		# Handle error for invalid drop
		handle_invalid_component_drop()
		print("Invalid drop area!")  # Error handling log

# Handle custom event when the component is picked up or moved away from the drop zone
func _on_component_removed_from_zone() -> void:
	# Reset color and position when the component is picked up again
	modulate = Color(1, 1, 1, 1)  # Reset the color to normal (white)
	print("Component picked up from drop zone, reset position.")
	rest_point = global_position  # Restore the component's original position
	dropped_into_zone = false  # Mark that the component is no longer in a zone

# New method to provide feedback when the component is placed in an invalid zone
func provide_invalid_drop_feedback() -> void:
	print("Invalid drop zone! Please place the component in a valid zone.")
	# Optionally, apply an effect like a shake or sound to indicate error
	# Example: Add a shake or a small scale jitter to indicate the invalid action
	scale = Vector2(1.2, 1.2)  # Slightly enlarge the component for visual feedback
	await get_tree().create_timer(0.1).timeout  # Wait for 0.1 seconds
	scale = Vector2(1, 1)  # Return to normal size after a short delay

	# Optionally, add a screen flash effect for better feedback
	# Screen flash or background color change
	var flash = ColorRect.new()
	flash.color = Color(1, 0, 0, 0.3)  # Semi-transparent red color to indicate error
	flash.rect_min_size = get_viewport().size
	get_tree().current_scene.add_child(flash)
	await get_tree().create_timer(0.2).timeout  # Flash duration
	flash.queue_free()  # Remove flash after duration

# Add glowing effect to the component while dragging
func _draw() -> void:
	# Add glowing effect during dragging
	if selected:
		draw_circle(global_position, 20, glow_effect)  # Draw a glowing circle effect around the component
