extends Camera2D

# Variables for dragging
var dragging = false
var drag_start_position = Vector2()

# Grid and boundary variables
var cell_size = Vector2(64, 64)  # Set your grid cell size
var min_x = -1000  # Set your minimum X boundary
var max_x = 1000   # Set your maximum X boundary
var min_y = -1000  # Set your minimum Y boundary
var max_y = 1000   # Set your maximum Y boundary

func _input(event):
	if event is InputEventMouseButton:
		# Start dragging on left mouse button press
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start_position = event.position
			else:
				dragging = false
		
		# Zoom in/out with mouse wheel
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 1.1  # Zoom in
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 0.9  # Zoom out
	
	elif event is InputEventMouseMotion and dragging:
		# Move the camera while dragging
		var drag_offset = drag_start_position - event.position
		position += drag_offset * zoom
		drag_start_position = event.position
	
	# Snap the camera position to the grid
	position = (position / cell_size).floor() * cell_size
	
	# Clamp the camera position to stay within boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
