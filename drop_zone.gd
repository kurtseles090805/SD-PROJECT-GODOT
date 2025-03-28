extends Marker2D

# Aesthetic color definitions
var empty_color = Color(0.2, 0.2, 0.2)  # Dark gray for empty state
var filled_color = Color(0.5, 0.8, 0.2)  # Green when filled
var highlight_color = Color(0.8, 0.8, 0.8, 0.5)  # Semi-transparent gray for highlighting when hovering

# State tracking variables
var is_filled = false  # Track if a component is placed
var hover_effect = false  # Track if the drop zone is being hovered by a draggable component

# Define the drop zone rectangle area (position and size)
var drop_zone_rect = Rect2(-75, -75, 150, 150)  # Dimensions for the drop zone

# Called when the node is drawn
func _draw():
	# Rounded corner radius for the drop zone
	var corner_radius = 20
	# Draw the rectangle with rounded corners based on the filled state
	if is_filled:
		# Use lerp to create a smooth transition between two shades of green
		var lighter_green = filled_color.lerp(Color(0.4, 0.8, 0.1), 0.3)  # Lighter green at the top
		draw_rect(drop_zone_rect, lighter_green)  # Draw with the lighter shade when filled
	else:
		# Add a subtle effect for the empty state using lerp for a smoother transition
		var darker_gray = empty_color.lerp(Color(0.1, 0.1, 0.1), 0.3)  # Darker at the bottom
		draw_rect(drop_zone_rect, darker_gray)  # Draw with the darker shade for empty

	# Add hover effect with a slight shadow and soft border for better user experience
	if hover_effect:
		var hover_shadow_color = Color(0.8, 0.8, 0.8, 0.3)  # Soft shadow when hovered
		var shadow_rect = drop_zone_rect.grow(5)  # Grow only once
		# Draw shadow effect
		draw_rect(shadow_rect, hover_shadow_color)
		# Draw the highlight effect with a soft border
		draw_rect(drop_zone_rect, highlight_color)

# Called when the drop zone is selected
func select():
	# Deselect other zones
	for zone in get_tree().get_nodes_in_group("zone"):
		if zone != self and zone.has_method("deselect"):
			zone.deselect()  # Call deselect only if the method exists
	
	modulate = Color.TRANSPARENT  # Semi-transparent white when selected to indicate focus

# Called when the drop zone is deselected
func deselect():
	modulate = Color.BLACK  # Fully opaque when deselected (default)

# Called when a draggable component enters the drop zone
func _on_DragEnter(area):
	# Check if the entered area is draggable and zone is not filled
	if area.is_in_group("draggable") and not is_filled:
		hover_effect = true  # Temporarily show hover effect
		queue_redraw()  # Request a redraw to reflect the change
		print("Hovering over drop zone.")  # Debug message
	else:
		# If the area is not draggable or zone is already filled, print an error message
		if not area.is_in_group("draggable"):
			print("Error: The entered area is not draggable!")  # Error handling
		elif is_filled:
			print("Warning: Drop zone is already filled!")  # Warning when zone is filled

# Called when a draggable component exits the drop zone
func _on_DragExit(area):
	# Reset hover effect if the draggable component leaves without being dropped
	if area.is_in_group("draggable"):
		hover_effect = false
		queue_redraw()  # Request a redraw to reflect the change
		print("Exited drop zone.")  # Debug message
	else:
		print("Exited drop zone, but no draggable component was detected.")  # Debug message

# Called when a draggable component is dropped into the drop zone
func _on_DropHandler(area):
	# Check if the component is within the bounds of the drop zone rectangle
	if area.is_in_group("draggable") and not is_filled:
		if drop_zone_rect.has_point(area.global_position - global_position):
			# Permanently mark the zone as filled when a component is dropped
			is_filled = true
			hover_effect = false  # Stop hovering effect after drop
			queue_redraw()  # Request a redraw to reflect the change

			# Connect to the draggable's signal to detect when it's picked up again
			if area.has_signal("drag_started"):
				var signal_callable = Callable(self, "_on_DraggablePickedUp")
				if area.connect("drag_started", signal_callable):
					print("Connected drag_started signal.")
				else:
					print("Error: Failed to connect drag_started signal.")  # Error handling
			else:
				print("Warning: The draggable object does not have the 'drag_started' signal connected.")  # Missing signal warning
		else:
			print("Error: Drop failed, component is out of bounds.")  # Error handling for out-of-bounds drop
	else:
		if is_filled:
			print("Error: Drop zone is already filled, cannot drop.")  # Error handling if zone is filled

# When the draggable component is picked up, reset the drop zone color
func _on_DraggablePickedUp():
	# Reset drop zone when the component is picked up
	is_filled = false
	queue_redraw()  # Request a redraw to reflect the change
	print("Draggable component picked up again, reset drop zone.")  # Debug message

# Add extra error handling to ensure the drop zone is functional
func _ready():
	# Ensure the node is part of the "zone" group
	if not is_in_group("zone"):
		print("Warning: This drop zone is not in the 'zone' group.")  # Error message
		add_to_group("zone")
		
	# Log to ensure the node is initialized correctly
	print("Drop zone is ready.")

# Add extra error handling for the draggable item
func _on_Drop(area):
	# Ensure the dropped area is draggable
	if not area.is_in_group("draggable"):
		print("Error: Dropped area is not draggable!")  # Error handling
		return

	# Proceed with the rest of the drop logic if valid
	if not is_filled:
		# Check if the component is within the bounds of the drop zone rectangle
		if drop_zone_rect.has_point(area.global_position - global_position):
			is_filled = true
			hover_effect = false
			queue_redraw()

			# Safely connect to the signal, check if the signal exists
			if area.has_signal("drag_started"):
				var signal_callable = Callable(self, "_on_DraggablePickedUp")
				if area.connect("drag_started", signal_callable):
					print("Connected drag_started signal after drop.")
				else:
					print("Error: Failed to connect drag_started signal after drop.")  # Error handling
		else:
			print("Error: Drop failed, component is out of bounds.")  # Error handling for out-of-bounds drop
	else:
		print("Error: Drop zone is already filled!")  # Error handling if zone is filled
