extends StaticBody3D

var sigil = Pieces.Sigil.NONE

func set_sigil(value):
	sigil = value

func get_valid_moves(chess_board, board_position, color):
	var valid_moves = []
	var current_position = Pieces.string_to_vector3(board_position)
	
	if sigil == Pieces.Sigil.BARBARIAN_KING:
		var offsets = [
			Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, -1)
		]

		for offset in offsets:
			var next_position = current_position + offset
			var target_position = Pieces.vector3_to_string(next_position)
			if Pieces.is_valid_position(next_position) and (chess_board[target_position]["type"] == "" or chess_board[target_position]["type"].is_upper() != (color == Pieces.Player.WHITE)):
				valid_moves.append(target_position)

		# 2. The king will be able to take any enemy piece in a 2x2 area around it, so long as it is not being protected, and there are no friendly pieces in the way.
		for rank_offset in [-2, 3]:
			for row_offset in [-2, 3]:
				if abs(rank_offset) <= 1 and abs(row_offset) <= 1:
					continue
				var attack_position = current_position + Vector3(rank_offset, 0, row_offset)
				var target_position = Pieces.vector3_to_string(attack_position)

				if Pieces.is_valid_position(attack_position) and chess_board[target_position]["type"] != "" and chess_board[target_position]["type"].is_upper() != (color == Pieces.Player.WHITE) and not is_protected(chess_board, target_position, color):	
					valid_moves.append(target_position)
	else:
		pass

	return valid_moves

# Helper function to check if a position is protected by enemy pieces
func is_protected(chess_board, position, current_color):
	var enemy_color = Pieces.Player.WHITE if current_color == Pieces.Player.BLACK else Pieces.Player.BLACK

	for possible_enemy_position in chess_board.keys():
		var piece = chess_board[possible_enemy_position]
		if piece["type"] != "" and piece["type"].is_upper() != (current_color == Pieces.Player.WHITE):
			var valid_moves = Pieces.piece_movement[piece["type"].toupper()].get_valid_moves(chess_board, possible_enemy_position, enemy_color)
			if position in valid_moves:
				return true

	return false
