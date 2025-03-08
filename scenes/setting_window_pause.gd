extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"EXIT BUTTON".pressed.connect(_exit_Pause)
	pass
	
func _exit_Pause() -> void: 
	get_tree().change_scene_to_file("res://Final Game Scene.tscn")
