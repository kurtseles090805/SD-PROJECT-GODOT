extends GraphFrame  # Extend GraphFrame

var rest_point: Vector2
var rest_nodes = []  # Stores the drop zones
var dropped_into_zone = false  # Track if the component is dropped into a zone

# Electronic component variables
var error_color: Color = Color(1, 0, 0, 1)  # Red color for error feedback

# Glowing effect during simulation
var glow_effect: Color = Color(1, 1, 0, 0.5)  # Glowing yellow for aesthetic
var glow_strength: float = 0.0  # For controlling glow intensity

# New variables for simulation
var simulation_start = false  # Flag for simulation start
var current_position = 0.0  # To animate the flow of the current along the path

# Called when the node enters the scene tree for the first time
func _ready(): 
	rest_nodes = get_tree().get_nodes_in_group("zone")  # Get all nodes in the "zone" group
	rest_point = global_position  # Set original position

	# Log the rest position (simulating component identification)
	print("Component placed at: ", rest_point)

# Check if component is inside any drop zone when simulation starts
func _physics_process(delta: float) -> void:
	# If simulation is active, check if component is in any drop zone
	if simulation_start:
		var glowing = false
		for child in rest_nodes:
			if global_position.distance_to(child.global_position) < 150:  # Inside the drop zone
				glowing = true
				break

		# If component is inside a drop zone, light it up
		if glowing:
			glow_strength = lerp(glow_strength, 1.0, 0.1)  # Smooth glow
		else:
			glow_strength = lerp(glow_strength, 0.0, 0.1)  # Fade glow when not inside drop zone

# Start simulation when the start button is pressed
func _on_start_simulation_pressed() -> void:
	# Start the simulation by setting simulation_start to true
	simulation_start = true
	
	# Optionally, you could add some effect or feedback when the simulation starts
	# For example, change the color of the component to indicate simulation mode
	modulate = Color(1, 0, 0, 1)  # Change to red to indicate the simulation has started
	
	# Reset current position in case the simulation was reset
	current_position = 0.0  # Ensure the current flow starts from the beginning

	print("Simulation started.")

# Add glowing effect when inside drop zone
func _draw() -> void:
	# Only draw the glowing effect if the component is inside a valid drop zone
	if simulation_start:
		var glowing = false
		for child in rest_nodes:
			if global_position.distance_to(child.global_position) < 150:  # Inside drop zone
				glowing = true
				break
		
		# If glowing condition is met, draw the glow
		if glowing:
			var glow_color = Color(1, 1, 0, glow_strength)  # Yellow glow when inside drop zone
			draw_circle(global_position, 25, glow_color)  # Draw a glowing circle around the component
