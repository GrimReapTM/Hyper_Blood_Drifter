extends Label

@export var player: CharacterBody2D
@export var bullets: Sprite2D

func _ready():
	player.b_bulletsChanged.connect(update)
	update()

func update():
	if player.b_bullets != 0:
		bullets.frame = 1
		visible = true
		text = "+" + str(player.b_bullets)
	else:
		visible = false
		bullets.frame = 0
