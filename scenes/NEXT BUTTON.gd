extends Control

func _ready():
	connect("pressed", _on_next_button_pressed)

func _on_next_button_pressed():
	if ResourceLoader.exists("res://scenes/AboutUsSceneSecond.tscn"):
		get_tree().change_scene_to_file("res://scenes/AboutUsSceneSecond.tscn")
	else:
		print("Next scene not found!", "res://scenes/AboutUsSceneSecond.tscn")


func _on_pressed() -> void:
	pass # Replace with function body.
