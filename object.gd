extends Node2D

var selected = false
var dragging = false
var offset = Vector2()  # The offset between the mouse and the object when dragging
var snap_radius = 50.0  # The radius in which the object can snap to connection points
var snap_position = Vector2()  # The position where the object should snap to
var connection_points = []  # List of predefined connection points (you can add these manually)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# For example, add some predefined connection points manually
	connection_points = [Vector2(200, 300), Vector2(400, 500), Vector2(600, 200)]  # These would be your circuit's slots

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		# Update the position based on the mouse position, offset by the original drag offset
		position = get_global_mouse_position() - offset
		
	# Visual feedback: Draw a line to show where the object is being dragged to
	if dragging:
		draw_drag_line()

# Input event handler for dragging the object
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Start dragging: set the selected state and calculate the offset
			selected = true
			dragging = true
			offset = get_global_mouse_position() - position
		else:
			# Stop dragging and snap to a connection point if close enough
			dragging = false
			selected = false
			snap_to_nearest_connection()

# Draw a line from the object to the mouse position to visualize the drag
func draw_drag_line() -> void:
	var mouse_pos = get_global_mouse_position()
	draw_line(position, mouse_pos, Color(1, 0, 0), 2)  # Red line, you can change the color

# Check if the object is close to any of the predefined connection points, and snap to the nearest one
func snap_to_nearest_connection() -> void:
	var closest_distance = snap_radius
	var closest_point = position
	
	for point in connection_points:
		var distance = position.distance_to(point)
		if distance < closest_distance:
			closest_distance = distance
			closest_point = point
	
	# If the object is within the snap radius of a connection point, snap it there
	if closest_distance <= snap_radius:
		position = closest_point  # Snap to the nearest connection point
