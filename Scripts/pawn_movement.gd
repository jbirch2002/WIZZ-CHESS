extends "res://Scripts/pieces.gd"

enum Sigil {
	NONE,
	CATTY_CORNER,
	SELF_DESTRUCT
}

var sigil = Sigil.NONE

func set_sigil(value):
	sigil = value

func get_valid_moves(chess_board, board_position, color):
	var valid_moves = []
	var current_rank = int(board_position.x) # cast to int
	var current_row = int(board_position.y)
	var next_row

	if sigil == Sigil.CATTY_CORNER:
		# Move diagonally
		for direction in [-1, 1]:
			var next_rank = current_rank + direction
			if color == Player.WHITE:
				next_row = current_row + 1
			else:
				next_row = current_row - 1

			if (next_rank >= int("a")) and (next_rank <= int("h")) and (next_row >= 1) and (next_row <= 8):
				var target_position = char(next_rank) + str(next_row)
				if chess_board[target_position] == "":
					valid_moves.append(target_position)

		# Capture forwards
		if color == Player.WHITE:
			next_row = current_row + 1
		else:
			next_row = current_row - 1

		for direction in [-1, 1]:
			var next_rank = current_rank + direction
			if (next_rank >= int("a")) and (next_rank <= int("h")) and (next_row >= 1) and (next_row <= 8):
				var target_position = char(next_rank) + str(next_row)
				if chess_board[target_position] != "" and chess_board[target_position].is_upper() != (color == Player.WHITE):
					valid_moves.append(target_position)
					
	elif sigil == Sigil.SELF_DESTRUCT:
		# Implement self-destruct sigil logic here
		pass

	else:
 # Implement regular pawn movement rules here
		pass

	return valid_moves
