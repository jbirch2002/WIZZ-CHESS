extends StaticBody3D

var sigil = Pieces.Sigil.NONE

func set_sigil(value):
	sigil = value

func get_valid_moves(chess_board, board_position, color, has_moved):
	var valid_moves = []
	var current_position = Pieces.string_to_vector3(board_position)

	if sigil == Pieces.Sigil.CATTY_CORNER:
		for diagonal_offset in [-1, 1]:
			var diagonal_position = current_position + Vector3(diagonal_offset, 0, 1 if color == Pieces.Player.WHITE else -1)
			var target_position = Pieces.vector3_to_string(diagonal_position)

			if Pieces.is_valid_position(diagonal_position) and chess_board[target_position]["type"] == "":
				valid_moves.append(target_position)

			var forward_position = current_position + Vector3(diagonal_offset, 0, 2 if color == Pieces.Player.WHITE else -2)
			target_position = Pieces.vector3_to_string(forward_position)

			if Pieces.is_valid_position(forward_position) and chess_board[target_position]["type"] != "" and chess_board[target_position]["type"].is_upper() != (color == Pieces.Player.WHITE):
				valid_moves.append(target_position)

	elif sigil == Pieces.Sigil.SELF_DESTRUCT:
		var forward_position
		var double_forward_position

		if color == Pieces.Player.WHITE:
			forward_position = current_position + Vector3(0, 0, -1)
			double_forward_position = current_position + Vector3(0, 0, -2)
		else:
			forward_position = current_position + Vector3(0, 0, 1)
			double_forward_position = current_position + Vector3(0, 0, 2)

		if Pieces.is_valid_position(forward_position) and chess_board[Pieces.vector3_to_string(forward_position)]["type"] == "":
			valid_moves.append(Pieces.vector3_to_string(forward_position))

		if not has_moved and Pieces.is_valid_position(double_forward_position) and chess_board[Pieces.vector3_to_string(double_forward_position)]["type"] == "" and chess_board[Pieces.vector3_to_string(forward_position)]["type"] == "":
			valid_moves.append(Pieces.vector3_to_string(double_forward_position))
	

	else:
		# Implement regular pawn movement rules here
		pass

	return valid_moves
