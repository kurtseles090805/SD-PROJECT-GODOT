extends Node2D

var selected = false
var mouse_offset = Vector2(0, 0)
var original_position = Vector2(0, 0)

func _ready():
	original_position = position

func _process(delta):
	if selected:
		followMouse()

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		else:
			selected = false
			# Check if overlapping any droppable areas
			var in_droppable = false
			for area in $Area2D.get_overlapping_areas():
				if area.is_in_group("droppable"):
					in_droppable = true
					break
			if not in_droppable:
				position = original_position
