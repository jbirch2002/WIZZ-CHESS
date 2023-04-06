extends Node3D


# Constants
const BOARD_SIZE = 8
const SQUARE_SIZE = 1

# Variables
var chess_board
var board_squares = {}
var board_square_white_scene = preload("res://Scenes/Board/white_square.tscn")
var board_square_black_scene = preload("res://Scenes/Board/black_square.tscn")

var current_turn = Pieces.Player.WHITE

# Calling sigil menu
var sigil_selection_scene = preload("res://Scenes/SigilSelection.tscn")
var sigil_selection_instance

# Selected pieces null will be normal
var selected_piece = null
var selected_piece_position = null

func create_piece(type, sigil = Pieces.Sigil.NONE):
	if type in [Pieces.WHITE_KING, Pieces.BLACK_KING] and sigil != Pieces.Sigil.BARBARIAN_KING:
		sigil = Pieces.Sigil.NONE
	elif type in [Pieces.WHITE_BISHOP, Pieces.BLACK_BISHOP] and sigil not in [Pieces.Sigil.TEMPORAL_ANOMALY, Pieces.Sigil.FLYING]:
		sigil = Pieces.Sigil.NONE
	elif type in [Pieces.WHITE_KNIGHT, Pieces.BLACK_KNIGHT] and sigil not in [Pieces.Sigil.RAGING_BULL, Pieces.Sigil.CRISS_CROSS]:
		sigil = Pieces.Sigil.NONE
	elif type in [Pieces.WHITE_PAWN, Pieces.BLACK_PAWN] and sigil not in [Pieces.Sigil.CATTY_CORNER, Pieces.Sigil.SELF_DESTRUCT]:
		sigil = Pieces.Sigil.NONE
		
	var instance = null
	if type != "":
		instance = Pieces.pieces[type].instance()
		instance.set_sigil(sigil)

	return {"type": type, "sigil": sigil, "instance": instance}

func position_vector3(row, column):
	return Vector3(row, 0, column)

func create_board_squares():
	for i in range(BOARD_SIZE):
		for j in range(BOARD_SIZE):
			var is_white_square = (i + j) % 2 == 0
			var square_scene = board_square_white_scene if is_white_square else board_square_black_scene
			var square = square_scene.instance()
			square.set_translation(position_vector3(i, j) * SQUARE_SIZE)
			add_child(square)
			
			var position = Pieces.vector3_to_string(position_vector3(i, j))
			board_squares[position] = square
			
# Chess Board Creation
func create_chess_board():
	var board = {}
	var wh_pieces = [Pieces.WHITE_ROOK, Pieces.WHITE_KNIGHT, Pieces.WHITE_BISHOP, Pieces.WHITE_QUEEN, Pieces.WHITE_KING, Pieces.WHITE_BISHOP, Pieces.WHITE_KNIGHT, Pieces.WHITE_ROOK]
	var blk_pieces = [Pieces.BLACK_ROOK, Pieces.BLACK_KNIGHT, Pieces.BLACK_BISHOP, Pieces.BLACK_QUEEN, Pieces.BLACK_KING, Pieces.BLACK_BISHOP, Pieces.BLACK_KNIGHT, Pieces.BLACK_ROOK]

	for i in range(BOARD_SIZE):
		var position = Pieces.vector3_to_string(position_vector3(i, 1))
		board[position] = create_piece(Pieces.WHITE_PAWN)  # White pawn
		position = Pieces.vector3_to_string(position_vector3(i, 6))
		board[position] = create_piece(Pieces.BLACK_PAWN)  # Black pawn

	for i in range(BOARD_SIZE):
		for row in range(BOARD_SIZE):
			var position = Pieces.vector3_to_string(position_vector3(i, row))
			if row == 0:
				board[position] = create_piece(wh_pieces[i])  # White pieces
			elif row == 7:
				board[position] = create_piece(blk_pieces[i])  # Black pieces
			elif row >= 2 and row <= 5:
				board[position] = create_piece("")  # Empty square

	return board

