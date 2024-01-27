extends Panel

@export 
var border_size := 40: set = _set_border_size

@export_color_no_alpha
var border_color := Color.WHITE: set = _set_border_color

const STANDARD_WHITE := Color.AQUA 
const STANDARD_BLUE := Color.AQUA 

var style := StyleBoxFlat.new()


func _ready() -> void:
	style.bg_color = Color.TRANSPARENT
	style.border_color = border_color
	_set_border_size(border_size)
	add_theme_stylebox_override("panel", style)


func _set_border_size(new_size: int) -> void:
	border_size = new_size
	style.border_width_top = border_size
	style.border_width_bottom = border_size
	style.border_width_left = border_size
	style.border_width_right = border_size


func _set_border_color(new_color: Color) -> void:
	border_color = new_color
	style.border_color = border_color


func _on_border_toggled(toggled_on: bool):
	visible = toggled_on
