extends Control

# Reusable function for transition + scene change
func change_scene_with_transition(scene_path: String) -> void:
	TransitionScreen._transition()
	TransitionScreen.on_transition_finished.connect(
		func (): get_tree().change_scene_to_file(scene_path),
		CONNECT_ONE_SHOT
	)

func _ready() -> void:
	$PAUSE.pressed.connect(_pause_Tab)
	$"Show circuit".pressed.connect(_show_Circuit_Clue)
	$"START SIMULATION".pressed.connect(_on_Start_Simulation_Pressed)

func _pause_Tab() -> void: 
	print("Paused")
	change_scene_with_transition("res://PauseTab.tscn")

func _show_Circuit_Clue() -> void: 
	print("Show Circuit Clue")
	change_scene_with_transition("res://scenes/ShowCircuitClue.tscn")

func _on_Start_Simulation_Pressed() -> void:
	print("Start Simulation Pressed")
	for zone in get_tree().get_nodes_in_group("zone"):
		if zone.has_method("check_status"):
			zone.check_status()
