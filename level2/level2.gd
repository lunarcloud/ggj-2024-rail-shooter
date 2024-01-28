extends Level

@onready
var wampire_anim : AnimationPlayer = $Targets/Wampire/WampireAttackAnim


func _ready():
	section_targets =   [1,		0,		0,		1,	0,		2,	0,		0,	0,	1]
	section_skip_time = [0,		1.5,	1.5,	0,	1.5,	0,	1.5,	1,	1,	0]
	super()


func _on_section_update(section: int) -> void:
	if section == 9: # only for wampire
		wampire_anim.play("Attack")
		
