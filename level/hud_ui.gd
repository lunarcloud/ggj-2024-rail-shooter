extends Control


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
