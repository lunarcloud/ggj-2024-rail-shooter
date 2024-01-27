extends Control

signal border_enabled(toggled_on: bool)

func play():
	pass # Replace with function body.


func _on_sinden_borders_toggled(toggled_on):
	border_enabled.emit(toggled_on)


func quit():
	get_tree().quit()
