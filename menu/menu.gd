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

@onready
var quit_button : Button = $VBoxContainer/HBoxContainer/QuitButton

@onready
var fullscreen_toggle : CheckButton = $VBoxContainer/HBoxContainer2/VBoxContainer2/FullscreenToggle

@onready
var hardmode_toggle : CheckButton = $VBoxContainer/HBoxContainer2/VBoxContainer/HardModeToggle

@onready
var border_toggle : CheckButton = $VBoxContainer/HBoxContainer2/VBoxContainer/BorderToggle

@onready
var msaa_toggle : CheckButton = $VBoxContainer/HBoxContainer2/VBoxContainer2/AAToggle

@onready
var skip_level1_toggle : CheckButton = $VBoxContainer/HBoxContainer2/VBoxContainer/SkipLevel1Toggle

@onready
var quality_slider : HSlider = $VBoxContainer/HBoxContainer2/VBoxContainer2/QualitySetting/HSlider

@onready
var quality_slider_label : Label = $VBoxContainer/HBoxContainer2/VBoxContainer2/QualitySetting/ValueLabel
	
var _debounce := false

var graphics_compat_mode = RenderingServer.get_rendering_device() == null

var config = ConfigFile.new()
var configs_ready := false
const settings_path := "user://settings.cfg"

@onready
var msaa_enabled = get_viewport().msaa_3d != Viewport.MSAA_DISABLED

var current_msaa_2d = Viewport.MSAA_8X
var current_msaa_3d = Viewport.MSAA_4X

func _ready() -> void:	
	match OS.get_name():
		"Windows", "Linux":
			border_toggle.visible = true
		"Web":
			border_toggle.visible = true # It might be a windows/linux web user
			quit_button.visible = false # quit doesn't make sense
		_:
			border_toggle.visible = false # Sinden driver not available

	fullscreen_toggle.button_pressed = get_window().mode == Window.MODE_FULLSCREEN
	msaa_toggle.toggled.connect(change_msaa)
	
	# Load data from the settings file.
	var err = config.load(settings_path)

	if err == OK:
		current_msaa_3d = config.get_value("anti_aliasing", "msaa_3d", current_msaa_3d)
		current_msaa_2d = config.get_value("anti_aliasing", "msaa_2d", current_msaa_2d)
		msaa_enabled = config.get_value("anti_aliasing", "msaa_3d", current_msaa_3d != Viewport.MSAA_DISABLED)
		var fullscreen = config.get_value("window", "mode", get_window().mode)
		toggle_fullscreen(fullscreen)
		var scaleA : float = config.get_value("scaling_3d", "scale", 0.75)
		quality_slider.value = scaleA
		graphics_scale_changed(scaleA)
		configs_ready = true
	else:
		quality_slider.value = ProjectSettings.get_setting("rendering/scaling_3d/scale")
	
	msaa_toggle.button_pressed = msaa_enabled


func _process(_delta):
	if Input.is_action_pressed("exit_to_desktop"):
		quit()
		
	if Input.is_action_pressed("exit_to_menu"):
		back_to_main()


func change_msaa(on: bool):
	var viewport := get_viewport()
	viewport.msaa_2d = current_msaa_2d if on else Viewport.MSAA_DISABLED
	viewport.msaa_3d = current_msaa_3d if on else Viewport.MSAA_DISABLED
	viewport.use_debanding = on
	msaa_enabled = on
	
	if not configs_ready:
		return
	# Update settings
	config.set_value("anti_aliasing", "msaa_3d", viewport.msaa_3d)
	config.set_value("anti_aliasing", "msaa_2d", viewport.msaa_2d)
	config.save(settings_path)


func toggle_native_or_1080p_mode(is_native_3d: bool):
	get_window().content_scale_mode = \
		Window.CONTENT_SCALE_MODE_CANVAS_ITEMS if is_native_3d \
		else Window.CONTENT_SCALE_MODE_VIEWPORT


func graphics_scale_changed(value: float):
	quality_slider_label.text = "%d %%" % (value * 100)
	# Change the scaling factor and switch 3d scaling
	var window := get_window()
	window.scaling_3d_scale = value
	
	# Adjust MSAA amount
	match value:
		0.5, 0.75:
			current_msaa_2d = Viewport.MSAA_8X 
			current_msaa_3d = Viewport.MSAA_4X
		1.0:
			current_msaa_2d = Viewport.MSAA_8X 
			current_msaa_3d = Viewport.MSAA_4X
		_:
			current_msaa_2d = Viewport.MSAA_2X 
			current_msaa_3d = Viewport.MSAA_2X
	var viewport := get_viewport()
	viewport.msaa_2d = current_msaa_2d if msaa_enabled else Viewport.MSAA_DISABLED
	viewport.msaa_3d = current_msaa_3d if msaa_enabled else Viewport.MSAA_DISABLED
	
	if not configs_ready:
		return
	# Update settings
	config.set_value("scaling_3d", "scale", value)
	config.set_value("anti_aliasing", "msaa_3d", viewport.msaa_3d)
	config.set_value("anti_aliasing", "msaa_2d", viewport.msaa_2d)
	config.save(settings_path)


func toggle_fullscreen(fullscreen: bool):
	var window := get_window()
	
	if fullscreen:
		window.mode = Window.MODE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
		await get_tree().create_timer(0.2).timeout
		window.move_to_center.call_deferred()
	
	if not configs_ready:
		return
	# Update settings
	config.set_value("window", "mode", window.mode)
	config.save(settings_path)


func play():
	play_level2() if skip_level1_toggle.button_pressed \
		else play_level1()


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
	instance.hard_mode = hardmode_toggle.button_pressed
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
