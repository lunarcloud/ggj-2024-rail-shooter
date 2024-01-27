class_name ShotTarget
extends Area3D

signal target_shot

func shoot():
	print("%s Shot!" % [name])
	target_shot.emit()
	queue_free()
