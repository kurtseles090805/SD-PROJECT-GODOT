extends Control

var _transition_target_scene: String = ""

func _ready() -> void:
	$BackButton.pressed.connect(_back_Button)

func _back_Button() -> void: 
	print("Returning to About Us Scene")
	change_scene_with_transition("res://scenes/AboutUsScene.tscn")

# Reusable function for scene change with transition
func change_scene_with_transition(scene_path: String) -> void:
	_transition_target_scene = scene_path
	if not TransitionScreen.on_transition_finished.is_connected(_on_transition_done):
		TransitionScreen.on_transition_finished.connect(_on_transition_done, CONNECT_ONE_SHOT)
	TransitionScreen._transition()

func _on_transition_done() -> void:
	get_tree().change_scene_to_file(_transition_target_scene)
