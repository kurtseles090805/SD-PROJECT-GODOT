extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"PAUSE GAME".pressed.connect(_pause_Game)
	$"SHOW CIRCUIT".pressed.connect(_show_Circuit2)

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

func _show_Circuit2() -> void:
	get_tree().change_scene_to_file("res://scenes/ShowCircuit2.tscn")

func _pause_Game() -> void:
	get_tree().change_scene_to_file("res://PauseTab.tscn")
