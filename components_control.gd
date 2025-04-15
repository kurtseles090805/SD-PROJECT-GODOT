extends Control

var rest_point: Vector2
var rest_nodes = []  # Stores the drop zones
var dropped_into_zone = false  # Track if the component is dropped into a zone

# Feedback colors
var error_color: Color = Color(1, 0, 0, 1)  # Red for error
var glow_effect: Color = Color(0, 1, 0, 0.5)  # Green for glow
var glow_strength: float = 0.0  # Glow intensity

# Simulation state
var simulation_start = false
var current_position = 0.0

# Called when the node enters the scene tree
func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = global_position
	print("Component placed at: ", rest_point)

# Physics loop to detect if component is in dropzone
func _physics_process(delta: float) -> void:
	if simulation_start:
		dropped_into_zone = false  # Reset at start of check

		# Check proximity to each dropzone
		for child in rest_nodes:
			if global_position.distance_to(child.global_position) < 150:
				dropped_into_zone = true
				break

		# Update glow based on whether in drop zone
		if dropped_into_zone:
			glow_strength = lerp(glow_strength, 1.0, 0.1)
			modulate = Color(0, 1, 0, 1)  # Bright green when valid
		else:
			glow_strength = lerp(glow_strength, 0.0, 0.1)
			modulate = error_color  # Red when not in dropzone

# Triggered when the Start Simulation button is pressed
func _on_start_simulation_pressed() -> void:
	simulation_start = true
	current_position = 0.0
	print("Simulation started.")

# Draw visual glow effect
func _draw() -> void:
	if simulation_start and dropped_into_zone:
		var glow_color = Color(0, 1, 0, glow_strength)  # Green glow
		draw_circle(Vector2.ZERO, 25, glow_color)  # Use local pos since draw_* is local

signal dropped_on_zone(component, drop_zone)

var is_placed = false
var current_drop_zone = null

func _on_drop_zone_detected(drop_zone):
	# Called by main controller when dropped
	current_drop_zone = drop_zone
	is_placed = true
	emit_signal("dropped_on_zone", self, drop_zone)

func light_up():
	# Example light-up effect
	modulate = Color(1, 1, 0)  # Yellow
