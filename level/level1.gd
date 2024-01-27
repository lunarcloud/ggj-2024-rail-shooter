extends Level

func _ready():
	section_targets = [1, 1, 0, 4]
	section_cams = [
		$Shots/Section1,
		$Shots/Section2,
		$Shots/Section3,
		$Shots/Section4
	]
	super()
