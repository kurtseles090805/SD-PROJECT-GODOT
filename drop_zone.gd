extends Marker2D

# Color definitions for aesthetic effects
var empty_color = Color.BLACK  # Visible when empty
var filled_color = Color.TRANSPARENT  # Transparent when filled
var highlight_color = Color(0.5, 0.5, 0.5, 0.3)  # Semi-transparent gray for highlighting when hovering
var is_filled = false  # Track if a component is placed
var hover_effect = false  # Track if the drop zone is being hovered by a draggable component
var current_component = null  # The component placed in the zone

# Called when the node is drawn
func _draw():
	if is_filled:
		draw_rect(Rect2(-75, -75, 150, 150), filled_color)  # Transparent if filled
	else:
		draw_rect(Rect2(-75, -75, 150, 150), empty_color)  # Black if empty
	
	# Add hover effect for better user experience
	if hover_effect and !is_filled:
		draw_rect(Rect2(-75, -75, 150, 150), highlight_color)  # Highlighted when hovered

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
	if area.is_in_group("draggable") and !is_filled:
		# Temporarily mark the zone as filled while dragging over
		hover_effect = true
		queue_redraw()  # Request a redraw to reflect the change

# Called when a draggable component exits the drop zone
func _on_DragExit(area):
	if area.is_in_group("draggable"):
		# Reset if the draggable component leaves without being dropped
		hover_effect = false
		queue_redraw()  # Request a redraw to reflect the change

# Called when a draggable component is dropped into the drop zone
func _on_DropHandler(area):
	if area.is_in_group("draggable") and !is_filled:
		# Mark the zone as filled when a component is dropped
		is_filled = true
		current_component = area  # Track the dropped component
		hover_effect = false  # Stop hover effect after drop
		queue_redraw()  # Request a redraw to reflect the change

		# Connect to the draggable's signal to detect when it's picked up again
		if area.has_signal("drag_started"):
			area.connect("drag_started", Callable(self, "_on_ComponentPickedUp"))
		else:
			print("Warning: The draggable object does not have the 'drag_started' signal connected.")

# When the draggable component is picked up, reset the drop zone color and remove connections
func _on_ComponentPickedUp():
	if current_component:
		# Reset the zone when the component is picked up again
		is_filled = false
		current_component = null  # Reset the reference to the placed component
		queue_redraw()  # Request a redraw to reflect the change

		# Handle removal from the circuit, or reset connections if applicable
		_disconnect_component()

# Function to handle the component being removed from the drop zone
func _disconnect_component():
	if current_component:
		# Disconnect connections with other components here if your game has any logic for it
		print("Component removed from breadboard, resetting connections.")
		# Additional logic to handle removal from the circuit goes here

# Handling connections between components on the breadboard
func _connect_components(component_a, component_b):
	print("Connecting components:", component_a, "->", component_b)

# Called externally when the simulation starts
func check_status():
	if is_filled:
		modulate = Color(0, 1, 0)  # Green if filled
	else:
		modulate = Color(1, 0, 0)  # Red if empty

# Extra error handling to ensure the drop zone is functional
func _ready():
	# Ensure the node is part of the "zone" group
	if not is_in_group("zone"):
		print("Warning: This drop zone is not in the 'zone' group.")
		add_to_group("zone")
	
	print("Drop zone is ready.")

# Additional drop logic
func _on_Drop(area):
	if not area.is_in_group("draggable"):
		print("Error: Dropped area is not draggable!")
		return

	# Prevent dropping if the zone is already filled
	if is_filled:
		print("Error: This drop zone is already filled. Only one component can be placed here.")
		return

	# Proceed with the rest of the drop logic if valid
	is_filled = true
	hover_effect = false
	current_component = area  # Track the dropped component
	queue_redraw()

	if area.has_signal("drag_started"):
		area.connect("drag_started", Callable(self, "_on_ComponentPickedUp"))
	else:
		print("Warning: Draggable component is missing the 'drag_started' signal.")
