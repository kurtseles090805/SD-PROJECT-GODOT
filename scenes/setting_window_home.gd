extends Control

func _ready() -> void:
	$"EXIT BUTTON".pressed.connect(_exit_Scene)
	pass
	
func _exit_Scene() -> void: 
	get_tree().change_scene_to_file("res://scenes/Home_Screen.tscn")
