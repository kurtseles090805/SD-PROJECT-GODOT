extends Control

func _ready() -> void:
	# Connect via code (optional, if you prefer this over editor connections)
	$"EXIT BUTTON".pressed.connect(_exit_settings)
	pass

func _exit_settings() -> void:
	# Confirm the scene path is correct
	get_tree().change_scene_to_file("res://scenes/Home_Screen.tscn")
	print("Exiting to Home Screen")
