extends Control

func _ready() -> void:
	# Connect via code (optional, if you prefer this over editor connections)
	pass
	$Settings.pressed.connect(_home_Settings, _game_Settings)


var home_Settings = preload("res://scenes/Home_Screen.tscn").instantiate()
var game_Settings = preload("res://scenes/UPDATED SCENE GAME.tscn").instantiate()

func _home_Settings() -> void:
	get_tree().root.add_child(home_Settings)
	
func _game_Settings() -> void: 
	get_tree().root.add_child(game_Settings)
