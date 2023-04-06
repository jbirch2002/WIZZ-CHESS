extends StaticBody3D

var sigil = Pieces.Sigil.NONE
var turns_since_capture = 0

func set_sigil(value):
	sigil = value

func set_turns_since_capture(value):
	turns_since_capture = value

func get_valid_moves(chess_board, board_position, color):
	var valid_moves = []
	var current_position = Pieces.string_to_vector3(board_position)

	if sigil == Pieces.Sigil.CRISS_CROSS:
		for rank_offset in [-2, -1, 1, 2]:
			for row_offset in [-2, -1, 1, 2]:
				if abs(rank_offset) == abs(row_offset):
					var next_position = current_position + Vector3(rank_offset, 0, row_offset)
					var target_position = Pieces.vector3_to_string(next_position)

					if Pieces.is_valid_position(next_position) and (chess_board[target_position]["type"] == "" or chess_board[target_position]["type"].is_upper() != (color == Pieces.Player.WHITE)):
						valid_moves.append(target_position)
	
	elif sigil == Pieces.Sigil.RAGING_BULL:
		if turns_since_capture > 0:
			return valid_moves

		var knight_offsets = [
			Vector3(1, 0, 2), Vector3(1, 0, -2), Vector3(-1, 0, 2), Vector3(-1, 0, -2),
			Vector3(2, 0, 1), Vector3(2, 0, -1), Vector3(-2, 0, 1), Vector3(-2, 0, -1)
		]

		for offset in knight_offsets:
			var next_position = current_position + offset
			var target_position = Pieces.vector3_to_string(next_position)

			# Check if the position is valid
			if Pieces.is_valid_position(next_position):
				if chess_board[target_position]["type"] == "" or chess_board[target_position]["type"].is_upper() == (color == Pieces.Player.WHITE):
					valid_moves.append(target_position)
		
	else: 
		pass
			
	return valid_moves

func auto_capture(chess_board, board_position, color):
	var current_position = Pieces.string_to_vector3(board_position)
	var knight_offsets = [
		Vector3(1, 0, 2), Vector3(1, 0, -2), Vector3(-1, 0, 2), Vector3(-1, 0, -2),
		Vector3(2, 0, 1), Vector3(2, 0, -1), Vector3(-2, 0, 1), Vector3(-2, 0, -1)
	]

	for offset in knight_offsets:
		var next_position = current_position + offset
		var target_position = Pieces.vector3_to_string(next_position)
		if Pieces.is_valid_position(next_position) and chess_board[target_position]["type"] != "" and chess_board[target_position]["type"].is_upper() != (color == Pieces.Player.WHITE):
			chess_board[target_position] = {"type": "", "sigil": Pieces.Sigil.NONE}
			turns_since_capture = 1
