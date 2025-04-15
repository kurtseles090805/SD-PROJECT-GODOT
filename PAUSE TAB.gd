extends Control

func _ready() -> void:
	$Settings.pressed.connect(_setting_Pause)
	$Resume.pressed.connect(_resume_Pause) 
	$Home.pressed.connect(_Home_Pause)

# Reusable function for transition + scene change
func change_scene_with_transition(scene_path: String) -> void:
	TransitionScreen._transition()
	TransitionScreen.on_transition_finished.connect(
		func (): get_tree().change_scene_to_file(scene_path),
		CONNECT_ONE_SHOT
	)

# Navigate to Settings with transition
func _setting_Pause() -> void: 
	print("Settings Button Pressed")
	change_scene_with_transition("res://scenes/SettingWindowPause.tscn")

# Resume game (back to main scene) with transition
func _resume_Pause() -> void: 
	print("Resume Button Pressed")
	change_scene_with_transition("res://Final Game Scene.tscn")

# Go to Home Screen with transition
func _Home_Pause() -> void: 
	print("Home Button Pressed")
	change_scene_with_transition("res://scenes/Home_Screen.tscn")
