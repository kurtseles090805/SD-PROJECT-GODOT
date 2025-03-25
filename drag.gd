extends Node2D

var selected = false 
var rest_point = Vector2.ZERO
var rest_nodes = []
var _base_scale := Vector2.ONE
var _target_rotation := 0.0
var _hovered := false

@export var snap_distance: float = 75.0
@export var lerp_speed := 0.3
@export var return_lerp_speed := 0.2
@export var rotation_lerp_weight := 10.0

func _ready():
	_base_scale = scale
	rest_nodes = get_tree().get_nodes_in_group("zone")
	_update_rest_point()

func _update_rest_point():
	if rest_nodes.size() > 0:
		rest_point = rest_nodes[0].global_position
		_call_select(rest_nodes[0])

func _call_select(node):
	if node.has_method("select"):
		node.select()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not selected:
			selected = true
			global_position = get_global_mouse_position()
			create_tween().tween_property(self, "scale", _base_scale * 1.2, 0.15)
		elif not event.pressed and selected:
			_release_object()

func _physics_process(delta: float) -> void:
	if selected:
		_drag_behavior(delta)
	else:
		_return_behavior(delta)
	_visual_feedback(delta)

func _drag_behavior(delta: float):
	var mouse_pos = get_global_mouse_position()
	global_position = lerp(global_position, mouse_pos, lerp_speed)
	_target_rotation = global_position.direction_to(mouse_pos).angle()
	rotation = lerp_angle(rotation, _target_rotation, delta * 15.0)

func _return_behavior(delta: float):
	global_position = lerp(global_position, rest_point, return_lerp_speed)
	rotation = lerp_angle(rotation, 0.0, delta * rotation_lerp_weight)

func _visual_feedback(delta: float):
	if selected:
		modulate = Color.from_hsv(fmod(Time.get_ticks_msec()/1000.0, 1.0), 0.3, 1.0)
		scale = lerp(scale, _base_scale * 1.1, delta * 10.0)
	elif _hovered:
		scale = lerp(scale, _base_scale * 1.05, delta * 10.0)
	else:
		modulate = Color.WHITE
		scale = lerp(scale, _base_scale, delta * 10.0)

func _release_object():
	selected = false
	create_tween().tween_property(self, "scale", _base_scale, 0.2)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	var closest_zone = _find_closest_zone()
	if closest_zone:
		rest_point = closest_zone.global_position
		create_tween().tween_property(self, "global_position", rest_point, 0.3)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		_call_select(closest_zone)

func _find_closest_zone():
	if rest_nodes.is_empty():
		return null
		
	var closest = null
	var min_distance = INF
	
	for node in rest_nodes:
		var distance = global_position.distance_to(node.global_position)
		if distance < snap_distance and distance < min_distance:
			min_distance = distance
			closest = node
	
	return closest

func _on_area_2d_mouse_entered():
	_hovered = true
	create_tween().tween_property(self, "scale", _base_scale * 1.1, 0.15)

func _on_area_2d_mouse_exited():
	_hovered = false
	create_tween().tween_property(self, "scale", _base_scale, 0.2)
