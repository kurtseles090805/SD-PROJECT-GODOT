extends Line2D
class_name Wire
#
@export var valid_color := Color("#5d5d5d")
@export var invalid_color := Color("#ff5555")

var connection := {
	"start": {"component": null, "position": Vector2.ZERO, "terminal_idx": -1},
	"end": {"component": null, "position": Vector2.ZERO, "terminal_idx": -1}
}

func setup(start_pos: Vector2, from_component, terminal_idx: int):
	clear_points()
	add_point(start_pos)
	add_point(start_pos)
	connection.start = {
		"component": from_component, 
		"position": start_pos,
		"terminal_idx": terminal_idx
	}
	default_color = invalid_color

func update_end_position(pos: Vector2):
	set_point_position(1, pos)

func finalize(to_component, terminal_idx: int) -> bool:
	if _validate_connection(to_component, terminal_idx):
		connection.end = {
			"component": to_component,
			"position": get_point_position(1),
			"terminal_idx": terminal_idx
		}
		default_color = valid_color
		return true
	return false

func _validate_connection(to_component, terminal_idx: int) -> bool:
	if connection.start.component == to_component:
		return false
		
	if connection.start.component is BatteryComponent and to_component is BatteryComponent:
		var start_battery: BatteryComponent = connection.start.component
		var end_battery: BatteryComponent = to_component
		if (start_battery.is_terminal_positive(connection.start.terminal_idx) == 
			end_battery.is_terminal_positive(terminal_idx)):
			return false
			
	return true
