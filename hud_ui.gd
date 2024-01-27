class_name PlayerHUD
extends Control

func set_bullets(total_bullets: int = 12) -> void:
	var bullets := $Bullet.get_children()
	var counted := 0
	for bullet in bullets:
		counted += 1
		if counted <= total_bullets:
			continue
		bullet.queue_free()


func _on_player_shot_fired():
	var bullets := $Bullet.get_children()
	for bullet in bullets:
		if bullet.visible:
			bullet.visible = false
			return

func _on_player_reloaded():
	var bullets := $Bullet.get_children()
	for bullet in bullets:
		bullet.visible = true
