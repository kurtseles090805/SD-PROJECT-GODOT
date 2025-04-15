extends Control

func _ready() -> void:
	$"EXIT BUTTON".pressed.connect(_exit_Scene)

func _exit_Scene() -> void: 
	print("Exit Button Pressed")
	TransitionScreen._transition()
	TransitionScreen.on_transition_finished.connect(
		func (): get_tree().change_scene_to_file("res://PauseTab.tscn"),
		CONNECT_ONE_SHOT
	)
