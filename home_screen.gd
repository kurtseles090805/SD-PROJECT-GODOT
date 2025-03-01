
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Start button pressed
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://UPDATED SCENE GAME.tscn")
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
