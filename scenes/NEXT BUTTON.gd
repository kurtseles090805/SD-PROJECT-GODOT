extends Control

func _ready():
	connect("pressed", _on_next_button_pressed)
	connect("pressed", _on_back_button_pressed)

# Function to go back to the previous scene
func _on_back_button_pressed():
	if ResourceLoader.exists("res://scenes/AboutUsScene.tscn"):
		get_tree().change_scene_to_file("res://scenes/AboutUsScene.tscn")
	else:
		print("Previous scene not found!", "res://scenes/AboutUsScene.tscn")


# Function to go to the next scene
func _on_next_button_pressed():
	if ResourceLoader.exists("res://scenes/AboutUsSceneSecond.tscn"):
		get_tree().change_scene_to_file("res://scenes/AboutUsSceneSecond.tscn")
	else:
		print("Next scene not found!", "res://scenes/AboutUsSceneSecond.tscn")
