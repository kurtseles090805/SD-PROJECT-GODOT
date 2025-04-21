extends TextureRect

func _get_drag_data(_at_position: Vector2) -> Variant:
	if Globals.wire_mode == true:
		return null
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(96, 96)
	preview_texture.texture_filter = 1
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
		
	return texture
