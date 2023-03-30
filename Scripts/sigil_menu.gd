extends Panel

# Variables for UI elements
var sigil_buttons
var confirm_button
var ether_label

# Variables for ether and sigil costs
var ether = 20
var sigil_costs = {"Common": -2, "Rare": -4, "Unique": -8}

# Other variables and signals
var selected_sigil = null

func _ready():
	# Get UI elements and connect button signals to the script
	sigil_buttons = $VBoxContainer/HBoxContainer.get_children()
	for button in sigil_buttons:
		button.connect("pressed", self, "_on_sigil_button_pressed", [button])

	confirm_button = $VBoxContainer/ConfirmButton
	confirm_button.connect("pressed", self, "_on_confirm_button_pressed")

	ether_label = $VBoxContainer/EtherLabel
	ether_label.text = "Ether: " + str(ether)

func _on_sigil_button_pressed(button):
	# Deselect all other buttons
	for b in sigil_buttons:
		b.pressed = false

	# Select the current button
	button.pressed = true
	selected_sigil = button.get_meta("sigil")

func _on_confirm_button_pressed():
	if selected_sigil != null:
		# Emit the sigil_confirmed signal with the selected sigil
		emit_signal("sigil_confirmed", selected_sigil)

		# Reset the UI state
		for button in sigil_buttons:
			button.pressed = false
		selected_sigil = null
