class_name ShotTargetAnimationHandler
extends Node

signal target_shot

signal innocent_shot

@onready
var anim : AnimationPlayer = $Target/AnimationPlayer


func _on_target_shot():
	target_shot.emit()


func _on_innocent_shot():
	innocent_shot.emit()
