extends Level

@onready
var wampire_anim : AnimationPlayer = $Targets/Wampire/WampireAttackAnim

const FRIGHT_NIGHT_TWIST = preload("res://level2/Fright Night Twist.mp3")
const COMPAT_RENDER_ENV = preload("res://level2/compat_render_env.tres")
const FORWARD_RENDERER_ENV = preload("res://level2/forward_renderer_env.tres")

var _wampire_section := 10

func _ready():
	$WorldEnvironment.environment = \
		COMPAT_RENDER_ENV if RenderingServer.get_rendering_device() == null \
		else FORWARD_RENDERER_ENV
	section_targets =   [1,		0,		0,		1,	0,		2,	0,		0,	0,	1]
	section_skip_time = [0,		1.5,	1.5,	0,	1.5,	0,	1.5,	1,	1,	0]
	super()


func _on_section_update(section: int) -> void:
	if section == 9: # just before wampire
		music.stream = FRIGHT_NIGHT_TWIST
		music.play(0)
	elif section == 10: # only for wampire
		wampire_anim.play("Attack")


func _on_wampire_target_shot():
	# make sure he doesn't keep jumping around
	wampire_anim.pause()


func _on_moon_shot():
	if current_section == _wampire_section:
		return
		
	for section in range(current_section, _wampire_section - 1):
		if section_skip_time[section] == 0:
			section_targets[section] = 0
			section_skip_time[section] = 5
	
	await get_tree().create_timer(5).timeout
	update_camera()
