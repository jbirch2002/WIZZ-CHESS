extends Node3D

class_name mouse_function

var selected_piece = null
var piece_grab_offset = Vector3.ZERO

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var ray_origin = get_viewport().get_camera().project_ray_origin(event.position)
		var ray_target = ray_origin + get_viewport().get_camera().project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state

		var query_parameters = PhysicsRayQueryParameters3D.new()
		query_parameters.from = ray_origin
		query_parameters.to = ray_target
		query_parameters.collision_mask = 1

		var result = space_state.intersect_ray(query_parameters)

		if result and "ChessPiece" in result.collider.get_groups():
			select_piece(result.collider, result.position)
		elif selected_piece:
			drop_piece()

func select_piece(piece, world_position):
	selected_piece = piece
	piece_grab_offset = world_position - selected_piece.translation
	selected_piece.raise_to_top()

func drop_piece():
	selected_piece.drop()
	selected_piece = null
	piece_grab_offset = Vector3.ZERO

func _process(delta):
	if selected_piece:
		update_piece_position()

func update_piece_position():
	var ray_origin = get_viewport().get_camera().project_ray_origin(get_viewport().get_mouse_position())
	var ray_target = ray_origin + get_viewport().get_camera().project_ray_normal(get_viewport().get_mouse_position()) * 1000
	var space_state = get_world_3d().direct_space_state

	var query_parameters = PhysicsRayQueryParameters3D.new()
	query_parameters.from = ray_origin
	query_parameters.to = ray_target
	query_parameters.collision_mask = 1

	var result = space_state.intersect_ray(query_parameters)

	if result:
		selected_piece.translation = result.position - piece_grab_offset
