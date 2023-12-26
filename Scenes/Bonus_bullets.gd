extends Label

@export var player: CharacterBody2D

func _ready():
	player.b_bulletsChanged.connect(update)
	update()

func update():
	if player.b_bullets != 0:
		visible = true
		text = "+" + str(player.b_bullets)
	else:
		visible = false
