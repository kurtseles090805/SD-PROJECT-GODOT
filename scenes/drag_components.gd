extends Control

func _can_drop_data(_pos, data):
	return data is Control  # Accept only components

func _drop_data(pos, data):
	if data is Control:
		# Remove from previous parent before adding to grid
		if data.get_parent():
			data.get_parent().remove_child(data)

		add_child(data)  # Add the component to the grid
		data.position = pos - (data.size / 2)  # Center it on drop
		data.show()  # Make sure it appears in the grid
