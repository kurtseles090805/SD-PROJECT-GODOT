extends Control

# Reusable function for transition + scene change
func change_scene_with_transition(scene_path: String) -> void:
	TransitionScreen._transition()
	TransitionScreen.on_transition_finished.connect(
		func (): get_tree().change_scene_to_file(scene_path),
		CONNECT_ONE_SHOT
	)

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# Start button pressed
func _on_start_pressed() -> void:
	print("Start Game pressed")
	change_scene_with_transition("res://Final Game Scene.tscn")

# Settings button pressed
func _on_settings_pressed() -> void:
	print("Settings Pressed")
	change_scene_with_transition("res://scenes/SettingWindowHome.tscn")

# Quit button pressed
func _on_quit_game_pressed() -> void:
	print("Quit Game Pressed")
	get_tree().quit()

# About Us button pressed
func _on_about_us_pressed() -> void:
	print("About Us Pressed")
	change_scene_with_transition("res://scenes/AboutUsScene.tscn")

# User Guide button pressed
func _on_User_guide_pressed() -> void:
	print("User Manual Pressed")
	change_scene_with_transition("res://UserGuide.tscn")

# Start simulation button pressed
func _on_StartSimulating_pressed() -> void:
	print("Simulating Started!") 
	# SIMULATION STARTS...

# Clear Input button pressed
func _on_ClearInput_pressed() -> void:
	print("INPUT CLEARED") 
	# CLEAR INPUT and reset the game area
