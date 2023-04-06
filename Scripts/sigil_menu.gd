extends Control

# Constants
const valid_sigils = {
	[Pieces.Sigil.CATTY_CORNER, Pieces.Sigil.SELF_DESTRUCT],
	[Pieces.Sigil.CATTY_CORNER, Pieces.Sigil.SELF_DESTRUCT]
}

signal sigil_selected(sigil)

var list_box

func _ready():
	var list_box = $ScrollContainer/ListBox
	hide_menu()

func show_menu(valid_piece_sigils: Array):
	# Clear the ListBox
	list_box.clear()

	# Populate the ListBox with valid sigils for the selected piece
	for sigil in valid_piece_sigils:
		list_box.add_item(sigil)

	# Show the SigilSelection Control
	visible = true

func hide_menu():
	visible = false

func _on_ListBox_item_selected(index):
	var selected_sigil = Pieces.Sigil.values()[index]

	# Emit the sigil_selected signal
	emit_signal("sigil_selected", selected_sigil)

	# Hide the SigilSelection Control
	hide_menu()

func _on_CancelButton_pressed():
	# Hide the SigilSelection Control
	hide_menu()
