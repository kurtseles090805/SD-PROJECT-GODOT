extends Button

# Declare a reference to the simulation control
var simulation_control: Node = null  # This should be the node controlling the simulation (the component that handles simulation logic)

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Optionally, find the simulation control node if it's not manually set
	# Replace "SimulationControl" with the actual name of the node that controls the simulation
	simulation_control = get_node_or_null("SimulationControl") 

	# Log the connection or handle the case where simulation control is not found
	if simulation_control == null:
		print("Simulation control node not found, make sure it's set correctly.")
	else:
		print("Simulation control node found.")

# Function that is triggered when the button is pressed
func _on_start_simulation_pressed() -> void:
	# Make sure the simulation control node exists and has the simulation_start variable
	if simulation_control and simulation_control.has_method("_on_start_simulation_pressed"):
		# Call the function in the simulation control to start the simulation
		simulation_control._on_start_simulation_pressed()  # This will trigger the simulation logic

		# Optionally change button text to indicate simulation has started
		self.text = "Simulation Running..."  # Example change
		self.input_pickable = false
		# Optionally disable the button to prevent further presses
		self.disabled = true

		# Visual feedback for the user
		modulate = Color(0, 1, 0, 1)  # Change button color to green to show the simulation started
		print("Simulation started!")
