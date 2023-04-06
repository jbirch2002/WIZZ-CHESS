extends Node3D




enum Player {
	WHITE,
	BLACK
}

enum Piece {
	WHITE_PAWN,
	BLACK_PAWN,
	WHITE_ROOK,
	BLACK_ROOK,
	WHITE_KNIGHT,
	BLACK_KNIGHT,
	WHITE_BISHOP,
	BLACK_BISHOP,
	WHITE_QUEEN,
	BLACK_QUEEN,
	WHITE_KING,
	BLACK_KING
}

enum Sigil {
	NONE,
	BARBARIAN_KING,
	TEMPORAL_ANOMALY,
	FLYING,
	RAGING_BULL,
	CRISS_CROSS,
	CATTY_CORNER,
	SELF_DESTRUCT
}

var color = Player.WHITE
var board_position = ""

# Pieces
var pieces = {
	Piece.WHITE_PAWN: preload("res://Scenes/WH_Pieces/wh_pawn_starting_p.tscn"),
	Piece.BLACK_PAWN: preload("res://Scenes/BLK_Pieces/blk_pawn_starting_p.tscn"),
	Piece.WHITE_ROOK: preload("res://Scenes/WH_Pieces/wh_rook_starting_p.tscn"),
	Piece.BLACK_ROOK: preload("res://Scenes/BLK_Pieces/blk_rook_starting_p.tscn"),
	Piece.WHITE_KNIGHT: preload("res://Scenes/WH_Pieces/wh_knight_starting_p.tscn"),
	Piece.BLACK_KNIGHT: preload("res://Scenes/BLK_Pieces/blk_knight_starting_p.tscn"),
	Piece.WHITE_BISHOP: preload("res://Scenes/WH_Pieces/wh_bishop_starting_p.tscn"),
	Piece.BLACK_BISHOP: preload("res://Scenes/BLK_Pieces/blk_bishop_starting_p.tscn"),
	Piece.WHITE_QUEEN: preload("res://Scenes/WH_Pieces/wh_queen_starting_p.tscn"),
	Piece.BLACK_QUEEN: preload("res://Scenes/BLK_Pieces/blk_queen_starting_p.tscn"),
	Piece.WHITE_KING: preload("res://Scenes/WH_Pieces/wh_king_starting_p.tscn"),
	Piece.BLACK_KING: preload("res://Scenes/BLK_Pieces/blk_king_starting_p.tscn"),
}


var piece_movement = {
	Piece.WHITE_PAWN: load("res://Scripts/pawn_movement.gd").new(),
	Piece.BLACK_PAWN: load("res://Scripts/pawn_movement.gd").new(),
	Piece.WHITE_ROOK: load("res://Scripts/rook_movement.gd").new(),
	Piece.BLACK_ROOK: load("res://Scripts/rook_movement.gd").new(),
	Piece.WHITE_KNIGHT: load("res://Scripts/knight_movement.gd").new(),
	Piece.BLACK_KNIGHT: load("res://Scripts/knight_movement.gd").new(),
	Piece.WHITE_BISHOP: load("res://Scripts/bishop_movement.gd").new(),
	Piece.BLACK_BISHOP: load("res://Scripts/bishop_movement.gd").new(),
	Piece.WHITE_QUEEN: load("res://Scripts/queen_movement.gd").new(),
	Piece.BLACK_QUEEN: load("res://Scripts/queen_movement.gd").new(),
	Piece.WHITE_KING: load("res://Scripts/king_movement.gd").new(),
	Piece.BLACK_KING: load("res://Scripts/king_movement.gd").new()
}

func string_to_vector3(position_str):
	var x = int(position_str[0]) - 97
	var z = int(position_str[1]) - 1
	return Vector3(x, 0, z)

func vector3_to_string(position_vec):
	var rank = char(int(position_vec.x) + 97)
	var row = str(int(position_vec.z) + 1)
	return rank + row

func is_valid_position(position_vec):
	return position_vec.x >= 0 and position_vec.x < 8 and position_vec.z >= 0 and position_vec.z < 8
