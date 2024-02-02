class_name Level
extends Node3D

var current_section := 0
var section_targets : Array[int] = []
var section_skip_time : Array[float] = []

var level_is_complete := false
signal level_complete
signal level_failed
signal section_update(section: int)

@export_range(3, 12)
var total_bullets := 6

var hard_mode := false

@export_range(15.0, 90.0)
var easy_timeout_seconds := 40.0

@export_range(15.0, 90.0)
var hard_timeout_seconds := 40.0

@onready
var hud : PlayerHUD = $"Player/HUD"

@onready
var player : Player = $"Player"

@onready
var shots : Node3D = $"Shots"

@onready
var sfx : AudioStreamPlayer = $"Player/Sfx"

@onready
var music : AudioStreamPlayer = $"Music"

@onready
var voice : AudioStreamPlayer = $"Player/Voice"

var level_timer : SceneTreeTimer

const READY : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack fighter/ready.ogg")
const GO : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/go.ogg")
const MISSION_COMPLETED : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/mission_completed.ogg")
const MISSION_FAILED : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/mission_failed.ogg")

func _ready():
	hud.set_bullets(total_bullets)
	hud.set_targets(section_targets[current_section])
	var level_time := hard_timeout_seconds if hard_mode else easy_timeout_seconds
	hud.set_timer(level_time)
	level_timer = get_tree().create_timer(level_time)
	
	var fail_callback = func(): 
		if level_is_complete:
			return
		level_is_complete = true
		level_failed.emit()
	level_timer.timeout.connect(fail_callback)
	
	player.bullets = total_bullets
	player.total_bullets = total_bullets
	
	voice.stream = READY
	voice.play(0)
	await voice.finished
	voice.stream = GO
	voice.play(0)


func _process(_delta):
	if level_is_complete:
		return
	hud.set_timer(level_timer.time_left)


func _on_target_shot():
	if level_is_complete:
		return
	section_targets[current_section] -= 1
	hud.set_targets(section_targets[current_section])
	update_camera()


func _on_innocent_shot():
	if level_is_complete:
		return
	level_is_complete = true
	voice.stream = MISSION_FAILED
	voice.play(0)
	await voice.finished
	level_failed.emit()
	update_camera()


func update_camera() -> void:
	if level_is_complete or section_targets[current_section] > 0:
		return
	
	shots.get_child(current_section).set_priority(0)
	current_section += 1
	section_update.emit(current_section+1)
	
	if shots.get_children().size() <= current_section or not is_instance_valid(shots.get_child(current_section)):
		complete_level()
	else:
		shots.get_child(current_section).set_priority(1)
		hud.set_targets(section_targets[current_section])
		if section_targets[current_section] <= 0:
			var auto_time = 0.5
			if current_section < section_skip_time.size() or section_skip_time[current_section] != null:
				auto_time = section_skip_time[current_section]
			await get_tree().create_timer(auto_time).timeout
			update_camera()


func complete_level() -> void:
	level_is_complete = true
	voice.stream = MISSION_COMPLETED
	voice.play(0)
	await voice.finished
	await get_tree().create_timer(1).timeout
	level_complete.emit()
