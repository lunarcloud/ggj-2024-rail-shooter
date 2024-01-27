extends Node3D

var current_section := 0

var section_targets := [
	1,
	1,
	0,
	4
]

var level_is_complete := false
signal level_complete

@onready
var section_cams : Array[PhantomCamera3D] = [
	$Shots/Section1,
	$Shots/Section2,
	$Shots/Section3,
	$Shots/Section4
]

@onready
var sfx : AudioStreamPlayer = $"Player/Sfx"

@onready
var music : AudioStreamPlayer = $"Music"

@onready
var voice : AudioStreamPlayer = $"Player/Voice"

const READY : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack fighter/ready.ogg")
const GO : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/go.ogg")
const MISSION_COMPLETED : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/mission_completed.ogg")


# Called when the node enters the scene tree for the first time.
func _ready():
	voice.stream = READY
	voice.play(0)
	await voice.finished
	voice.stream = GO
	voice.play(0)


func _on_target_shot():
	if level_is_complete:
		return
	section_targets[current_section] -= 1
	update_camera()


func update_camera() -> void:
	if level_is_complete:
		return

	if section_targets[current_section] > 0:
		return
	section_cams[current_section].set_priority(0)
	current_section += 1
	if current_section >= section_cams.size():
		complete_level()
	else:
		section_cams[current_section].set_priority(1)
		if section_targets[current_section] <= 0:
			await get_tree().create_timer(1).timeout
			update_camera()


func complete_level() -> void:
	level_is_complete = true
	voice.stream = MISSION_COMPLETED
	voice.play(0)
	await voice.finished
	level_complete.emit()
