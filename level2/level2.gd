extends Level

@onready
var wampire_anim : AnimationPlayer = $Targets/Wampire/WampireAttackAnim

const FRIGHT_NIGHT_TWIST = preload("res://level2/Fright Night Twist.mp3")


func _ready():
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
