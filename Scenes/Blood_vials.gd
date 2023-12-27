extends Label

@export var player: CharacterBody2D

func _ready():
	player.vialsChanged.connect(update)
	update()

func update():
	text = "H: " + str(player.b_vials)
