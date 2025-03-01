extends Node2D

class_name Connector

enum ConnectorType {STRAIGHT, CURVED, ELBOW}

var node_from: Sprite = null
var node_to: Sprite = null
var curve: Curve2D = Curve2D.new()

export (ConnectorType) var connector_type = ConnectorType.STRAIGHT setget update_connector_type
export (float, -50, 50) var displacement = 0 setget update_displacement

func update_displacement(new_value):
	displacement = new_value
	draw_connector()

func update_connector_type(new_value):
	connector_type = new_value
	draw_connector()

func _ready():
	update_connected_nodes()

func _get_configuration_warning():
	if get_child_count() != 2:
		return "Needs two Sprite subnodes to create a connection"
	else:
		return ""

func add_child(node, legible_unique_name=false):
	.add_child(node, legible_unique_name)
	update_connected_nodes()

func remove_child(node):
	.remove_child(node)
	update_connected_nodes()
		
func update_connected_nodes():
	if get_child_count() == 2:
		node_from = get_child(0)
		node_to = get_child(1)
		# Connect to position changes (if using a custom signal or manual updates)
		# Example: node_from.connect("position_changed", self, "draw_connector")
		# Example: node_to.connect("position_changed", self, "draw_connector")
	else:
		node_from = null
		node_to = null
	draw_connector()

func draw_connector():
	curve.clear_points()
	if is_instance_valid(node_from) && is_instance_valid(node_to):
		var from_pos = node_from.position
		var to_pos = node_to.position
		var direction = (to_pos - from_pos).normalized()
		var distance = from_pos.distance_to(to_pos)

		match connector_type:
			ConnectorType.STRAIGHT:
				curve.add_point(from_pos)
				curve.add_point(to_pos)
			ConnectorType.CURVED:
				var control_offset = direction.tangent() * distance * displacement / 100
				curve.add_point(from_pos, Vector2.ZERO, control_offset)
				curve.add_point(to_pos, -control_offset, Vector2.ZERO)
			ConnectorType.ELBOW:
				curve.add_point(from_pos)
				if abs(direction.x) > abs(direction.y):
					# Horizontal then vertical
					curve.add_point(Vector2(to_pos.x, from_pos.y))
				else:
					# Vertical then horizontal
					curve.add_point(Vector2(from_pos.x, to_pos.y))
				curve.add_point(to_pos)
	update()  # Redraw the connector

func _draw():
	if curve.get_point_count() >= 2:
		var points = curve.get_baked_points()
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], Color("ff0000"), 5)
