extends Button

var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the button's pressed signal to the _on_pressed function
	connect("pressed", Callable(self, "_on_pressed"))
	text = "PAUSE"  # Set the initial button text

# Function to pause the game
func pause_game() -> void:
	is_paused = true
	get_tree().paused = true  # Pause the game
	text = "UNPAUSE"  # Change button text to "UNPAUSE"
	# You can also stop any active timers here, for example:
	if has_node("Timer"):
		$Timer.stop()  # Stop the timer if you have a Timer node

# Function to resume the game
func resume_game() -> void:
	is_paused = false
	get_tree().paused = false  # Unpause the game
	text = "PAUSE"  # Change button text back to "PAUSE"
	# Start or restart any timers if needed:
	if has_node("Timer"):
		$Timer.start()  # Start the timer again when the game is resumed

# Called when the button is pressed
func _on_pressed() -> void:
	if is_paused:
		resume_game()  # Unpause the game
	else:
		pause_game()  # Pause the game
