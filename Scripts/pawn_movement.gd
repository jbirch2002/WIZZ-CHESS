extends StaticBody3D

enum PieceColor { WHITE, BLACK }

export(PieceColor) var color = PieceColor.WHITE
var initial_move = true
var board_size = 8
var move_distance = 1.0
var is_selected = false

func _ready():
	add_to_group("ChessPiece")

func raise_to_top():
	translation.y += 0.5
	is_selected = true

func drop():
	translation.y -= 0.5
	is_selected = false

func get_moves():
	var moves = []
	var current_position = get_position_on_board()

	if color == PieceColor.WHITE:
		moves.append(current_position + Vector3(0, 0, -1))
		if initial_move:
			moves.append(current_position + Vector3(0, 0, -2))
	elif color == PieceColor.BLACK:
		moves.append(current_position + Vector3(0, 0, 1))
		if initial_move:
			moves.append(current_position + Vector3(0, 0, 2))

	return moves

func get_position_on_board():
	return Vector3(
		int(translation.x / move_distance),
		0,
		int(translation.z / move_distance)
	)

func set_position_on_board(position: Vector3):
	translation = Vector3(
		position.x * move_distance,
		translation.y,
		position.z * move_distance
	)

func is_move_valid(target_position: Vector3):
	var moves = get_moves()
	return target_position in moves

func try_move(target_position: Vector3):
	if is_move_valid(target_position):
		initial_move = false
		set_position_on_board(target_position)
		return true
	return false
