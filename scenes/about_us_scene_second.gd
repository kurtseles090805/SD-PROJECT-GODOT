extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BackButton.pressed.connect(_back_Button)
	pass # Replace with function body.

func _back_Button() -> void: 
	get_tree().change_scene_to_file("res://scenes/AboutUsScene.tscn")
