extends TextureRect

signal texture_changed(new_texture: Texture2D)

@export var texture_list: Array[Texture2D] = []
@export var allow_cycling: bool = true

var current_texture_index: int = -1
var _original_scale: Vector2 = Vector2.ONE
var _original_modulate: Color = Color.WHITE

func _ready():
	_original_scale = scale
	_original_modulate = modulate
	tooltip_text = "Drag and drop textures here"
	
	if texture_list.size() > 0:
		current_texture_index = 0
		texture = texture_list[current_texture_index]

func _get_drag_data(at_position):
	if texture == null:
		return null
		
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(30, 30)
	preview_texture.position = -preview_texture.size / 2  # Center preview under cursor
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	# Animate source item
	animate_drag_start()
	
	# Connect drag end signal
	connect("drag_ended", _on_drag_ended, CONNECT_ONE_SHOT)
	
	return texture

func _can_drop_data(_pos, data):
	var valid = data is Texture2D
	animate_drop_hover(valid)
	return valid

func _drop_data(_pos, data):
	texture = data
	texture_changed.emit(data)
	animate_drop_success()
	
	if texture_list.size() > 0 and not texture in texture_list:
		texture_list.append(texture)

func _on_drag_ended(_success: bool):
	animate_drag_end()
	if not _success:
		reset_grid()  # Reset the grid to its original form if the drag was not successful

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and allow_cycling:
			cycle_texture()

func cycle_texture():
	if texture_list.size() == 0:
		return
	
	current_texture_index = (current_texture_index + 1) % texture_list.size()
	texture = texture_list[current_texture_index]
	texture_changed.emit(texture)
	animate_texture_cycle()

func clear_texture():
	texture = null
	texture_changed.emit(null)
	animate_clear()

func animate_drag_start():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.5, 0.1)
	tween.tween_property(self, "scale", _original_scale * 0.9, 0.1)

func animate_drag_end():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate", _original_modulate, 0.1)
	tween.tween_property(self, "scale", _original_scale, 0.1)

func animate_drop_hover(valid: bool):
	var tween = create_tween()
	tween.tween_property(self, "modulate", 
		Color.SEA_GREEN if valid else Color.INDIAN_RED, 
		0.1
	)

func animate_drop_success():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", _original_scale * 1.1, 0.1)
	tween.chain().tween_property(self, "scale", _original_scale, 0.1)
	tween.parallel().tween_property(self, "modulate", _original_modulate, 0.2)

func animate_texture_cycle():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 15, 0.1)
	tween.chain().tween_property(self, "rotation_degrees", 0, 0.1)

func animate_clear():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.chain().tween_property(self, "modulate:a", 1.0, 0.15)

# Function to reset the grid to its original form
func reset_grid() -> void:
	# Implement the logic to reset the grid to its original form
	# For example, you can clear all components and reset the grid layout
	var grid = get_parent()  # Assuming the grid is the parent node
	for component in grid.get_children():
		component.queue_free()  # Remove each component
	# Optionally, reinitialize the grid layout here

# Function to animate components sticking together
func animate_stick_together(target_position: Vector2) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", _original_scale * 1.05, 0.1)
	tween.chain().tween_property(self, "scale", _original_scale, 0.1)
