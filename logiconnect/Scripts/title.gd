extends TextureRect

func _on_start_button_pressed() -> void:
	$AnimationPlayer.play("fade_out_to_game")

func _on_quit_button_pressed() -> void:
	$AnimationPlayer.play("fade_out_to_quit")
	
func change_to_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	
func quit_game() -> void:
	get_tree().quit()
