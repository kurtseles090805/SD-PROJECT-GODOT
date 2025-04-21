extends Control

var grid = [
null, null, null, null,
null, null, null, null,
null, null, null, null,
null, null, null, null
]
var error_present := false

@onready var last_a = Vector2.ZERO
@onready var last_b = Vector2.ZERO

func _ready() -> void:
	$AnimationPlayer.play("fade_in")

func update_grid() -> void:
	for n in 16:
		grid[n] = $Circuit/GridContainer.get_child(n)._on_item_rect_changed()
	#print(grid)

func new_wire() -> void:
	$Wire.set_point_position(0, Globals.wire_start + Vector2(64, 80))
	if Globals.wire_connection2 == Vector2.ZERO:
		pass
	else:
		$Wire.add_point(Globals.wire_connection2 + Vector2(64, 80))

func _on_start_stop_pressed() -> void:
	if $Actions/HBoxContainer/StartStop.text == "Start\nSimulation":
		#region disable buttons
		$Actions/HBoxContainer/StartStop.text = "Stop\nSimulation"
		$Actions/HBoxContainer/Wires/WireBlock.visible = true
		$Actions/HBoxContainer/Clear/ClearBlock.visible = true
		$Circuit/StartBlock.visible = true
		$Components/WireBlock.visible = true
		#endregion
		
	elif $Actions/HBoxContainer/StartStop.text == "Stop\nSimulation":
		#region enable buttons
		$Actions/HBoxContainer/StartStop.text = "Start\nSimulation"
		$Actions/HBoxContainer/Wires/WireBlock.visible = false
		$Actions/HBoxContainer/Clear/ClearBlock.visible = false
		$Circuit/StartBlock.visible = false
		$Components/WireBlock.visible = false
		#endregion
	else:
		pass

func _on_wires_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		Globals.wire_mode = true
		for n in 16:
			#remove all borders
			grid[n] = $Circuit/GridContainer.get_child(n).remove_border()
			#change main game item to 0
			grid[n] = $Circuit/GridContainer.get_child(n)._on_item_rect_changed()
		Globals.circuit.clear()
		Globals.wire_start = Vector2.ZERO
		Globals.wire_connection1 = Vector2.ZERO
		Globals.wire_connection2 = Vector2.ZERO
		$Wire.clear_points()
		$Wire.closed = false
		$Wire.add_point(Vector2.ZERO)
		$Actions/HBoxContainer/StartStop/StartBlock.visible = true
		$Components/WireBlock.visible = true
		$Actions/HBoxContainer/Wires.text = "Close\nWires"
	else:
		Globals.wire_mode = false
		$Actions/HBoxContainer/StartStop/StartBlock.visible = false
		$Components/WireBlock.visible = false
		$Wire.closed = true
		$Actions/HBoxContainer/Wires.text = "Redo\nWires"
	print ("Wire Mode ", Globals.wire_mode)
	print ("Overlapping", Globals.wire_cross_error)

func _on_info_pressed() -> void:
	$InstructionsPanel.visible = true

func _on_clear_pressed() -> void:
	for n in 16:
		grid[n] = $Circuit/GridContainer.get_child(n).remove_texture()
		grid[n] = $Circuit/GridContainer.get_child(n)._on_item_rect_changed()
	Globals.wire_start = Vector2.ZERO
	Globals.wire_connection1 = Vector2.ZERO
	Globals.wire_connection2 = Vector2.ZERO
	$Wire.clear_points()
	$Wire.closed = false
	$Wire.add_point(Vector2.ZERO)
	$Actions/HBoxContainer/Wires.text = "Lay\nWires"
	print(grid)
	
func _on_close_instructions_pressed() -> void:
	$InstructionsPanel.visible = false

func _on_close_warning_pressed() -> void:
	$Warning.visible = false

func check_errors() -> void:
	pass

func compute_current() -> void:
	for n in Globals.circuit.size() + 1:
		pass
