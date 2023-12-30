extends Label

@export var player: CharacterBody2D

func _ready():
	player.bulletsChanged.connect(update)
	update()

func update():
	text = str(player.bullets)
