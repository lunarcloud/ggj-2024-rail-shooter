extends Node3D

var section_targets := [
	1,
	1,
	3
]

@onready
var section_1 : PhantomCamera3D = $Shots/Section1

@onready
var section_2 : PhantomCamera3D = $Shots/Section2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_shot():
	section_targets[1] -= 1
	if section_targets[1] <= 0:
		section_1.set_priority(0)
		section_2.set_priority(1)
