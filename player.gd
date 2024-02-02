class_name Player
extends Node3D

const GUNFIRE = preload("res://addons/gunfire.wav")
const GUNRELOAD_1 = preload("res://addons/gunreload1.wav")
const GUNRELOAD_2 = preload("res://addons/gunreload2.wav")
const EMPTYFIRE = preload("res://addons/kenney_interface_sounds/error_003.wav")

@onready
var sfx : AudioStreamPlayer = $"Sfx"

@export_flags_3d_physics
var bullet_collision_mask : int = 0

var _debounce := false

const RAY_LENGTH = 1000

var bullets : int

@export_range(3, 12)
var total_bullets := 12

signal shot_fired
signal reloaded

# Called when the node enters the scene tree for the first time.
func _ready():
	bullets = total_bullets

func _process(_delta):
	if _debounce:
		return
	
	if Input.is_action_just_pressed("shoot"):
		_debounce = true
		_shoot();

	if Input.is_action_just_pressed("reload"):
		_debounce = true
		_reload()
	
	if _debounce:
		get_tree().create_timer(0.25).timeout.connect(_rearm_debounce)


func _rearm_debounce() -> void:
	_debounce = false


func _shoot() -> void:
	# Audio
	sfx.stream = GUNFIRE if bullets > 0 else EMPTYFIRE
	sfx.pitch_scale = randf_range(0.9, 1.4)
	sfx.play(0)
	
	if bullets <= 0:
		return
	bullets -= 1
	
	shot_fired.emit()
	
	# Raycast
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, bullet_collision_mask)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	if not result.is_empty() and result.collider is ShotTarget:
		result.collider.shoot()

func _reload() -> void:
	if bullets >= total_bullets:
		return
	
	# Audio
	sfx.stream = GUNRELOAD_1 if randi() % 2 else GUNRELOAD_2
	sfx.pitch_scale = randf_range(0.9, 1.4)
	sfx.play(0)
	
	bullets = total_bullets
	reloaded.emit()
