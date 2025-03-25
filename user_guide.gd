extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"return home".pressed.connect(_return_Home)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _return_Home() -> void: 
	get_tree().change_scene_to_file("res://scenes/Home_Screen.tscn")
