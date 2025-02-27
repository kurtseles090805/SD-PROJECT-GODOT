# Home_Screen.gd
extends Node2D

var label = Label
var time = Timer

@export var RedClr : Color
@export var OrigClr : Color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $"TOP BAR/Label"
	time = $"TOP BAR/Label/Timer"
	OrigClrRet()
	time.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_label_text()
	if time.time_left <= 5: 
		label.modulate = RedClr
	else: 
		OrigClrRet()
		
func OrigClrRet(): 
	label.modulate = OrigClr
func update_label_text(): 
	label.text = str(ceil(time.time_left))
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