func get_valid_moves(piece, position, color):
	if piece["type"] in [Pieces.WHITE_KING, Pieces.BLACK_KING]:
		return Pieces.piece_movement[Pieces.KING].get_valid_moves(chess_board, position, color)
	if piece["type"] in [Pieces.WHITE_PAWN, Pieces.BLACK_PAWN]:
		return Pieces.piece_movement[Pieces.PAWN].get_valid_moves(chess_board, position, color, piece["instance"].has_moved)
	if piece["type"] in [Pieces.WHITE_KNIGHT, Pieces.BLACK_KNIGHT]:
		return Pieces.piece_movement[Pieces.KNIGHT].get_valid_moves(chess_board, position, color)
	if piece["type"] in [Pieces.WHITE_BISHOP, Pieces.BLACK_BISHOP]:
		return Pieces.piece_movement[Pieces.BISHOP].get_valid_moves(chess_board, position, color)
	return []

func next_turn():
	current_turn = Pieces.Player.BLACK if current_turn == Pieces.Player.WHITE else Pieces.Player.WHITE
	auto_capture_all_raging_bulls()

# Function to set up the game
func _ready():
	sigil_selection_instance = sigil_selection_scene.instance()
	add_child(sigil_selection_instance)
	sigil_selection_instance.connect("sigil_selected", self, "_on_sigil_selected")

	create_board_squares()
	var chess_board = create_chess_board()
	print(chess_board)
	
func auto_capture_all_raging_bulls():
	for position in chess_board.keys():
		var piece = chess_board[position]
		if piece["type"] in [Pieces.WHITE_KNIGHT, Pieces.BLACK_KNIGHT] and Pieces["sigil"] == Pieces.Sigil.RAGING_BULL:
			piece["instance"].auto_capture(chess_board, position, current_turn if Pieces["type"].is_upper() else (Pieces.Player.WHITE if current_turn == Pieces.Player.BLACK else Pieces.Player.BLACK))

func explode(current_position):
	var explosion_offsets = [
		Vector3(-1, 0, 0), Vector3(1, 0, 0),
		Vector3(0, 0, -1), Vector3(0, 0, 1)
	]

	for offset in explosion_offsets:
		var target_position = current_position + offset
		if Pieces.is_valid_position(target_position):	
			var target_key = Pieces.vector3_to_string(target_position)
			chess_board[target_key] = create_piece("")  # Remove the piece from the board
			board_squares[target_key].remove_child(board_squares[target_key].get_child(0))

	# Remove the self-destructing pawn itself
	chess_board[Pieces.vector3_to_string(current_position)] = create_piece("")
	board_squares[Pieces.vector3_to_string(current_position)].remove_child(board_squares[Pieces.vector3_to_string(current_position)].get_child(0))


# Game Logic Functions
func make_move(from_position, to_position):
	var from_square = board_squares[Pieces.vector3_to_string(from_position)]
	var to_square = board_squares[Pieces.vector3_to_string(to_position)]
	var piece = from_square.get_child(0)
	piece.set_translation(to_square.get_translation())

	board_squares[Pieces.vector3_to_string(from_position)] = to_square
	board_squares[Pieces.vector3_to_string(to_position)] = from_square

	var piece_data = chess_board[Pieces.vector3_to_string(from_position)]
	chess_board[Pieces.vector3_to_string(from_position)] = create_piece("")
	chess_board[Pieces.vector3_to_string(to_position)] = piece_data
	
	if piece_data["sigil"] == Pieces.Sigil.SELF_DESTRUCT and piece_data["type"] in [Pieces.WHITE_PAWN, Pieces.BLACK_PAWN]:
		explode(from_position)

	if piece_data["sigil"] == Pieces.Sigil.RAGING_BULL and piece_data["instance"].turns_since_capture > 0:
		piece_data["instance"].set_turns_since_capture(piece_data["instance"].turns_since_capture - 1)
		
	auto_capture_all_raging_bulls()
	
func is_king_in_check(chess_board, player):
	# Implement logic to determine if the king of the current player is in check
	pass

func is_checkmate(chess_board, player):
	# Implement logic to determine if the current player is in checkmate
	pass

func _on_sigil_selected(sigil):
	selected_piece["sigil"] = sigil
	selected_piece = null
	selected_piece_position = null

	sigil_selection_instance.hide_menu()

# Function to select a piece on the board
func select_piece(piece, position):
	if piece["type"] in sigil_selection_instance.valid_sigils:
		selected_piece = piece
		selected_piece_position = position
		var valid_moves = get_valid_moves(piece, Pieces.vector3_to_string(position), current_turn)
		sigil_selection_instance.show_menu(sigil_selection_instance.valid_sigils[piece["type"]])

	else:
		# If the piece does not have any valid sigils, do nothing
		selected_piece = null
		selected_piece_position = null
