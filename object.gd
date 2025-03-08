extends Node2D

var selected = false
var mouse_offset = Vector2(0, 0)
var original_position = Vector2(0, 0)  # Store the original position of the object
var droppable_area = Rect2(Vector2(200, 200), Vector2(100, 100))  # Example droppable area (x, y, width, height)

func _ready():
	original_position = position  # Store the initial position when the object is created

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
			if not droppable_area.has_point(position):
				# Return to the original position if the object was not dropped in the droppable area
				position = original_position
