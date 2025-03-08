extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(_back_Scene)
	pass # Replace with function body.

func _back_Scene() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitClue.tscn")
