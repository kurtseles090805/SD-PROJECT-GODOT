extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"GO BACK".pressed.connect(_back_Screen)
	$"Circuit 1".pressed.connect(_show_Circuit1)
	$"Circuit 2".pressed.connect(_show_Circuit2)
	$"Circuit 3".pressed.connect(_show_Circuit3)
	$"Circuit 4".pressed.connect(_show_Circuit4)
	$"Circuit 5".pressed.connect(_show_Circuit5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _back_Screen() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitClue.tscn")
	
func _show_Circuit1() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitDiagram.tscn")
func _show_Circuit2() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitDiagram2.tscn")
func _show_Circuit3() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitDiagram3.tscn")
func _show_Circuit4() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitDiagram4.tscn")
func _show_Circuit5() -> void: 
	get_tree().change_scene_to_file("res://scenes/ShowCircuitDiagram5.tscn")
