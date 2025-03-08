extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Circuit Diagram".pressed.connect(_show_Circuit_Diagram)
	$"Back button".pressed.connect(_back_Screen)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_Circuit_Diagram () -> void: 
	get_tree().change_scene_to_file("res://Circuit_clues.tscn")

func _back_Screen() -> void: 
	get_tree().change_scene_to_file("res://Final Game Scene.tscn")
