extends Node2D

# Optionally, you can handle signals here if you want to know when something enters or exits the area
func _ready():
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Handle entering the droppable area if needed
			pass
		else:
			# Handle exiting the droppable area if needed
			pass
