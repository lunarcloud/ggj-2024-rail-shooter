class_name PlayerHUD
extends Control

@onready
var bullet_box : VBoxContainer = $Panel/Bullet

@onready
var timer_label : Label = $Panel2/HBoxContainer/TimerLabel

@onready
var targets_label : Label = $Panel2/HBoxContainer/TargetsText


func set_timer(seconds: float) -> void:
	timer_label.text = "%d" % seconds


func set_targets(targets: int) -> void:
	targets_label.text = "%d" % targets


func set_bullets(total_bullets: int = 12) -> void:
	var bullet_template := bullet_box.get_child(0)
	for i in range(total_bullets - 1):
		var bullet = bullet_template.duplicate()
		bullet_box.add_child(bullet)


func _on_player_shot_fired():
	var bullets := bullet_box.get_children()
	for bullet in bullets:
		if bullet.visible:
			bullet.visible = false
			return

func _on_player_reloaded():
	var bullets := bullet_box.get_children()
	for bullet in bullets:
		bullet.visible = true
