extends Control

var _transition_target_scene: String = ""

func _ready() -> void:
	$ExitButton.pressed.connect(_exit_Button)
	$NextButton.pressed.connect(_next_Button)

func _exit_Button() -> void: 
	print("Exiting to Home Screen")
	change_scene_with_transition("res://scenes/Home_Screen.tscn")

func _next_Button() -> void: 
	print("Going to About Us Second Page")
	change_scene_with_transition("res://scenes/AboutUsSceneSecond.tscn")

# Reusable transition + scene change function
func change_scene_with_transition(scene_path: String) -> void:
	_transition_target_scene = scene_path
	if not TransitionScreen.on_transition_finished.is_connected(_on_transition_done):
		TransitionScreen.on_transition_finished.connect(_on_transition_done, CONNECT_ONE_SHOT)
	TransitionScreen._transition()

func _on_transition_done() -> void:
	get_tree().change_scene_to_file(_transition_target_scene)
