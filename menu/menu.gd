extends Control

signal border_enabled(toggled_on: bool)
signal level_transition_start()
signal level_transition_end()

const toggle_sound : AudioStreamWAV = preload("res://addons/kenney_interface_sounds/switch_007.wav")
const quit_sound : AudioStreamWAV = preload("res://addons/kenney_interface_sounds/minimize_003.wav")
const play_sound : AudioStreamWAV = preload("res://addons/kenney_interface_sounds/confirmation_001.wav")
const focus_sound : AudioStreamWAV = preload("res://addons/kenney_interface_sounds/glass_006.wav")
const GAME_OVER : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack fighter/game_over.ogg")
const YOU_WIN : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack fighter/you_win.ogg")
const YOU_LOSE : AudioStreamOggVorbis = preload("res://addons/kenney voiceover pack/voice type 2/you_lose.ogg")

const LEVEL_1 = preload("res://level/level1.tscn")
const LEVEL_2 = preload("res://level2/level2.tscn")

@onready
var sfx : AudioStreamPlayer = $"Sfx"

@onready
var voice : AudioStreamPlayer = $"Voice"

@onready
var music : AudioStreamPlayer = $"Music"

var _debounce := false


func _process(_delta):
	if Input.is_action_pressed("exit_to_desktop"):
		quit()
		
	if Input.is_action_pressed("exit_to_menu"):
		back_to_main()


func play():
	play_level2()

func play_level1() -> void:
	play_level(LEVEL_1, play_level2)

func play_level2() -> void:
	play_level(LEVEL_2, game_over)


func play_level(level: PackedScene, end_callback) -> void:
	if _debounce:
		return
	_debounce = true
	sfx.stream = play_sound
	sfx.play(0)
	level_transition_start.emit()
	await get_tree().create_timer(0.5).timeout # give time
	
	var last_level = get_node_or_null("../current_level")
	if is_instance_valid(last_level):
		last_level.visible = false
		last_level.get_parent().remove_child(last_level)
		last_level.free() # using free directly to avoid error with multiple phantom cameras
		
	var instance = level.instantiate()
	instance.name = "current_level"
	instance.level_complete.connect(end_callback)
	instance.level_failed.connect(func(): game_over(false))
	add_sibling(instance)
	music.stop()
	visible = false
	instance.visible = true
	level_transition_end.emit()
	await get_tree().create_timer(0.5).timeout # give time
	_debounce = false


func game_over(succeed: = true) -> void:
	if _debounce:
		return
	_debounce = true
	level_transition_start.emit()
	voice.stream = GAME_OVER
	voice.play(0)
	await voice.finished
	var level_node = get_node_or_null("../current_level")
	if is_instance_valid(level_node):
		level_node.visible = false
		level_node.queue_free()
	voice.stream = YOU_WIN if succeed else YOU_LOSE
	voice.play(0)
	await voice.finished
	music.play()
	visible = true
	level_transition_end.emit()
	await get_tree().create_timer(0.5).timeout # give time
	_debounce = false


func back_to_main() -> void:
	if _debounce:
		return
	_debounce = true
	sfx.stream = quit_sound
	sfx.play(0)
	level_transition_start.emit()
	await get_tree().create_timer(0.5).timeout
	var level_node = get_node_or_null("../current_level")
	if is_instance_valid(level_node):
		level_node.visible = false
		level_node.queue_free()
	music.play()
	visible = true
	level_transition_end.emit()
	await get_tree().create_timer(0.5).timeout # give time
	_debounce = false


func _on_sinden_borders_toggled(toggled_on):
	border_enabled.emit(toggled_on)
	sfx.stream = toggle_sound
	sfx.play(0)


func quit():
	if _debounce:
		return
	_debounce = true
	sfx.stream = quit_sound
	sfx.play(0)
	level_transition_start.emit()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_button_focus():
	sfx.stream = focus_sound
	sfx.play(0)
