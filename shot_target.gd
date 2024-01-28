class_name ShotTarget
extends Area3D

signal target_hurt
signal target_shot

@export
var hits: int = 1


func shoot():	
	target_hurt.emit()

	hits -= 1
	if hits > 0:
		return
	
	var anim : AnimationPlayer = get_node_or_null("AnimationPlayer")
	if is_instance_valid(anim):
		anim.play("Shot")
		await get_tree().create_timer(0.5).timeout
	
	target_shot.emit()
	queue_free()
