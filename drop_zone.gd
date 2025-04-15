extends Marker2D

# Color definitions for aesthetic effects
var empty_color = Color.BLACK
var filled_color = Color.TRANSPARENT
var highlight_color = Color(0.5, 0.5, 0.5, 0.3)
var is_filled = false
var hover_effect = false
var current_component = null

# Draw the drop zone
func _draw():
	draw_rect(Rect2(-75, -75, 150, 150), filled_color if is_filled else empty_color)
	if hover_effect and not is_filled:
		draw_rect(Rect2(-75, -75, 150, 150), highlight_color)

# Called when the drop zone is selected
func select():
	for zone in get_tree().get_nodes_in_group("zone"):
		if zone != self and zone.has_method("deselect"):
			zone.deselect()
	modulate = Color.TRANSPARENT

func deselect():
	modulate = Color.BLACK

# Draggable entered the drop zone
func _on_DragEnter(area):
	if area.is_in_group("draggable") and not is_filled:
		hover_effect = true
		queue_redraw()

# Draggable exited the drop zone
func _on_DragExit(area):
	if area.is_in_group("draggable"):
		hover_effect = false
		queue_redraw()

# Drop event handler
func _on_Drop(area):
	if !area.is_in_group("draggable"):
		print("Error: Not draggable!")
		return

	if is_filled:
		print("Drop rejected: Already filled.")
		return

	is_filled = true
	current_component = area
	hover_effect = false
	queue_redraw()

	# Connect signal for when the component is picked up again
	if area.has_signal("drag_started") and not area.is_connected("drag_started", Callable(self, "_on_DraggablePickedUp")):
		area.connect("drag_started", Callable(self, "_on_DraggablePickedUp"))
	else:
		print("Warning: Draggable missing 'drag_started' signal.")

	print("Component dropped and accepted.")

# When component is picked up again
func _on_DraggablePickedUp():
	print("Component picked up, drop zone cleared.")
	is_filled = false
	current_component = null
	queue_redraw()

# Setup
func _ready():
	if not is_in_group("zone"):
		add_to_group("zone")
	print("Drop zone ready.")
