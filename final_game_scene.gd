extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PAUSE.pressed.connect(_pause_Tab)
	$"Show circuit".pressed.connect(_show_Circuit_Clue)
	
func _pause_Tab() -> void: 
	get_tree().change_scene_to_file("res://PauseTab.tscn")
# Start button pressed: Change to the main game scene
func _show_Circuit_Clue() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitClue.tscn")
