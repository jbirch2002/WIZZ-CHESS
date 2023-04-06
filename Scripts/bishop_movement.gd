extends StaticBody3D

var sigil = Pieces.Sigil.NONE

func set_sigil(value):
	sigil = value

func get_valid_moves(chess_board, board_position, color):
	var valid_moves = []
	var current_position = Pieces.string_to_vector3(board_position)
	
	if sigil == Pieces.Sigil.FLYING:
		var directions = [
			Vector3(1, 0, 1), Vector3(1, 0, -1),
			Vector3(-1, 0, 1), Vector3(-1, 0, -1)
		]

		for direction in directions:
			var encountered_piece = false
			var next_position = current_position + direction

			while Pieces.is_valid_position(next_position):
				var next_position_string = Pieces.vector3_to_string(next_position)
				var target_piece = chess_board[next_position_string]

				if target_piece["type"] != "":
					if not encountered_piece:
						if target_piece["type"].is_upper() == (color == Pieces.Player.WHITE):
							break
						encountered_piece = true
					else:
						if target_piece["type"].is_upper() != (color == Pieces.Player.WHITE):
							valid_moves.append(next_position_string)
						break

				if not encountered_piece:
					next_position += direction
				else:
					next_position += 2 * direction
		
	elif sigil == Pieces.Sigil.TEMPORAL_ANOMALY:
		pass

	else:
		pass
