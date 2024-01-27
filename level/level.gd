class_name Level
extends Node3D

var current_section := 0
var section_targets : Array[int] = []
var section_cams : Array[PhantomCamera3D]

var level_is_complete := false
signal level_complete

@export_range(3, 12)
var total_bullets := 12

@onready
var hud : PlayerHUD = $"Player/HUD"

@onready
var player : Player = $"Player"

@onready
var sfx : AudioStreamPlayer = $"Player/Sfx"

@onready
var music : AudioStreamPlayer = $"Music"

@onready
var voice : AudioStreamPlayer = $"Player/Voice"

const READY : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack fighter/ready.ogg")
const GO : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/go.ogg")
const MISSION_COMPLETED : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/mission_completed.ogg")

func _ready():
	hud.set_bullets(total_bullets)
	player.bullets = total_bullets
	player.total_bullets = total_bullets
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
	if current_section >= section_cams.size() or not is_instance_valid(section_cams[current_section]):
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
