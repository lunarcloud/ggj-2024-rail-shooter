class_name ShotTargetAnimationHandler
extends Node


signal target_shot


func _on_target_shot():
	target_shot.emit()
