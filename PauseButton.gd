extends Button

var isPaused = false

func _ready():
	# Initialize the button text
	text = "PAUSE"
	# Connect the pressed signal to the _on_pressed function using a Callable
	if connect("pressed", Callable(self, "_on_pressed")) != OK:
		print("Failed to connect 'pressed' signal.")

func pause_game():
	isPaused = true
	get_tree().paused = true
	text = "UNPAUSE"
	print("Game paused. isPaused:", isPaused, " | Scene tree paused:", get_tree().paused)

func resume_game():
	isPaused = false
	get_tree().paused = false
	text = "PAUSE"
	print("Game resumed. isPaused:", isPaused, " | Scene tree paused:", get_tree().paused)

func _on_pressed() -> void:
	print("Button pressed. Current isPaused:", isPaused)
	if isPaused:
		resume_game()
	else:
		pause_game()
	print("Button action completed. New isPaused:", isPaused)
