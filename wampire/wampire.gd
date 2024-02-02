class_name Wampire
extends ShotTargetAnimationHandler

const BLAH = preload("res://wampire/blah.wav")
const HANDLE_FINGERGUNS = preload("res://wampire/handle_fingerguns.wav")

@onready
var audio : AudioStreamPlayer3D = $AudioVoice

@onready
var head1 : Node3D = $Sprites/HeadGroup1

@onready
var head2 : Node3D = $Sprites/HeadGroup2

func _on_target_hurt():
	head1.visible = false
	head2.visible = true
	audio.stream = BLAH
	audio.play(0)
	await get_tree().create_timer(0.5).timeout
	head2.visible = false
	head1.visible = true


func _on_target_shot():
	target_shot.emit()


func introduce() -> void:
	if is_instance_valid(audio):
		audio.stream = HANDLE_FINGERGUNS
		audio.play(0)


func ready_to_fire() -> void:
	if is_instance_valid(anim):
		anim.play("Ready")


func firing_fingerguns() -> void:
	if is_instance_valid(anim):
		anim.play("Fingerguns")


func idle() -> void:
	if is_instance_valid(anim):
		anim.play("Cloaked")

