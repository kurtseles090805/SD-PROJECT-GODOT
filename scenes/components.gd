extends Control

@onready var texture_rect: TextureRect = $TextureRect  # The TextureRect inside the component

func _get_drag_data(_at_position):
	if not texture_rect or not texture_rect.texture:
		return null  # No texture = no drag
	
	# Create a preview texture for dragging
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = Vector2(50, 50)  # Adjust size of the preview

	var preview = Control.new()
	preview.add_child(preview_texture)
	preview_texture.position = -preview_texture.size / 2  # Center preview

	set_drag_preview(preview)  # Set the preview
	self.hide()  # Hide the component while dragging

	return self  # Return the whole component as drag data

func _can_drop_data(_pos, data):
	return data is Control  # Allow dropping only Control nodes

func _drop_data(_pos, data):
	if data != self:  # Prevent dropping onto itself
		# Example: Swap positions of the dragged component and the target component
		var temp_pos = data.rect_position
		data.rect_position = self.rect_position
		self.rect_position = temp_pos

func _on_drag_ended(_success):
	self.show()  # Show the component again after dragging ends
