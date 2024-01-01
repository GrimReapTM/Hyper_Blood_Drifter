extends Label

@export var player: CharacterBody2D

func _ready():
	player.b_echoesChanged.connect(update)
	update()

func update():
	text = str(player.b_echoes)
