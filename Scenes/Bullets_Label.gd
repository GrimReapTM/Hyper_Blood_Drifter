extends Label

@export var player: CharacterBody2D

func _ready():
	player.bulletsChanged.connect(update)
	update()

func update():
	text = str(player.bullets)
	if player.bullets == player.maxBullets:
		label_settings.font_color = Color("87b5ed")
	else:
		label_settings.font_color = Color("fefcf6")
