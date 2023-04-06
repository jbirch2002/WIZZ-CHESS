extends Node3D

const WHITE_PAWN = "WP"
const WHITE_ROOK = "WR"
const WHITE_KNIGHT = "WH"
const WHITE_BISHOP = "WB"
const WHITE_QUEEN = "WQ"
const WHITE_KING = "WK"
const BLACK_PAWN = "BP"
const BLACK_ROOK = "BR"
const BLACK_KNIGHT = "BH"
const BLACK_BISHOP = "BB"
const BLACK_QUEEN = "BQ"
const BLACK_KING = "BK"

enum Player {
	WHITE,
	BLACK
}

enum Piece {
	PAWN,
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING
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
	WHITE_PAWN: preload("res://Scenes/WH_Pieces/wh_pawn_starting_p.tscn"),
	WHITE_ROOK: preload("res://Scenes/WH_Pieces/wh_rook_starting_p.tscn"),
	WHITE_KNIGHT: preload("res://Scenes/WH_Pieces/wh_knight_starting_p.tscn"),
	WHITE_BISHOP: preload("res://Scenes/WH_Pieces/wh_bishop_starting_p.tscn"),
	WHITE_QUEEN: preload("res://Scenes/WH_Pieces/wh_queen_starting_p.tscn"),
	WHITE_KING: preload("res://Scenes/WH_Pieces/wh_king_starting_p.tscn"),
	BLACK_PAWN: preload("res://Scenes/BLK_Pieces/blk_pawn_starting_p.tscn"),
	BLACK_ROOK: preload("res://Scenes/BLK_Pieces/blk_rook_starting_p.tscn"),
	BLACK_KNIGHT: preload("res://Scenes/BLK_Pieces/blk_knight_starting_p.tscn"),
	BLACK_BISHOP: preload("res://Scenes/BLK_Pieces/blk_bishop_starting_p.tscn"),
	BLACK_QUEEN: preload("res://Scenes/BLK_Pieces/blk_queen_starting_p.tscn"),
	BLACK_KING: preload("res://Scenes/BLK_Pieces/blk_king_starting_p.tscn"),
}


var piece_movement = {
	Piece.PAWN: load("res://Scripts/pawn_movement.gd").new(),
	Piece.ROOK: load("res://Scripts/rook_movement.gd").new(),
	Piece.KNIGHT: load("res://Scripts/knight_movement.gd").new(),
	Piece.BISHOP: load("res://Scripts/bishop_movement.gd").new(),
	Piece.QUEEN: load("res://Scripts/queen_movement.gd").new(),
	Piece.KING: load("res://Scripts/king_movement.gd").new()
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
