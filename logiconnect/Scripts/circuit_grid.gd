extends TextureRect

var dbl_click = false

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Texture2D
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	texture = data
	get_parent().get_parent().get_parent().update_grid()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed(): 
		#wire mode OFF
		if Globals.wire_mode == false:
			if texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOff.png"):
				texture = ResourceLoader.load("res://Assets/Sprites/HSwitchOn.png")
				get_parent().get_parent().get_parent().update_grid()
			elif texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOn.png"):
				texture = ResourceLoader.load("res://Assets/Sprites/HSwitchOff.png")
				get_parent().get_parent().get_parent().update_grid()
			else:
				pass
			if dbl_click == false:
				dbl_click = true
				$Timer.start()
			else:
				if texture == null:
					pass
				else:
					$CPUParticles2D.emitting = true
					texture = null
				get_parent().get_parent().get_parent().update_grid()
		#wire mode ON
		else:
			$Border.visible = true
			if Globals.wire_start == Vector2.ZERO:
				Globals.wire_start = position + Vector2(48, 48)
			if Globals.wire_connection1 == Vector2.ZERO:
				Globals.wire_connection1 = position + Vector2(48, 48)
			else:
				Globals.wire_connection2 = position + Vector2(48, 48)
				Globals.wire_connection1 = Globals.wire_connection2
			get_parent().get_parent().get_parent().new_wire()
			#print(Globals.wire_connection2)
			
			if texture == ResourceLoader.load("res://Assets/Sprites/HBattery.png"):
				Globals.circuit.append("a")
			elif texture == ResourceLoader.load("res://Assets/Sprites/HResistor.png"):
				Globals.circuit.append("b")
			elif texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOff.png"):
				Globals.circuit.append("c0")
			elif texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOn.png"):
				Globals.circuit.append("c1")
			elif texture == ResourceLoader.load("res://Assets/Sprites/HLED.png"):
				Globals.circuit.append("d")
			else:
				pass
			print(Globals.circuit)
	else:
		pass

func _on_timer_timeout() -> void:
	dbl_click = false

func remove_texture() -> void:
	if texture == null:
		$Border.visible = false
	else:
		$Border.visible = false
		$CPUParticles2D.emitting = true
		texture = null

func remove_border() -> void:
	if texture == null:
		$Border.visible = false
	else:
		$Border.visible = false

func _on_item_rect_changed() -> String:
	if texture == ResourceLoader.load("res://Assets/Sprites/HBattery.png"):
		return "a"
	elif texture == ResourceLoader.load("res://Assets/Sprites/HResistor.png"):
		return "b"
	elif texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOff.png"):
		return "c0"
	elif texture == ResourceLoader.load("res://Assets/Sprites/HSwitchOn.png"):
		return "c1"
	elif texture == ResourceLoader.load("res://Assets/Sprites/HLED.png"):
		return "d"
	else:
		return "0"
