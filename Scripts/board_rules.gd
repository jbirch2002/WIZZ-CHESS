extends "res://Scripts/pieces.gd"

# Constants
const BOARD_SIZE = 8
const SQUARE_SIZE = 1

# Variables

var board_squares = {}
var board_square_white_scene = preload("res://Scenes/Board/white_square.tscn")
var board_square_black_scene = preload("res://Scenes/Board/black_square.tscn")

var current_turn = Player.WHITE

# Calling sigil menu
var sigil_selection_scene = preload("res://path/to/SigilSelection.tscn")
var sigil_selection_instance

# Selected pieces null will be normal
var selected_piece = null
var selected_piece_position = null

func create_piece(type, sigil = null):
	if type in ["WK", "BK"] and sigil != "barbarian king":
		sigil = null
	elif type in ["WB", "BB"] and sigil not in ["temporal anomaly", "flying"]:
		sigil = null
	elif type in ["WH", "BH"] and sigil not in ["raging bull", "criss cross"]:
		sigil = null
	elif type in ["WP", "BP"] and sigil not in ["catty corner", "self destruct"]:
		sigil = null

	return {"type": type, "sigil": sigil}

func position_string(row, column):
	var rank = char(97 + row)  # ASCII value of 'a' is 97
	return rank + str(column + 1)

func create_board_squares():
	for i in range(BOARD_SIZE):
		for j in range(BOARD_SIZE):
			var is_white_square = (i + j) % 2 == 0
			var square_scene = board_square_white_scene if is_white_square else board_square_black_scene
			var square = square_scene.instance()
			square.set_translation(Vector3(i * SQUARE_SIZE, 0, j * SQUARE_SIZE))
			add_child(square)

			var position = position_string(i, j)
			board_squares[position] = square

# Chess Board Creation
func create_chess_board():
	var board = {}
	var wh_pieces = ["WR", "WH", "WB", "WQ", "WK", "WB", "WH", "WR"]
	var blk_pieces = ["BR", "BH", "BB", "BQ", "BK", "BB", "BH", "BR"]

	for i in range(BOARD_SIZE):
		var position = position_string(i, 1)
		board[position] = create_piece("WP")  # White pawn
		position = position_string(i, 6)
		board[position] = create_piece("BP")  # Black pawn

	for i in range(BOARD_SIZE):
		for row in range(BOARD_SIZE):
			var position = position_string(i, row)
			if row == 0:
				board[position] = create_piece(wh_pieces[i])  # White pieces
			elif row == 7:
				board[position] = create_piece(blk_pieces[i])  # Black pieces
			elif row >= 2 and row <= 5:
				board[position] = create_piece("")  # Empty square

	return board

func next_turn():
	current_turn = Player.BLACK if current_turn == Player.WHITE else Player.WHITE

# Function to set up the game
func _ready(): 
	sigil_selection_instance = sigil_selection_scene.instance()
	create_board_squares()
	var chess_board = create_chess_board()
	print(chess_board)
	
# Game Logic Functions
func make_move(from_position, to_position):
	var from_square = board_squares[from_position]
	var to_square = board_squares[to_position]
	var piece = from_square.get_child(0)
	piece.set_translation(to_square.get_translation())
	
	board_squares[from_position] = to_square
	board_squares[to_position] = from_square

func is_king_in_check(chess_board, player):
	# Implement logic to determine if the king of the current player is in check
	pass

func is_checkmate(chess_board, player):
	# Implement logic to determine if the current player is in checkmate
	pass

# Function to handle the sigil_confirmed signal
func _on_sigil_confirmed(sigil):
	# Update the selected piece's sigil
	selected_piece["sigil"] = sigil

	# Reset the selected piece and its position on the board
	selected_piece = null
	selected_piece_position = null

	# Hide the sigil selection UI
	sigil_selection_instance.hide()

# Function to select a piece on the board
func select_piece(piece, position):
	# Check if the selected piece has valid sigils
	if piece["type"] in valid_sigils:
		# Store the selected piece and its position on the board
		selected_piece = piece
		selected_piece_position = position
		
		# Show the sigil selection UI with the valid sigils for the selected piece
		sigil_selection_instance.show(valid_sigils[piece["type"]])
	else:
		# If the piece does not have any valid sigils, do nothing
		selected_piece = null
		selected_piece_position = null
