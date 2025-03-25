extends Marker2D

func _draw(): 
	draw_rect(Rect2(-75, -75, 150, 150), Color.BLANCHED_ALMOND)  # Draw a rectangle instead of a circle

func select(): 
	for child in get_tree().get_nodes_in_group("zone"):
		child.deselect()

	modulate = Color.WEB_MAROON

func deselect():
	modulate = Color.WHITE
