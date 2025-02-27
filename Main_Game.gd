extends Control  # Only extend Control (remove Panel)

var game_started : bool = false
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

# References to the Label nodes
var minutes_label: Label
var seconds_label: Label
var msec_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the labels with zero time at the start
	minutes_label = $Minutes  # The label for minutes
	seconds_label = $Seconds  # The label for seconds
	msec_label = $Msecs      # The label for milliseconds

	minutes_label.text = "00:"
	seconds_label.text = "00:"
	msec_label.text = "000"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_started:
		time += delta
		msec = int(fmod(time, 1) * 1000)  # Calculate milliseconds
		seconds = int(fmod(time, 60))  # Calculate seconds
		minutes = int(fmod(time, 3600) / 60)  # Calculate minutes

		# Update the labels with the formatted time
		minutes_label.text = "%02d:" % minutes
		seconds_label.text = "%02d:" % seconds
		msec_label.text = "%03d" % msec

# Start button pressed
func _on_start_pressed() -> void:
	if not game_started: 
		game_started = true
		get_tree().change_scene_to_file("res://Main_Game.tscn")
		print("Start Game pressed")
	else: 
		print("Game has already Started")  

# Settings button pressed
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/SettingWindow.tscn")
	print("Settings Pressed")

# Quit button pressed
func _on_quit_game_pressed() -> void:
	get_tree().quit()

# About Us button pressed
func _on_about_us_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/AboutUsScene.tscn")
	print("About Us Pressed")

# User Guide button pressed
func _on_User_guide_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UserGuideScene.tscn")
	print("User Manual Pressed")

# Start simulation button pressed
func _on_StartSimulating_pressed(): 
	print("Simulating Started!") 
	# Simulation starts...

# Clear Input button pressed
func _on_ClearInput_pressed(): 
	print("INPUT CLEARED") 
	game_started = false
	time = 0.0
	minutes_label.text = "00:"
	seconds_label.text = "00:"
	msec_label.text = "000"
	set_process(false)  # Stop the update process when clearing
