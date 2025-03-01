extends Control

var label: Label
var time: Timer
var blink_timer: Timer  # Timer for blinking effect

# Properly initialize colors using Color() constructor
@export var RedClr: Color = Color(1, 0, 0)  # Red color
@export var OrigClr: Color = Color(1, 1, 1)  # White color (original color)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize label and timer references
	label = $"TOP BOX/LABEL BOX"
	time = $"TOP BOX/Label/Timer"
	
	# Initialize and configure the blink timer
	blink_timer = Timer.new()
	add_child(blink_timer)
	blink_timer.wait_time = 0.5  # Blink interval (0.5 seconds)
	blink_timer.one_shot = false  # Make it repeat
	blink_timer.timeout.connect(_on_blink_timer_timeout)  # Connect timeout signal
	
	# Set the label to its original color
	reset_label_color()
	
	# Start the countdown timer
	time.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_label_text()  # Update the time on the label

	# When time is under 30 seconds, start blinking and change color
	if time.time_left <= 0: 
		print("Timer Ended")
		stop_blinking()  # Ensure blinking stops when timer ends
	elif time.time_left <= 30: 
		if blink_timer.is_stopped():  # Start blinking if not already
			blink_timer.start()
		label.modulate = RedClr  # Change label color to red
	else: 
		stop_blinking()  # Stop blinking if time is above 30 seconds
		reset_label_color()  # Reset color to original

# Function to reset the label's color to the original color
func reset_label_color(): 
	label.modulate = OrigClr

# Function to stop the blinking effect
func stop_blinking():
	if not blink_timer.is_stopped():
		blink_timer.stop()
		label.visible = true  # Make sure label is visible when not blinking

# Update the label text with the formatted time
func update_label_text(): 
	var time_left = ceil(time.time_left)
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	label.text = "%02d:%02d" % [minutes, seconds]

# Blink timer timeout function, toggles label visibility for blinking effect
func _on_blink_timer_timeout() -> void:
	label.visible = not label.visible  # Toggle visibility for blinking effect

# Start button pressed: Change to the main game scene
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://UPDATED SCENE GAME.tscn")
	print("Start Game pressed")

# Settings button pressed: Change to the settings scene
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/SettingWindow.tscn")
	print("Settings Pressed")

# Quit button pressed: Quit the game
func _on_quit_game_pressed() -> void:
	get_tree().quit()

# About Us button pressed: Change to the About Us scene
func _on_about_us_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/AboutUsScene.tscn")
	print("About Us Pressed")

# User Guide button pressed: Change to the User Guide scene
func _on_User_guide_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UserGuideScene.tscn")
	print("User Manual Pressed")

# Start simulation button pressed: Start the simulation
func _on_StartSimulating_pressed() -> void:
	print("Simulating Started!") 
	# SIMULATION STARTS...

# Clear Input button pressed: Clear inputs and reset game area
func _on_ClearInput_pressed() -> void:
	print("INPUT CLEARED") 
	# CLEAR INPUT and reset the game area
