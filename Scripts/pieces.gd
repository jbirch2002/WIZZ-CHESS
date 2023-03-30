extends Node3D

enum Player {
	WHITE,
	BLACK
}

var color = Player.WHITE
var board_position = ""

# Pieces
var pieces = {
	"white": {
		"WP": preload("res://Scenes/WH_Pieces/wh_pawn_starting_p.tscn"),
		"WR": preload("res://Scenes/WH_Pieces/wh_rook_starting_p.tscn"),
		"WH": preload("res://Scenes/WH_Pieces/wh_knight_starting_p.tscn"),
		"WB": preload("res://Scenes/WH_Pieces/wh_bishop_starting_p.tscn"),
		"WQ": preload("res://Scenes/WH_Pieces/wh_queen_starting_p.tscn"),
		"WK": preload("res://Scenes/WH_Pieces/wh_king_starting_p.tscn")
	},
	"black": {
		"BP": preload("res://Scenes/BLK_Pieces/blk_pawn_starting_p.tscn"),
		"BR": preload("res://Scenes/BLK_Pieces/blk_rook_starting_p.tscn"),
		"BH": preload("res://Scenes/BLK_Pieces/blk_knight_starting_p.tscn"),
		"BB": preload("res://Scenes/BLK_Pieces/blk_bishop_starting_p.tscn"),
		"BQ": preload("res://Scenes/BLK_Pieces/blk_queen_starting_p.tscn"),
		"BK": preload("res://Scenes/BLK_Pieces/blk_king_starting_p.tscn")
	}
}

func _init(_color, _position):
	color = _color
	position = _position
