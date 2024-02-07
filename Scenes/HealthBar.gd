extends TextureProgressBar

@export var player: CharacterBody2D
@export var rallyBar: TextureProgressBar
@export var deathscreen: Control

func _ready():
	player.healthChanged.connect(update)
	player.attacked.connect(rally)
	update()
	rally()

func update():
	value = player.healthPoints * 100 / player.maxHealthPoints
	if player.healthPoints < 1:
		death()
		player.b_echoes -= player.b_echoes / 2

func rally():
	if value < rallyBar.value:
		if value + player.maxHealthPoints / 100 * 7 <= rallyBar.value:
			value += player.maxHealthPoints / 100 * 5
			player.healthPoints += player.maxHealthPoints / 100 * 5
		else:
			value = rallyBar.value
			player.healthPoints = player.maxHealthPoints / 100 * value

func death():
	player.dead = true
	deathscreen.update()
	player.animations.play("death")
	#await player.animations.animation_finished
	deathscreen.visible = true
