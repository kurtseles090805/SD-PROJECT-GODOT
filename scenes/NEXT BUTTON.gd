extends Button

func _ready() -> void:
	# Connect the button's pressed signal to our function
	connect("pressed", Callable(self, "_next_button"))

func _next_button() -> void:
	# Load the target scene and change to it
	var next_scene = load("res://scenes/AboutUsSceneSecond.tscn")
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
		print("Changing scene to AboutUsSceneSecond")
	else:
		print("Error: Scene not found at path")
