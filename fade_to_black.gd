extends TextureRect


func _ready() -> void:
	modulate = Color.WHITE
	await get_tree().create_timer(0.4).timeout
	to_transparent()


func to_black(duration := 0.5) -> void:
	var tween = create_tween()
	await tween.tween_property(self, "modulate", Color.WHITE, duration).finished


func to_transparent(duration := 0.5) -> void:
	var tween = create_tween()
	await tween.tween_property(self, "modulate", Color.TRANSPARENT, duration).finished
