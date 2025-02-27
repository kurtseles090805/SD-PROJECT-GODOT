# Home_Screen.gd
extends Node2D

var label: Label
var time: Timer
var blink_timer: Timer  # Timer for blinking effect

@export var RedClr: Color
@export var OrigClr: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $"TOP BAR/Label"
	time = $"TOP BAR/Label/Timer"
	
	# Initialize and configure the blink timer
	blink_timer = Timer.new()
	add_child(blink_timer)
	blink_timer.wait_time = 0.5  # Blink interval (0.5 seconds)
	blink_timer.one_shot = false  # Make it repeat
	blink_timer.timeout.connect(_on_blink_timer_timeout)  # Connect timeout signal

	OrigClrRet()
	time.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_label_text()
	if time.time_left <= 0: 
		print("Timer Ended")
	if time.time_left <= 30: 
		if blink_timer.is_stopped():  # Start blinking if not already
			blink_timer.start()
		label.modulate = RedClr  # Change color to red
	else: 
		if not blink_timer.is_stopped():  # Stop blinking if time is above 10 seconds
			blink_timer.stop()
			label.visible = true  # Ensure the label is visible when not blinking
		OrigClrRet()  # Reset to original color

	
func OrigClrRet(): 
	label.modulate = OrigClr

func update_label_text(): 
	var time_left = ceil(time.time_left)
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	label.text = "%02d:%02d" % [minutes, seconds]

# Blink timer timeout function
func _on_blink_timer_timeout() -> void:
	label.visible = not label.visible  # Toggle visibility for blinking effect

# Start button pressed
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scripts/LogiConnnect_Game.tscn")
	print("Start Game pressed")



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
func _on_StartSimulating_pressed() -> void:
	print("Simulating Started!") 
	# SIMULATION STARTS...

# Clear Input button pressed
func _on_ClearInput_pressed() -> void:
	print("INPUT CLEARED") 
	# CLEAR INPUT and reset the game area


func _on_button_pressed() -> void:
	pass # Replace with function body.
