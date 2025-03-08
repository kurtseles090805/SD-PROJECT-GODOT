extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Settings.pressed.connect(_setting_Pause)
	$Resume.pressed.connect(_resume_Pause) 
	$Home.pressed.connect(_Home_Pause)
	
	pass # Replace with function body.

func _setting_Pause() -> void: 
	get_tree().change_scene_to_file("res://scenes/SettingWindowPause.tscn")

func _resume_Pause() -> void: 
	get_tree().change_scene_to_file("res://Final Game Scene.tscn")
	
func _Home_Pause() -> void: 
	get_tree().change_scene_to_file("res://scenes/Home_Screen.tscn")
