extends Area2D  # Use Area2D for collision detection

# Color definitions
var empty_color = Color.BLACK
var filled_color = Color.TRANSPARENT
var highlight_color = Color(0.5, 0.5, 0.5, 0.3)  # Semi-transparent gray
var is_filled = false
var hover_effect = false
var current_component = null  # Track the component placed in this zone

func _draw():
	if is_filled:
		draw_rect(Rect2(-75, -75, 150, 150), filled_color)
	else:
		draw_rect(Rect2(-75, -75, 150, 150), empty_color)
	
	if hover_effect && !is_filled:
		draw_rect(Rect2(-75, -75, 150, 150), highlight_color)

func select():
	for zone in get_tree().get_nodes_in_group("zone"):
		if zone != self:
			zone.deselect()
	modulate = Color(1, 1, 1, 0.5)

func deselect():
	modulate = Color.WHITE

# When a draggable area enters the drop zone
func _on_area_entered(area):
	if area.is_in_group("draggable") and !is_filled and area.get_parent() == null:
		hover_effect = true
		queue_redraw()

# When a draggable area exits the drop zone
func _on_area_exited(area):
	if area.is_in_group("draggable"):
		hover_effect = false
		queue_redraw()

# When a component is dropped into the zone
func _on_dropped(component):
	if !is_filled and component.is_in_group("draggable"):
		# Adopt the component and mark as filled
		component.get_parent().remove_child(component)
		add_child(component)
		component.position = Vector2.ZERO
		is_filled = true
		hover_effect = false
		current_component = component  # Track the placed component
		queue_redraw()

		# Connect pickup signal to handle when the component is removed
		if component.has_signal("picked_up"):
			component.connect("picked_up", _on_component_removed)

# When the component is picked up, reset the drop zone
func _on_component_removed():
	is_filled = false
	current_component = null  # Reset the reference to the placed component
	queue_redraw()

func _ready():
	add_to_group("zone")
	# Connect input signals
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
