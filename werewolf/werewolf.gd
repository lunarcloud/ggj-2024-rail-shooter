class_name Werewolf
extends ShotTargetAnimationHandler

func _ready() -> void:
	# Male or female randomized
	$DeWolfed/Sprites/Head/Hair.visible = randi() % 2

func tranform_human():
	var target : CollisionShape3D = $Target/CollisionShape3D
	if is_instance_valid(target):
		target.disabled = true
	
	anim.play("Transform")
	
	await get_tree().create_timer(2.5).timeout
	
	var new_target : CollisionShape3D = $DeWolfed/Target/CollisionShape3D
	new_target.disabled = false
