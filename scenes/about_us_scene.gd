extends Control

func _ready() -> void:
	# Connect ExitButton to _exit_Button
	$ExitButton.pressed.connect(_exit_Button)
	# Connect NextButton to _next_Button
	$NextButton.pressed.connect(_next_Button)
	pass

func _exit_Button() -> void: 
	print("Exiting to Home Screen")
	get_tree().change_scene_to_file("res://scenes/Home_Screen.tscn")

func _next_Button() -> void: 
	print("Going to About Us Second Page")
	get_tree().change_scene_to_file("res://scenes/AboutUsSceneSecond.tscn")
