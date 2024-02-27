extends TextureProgressBar

@export var player: CharacterBody2D
@export var rallyBar: TextureProgressBar
@export var deathscreen: Control
@export var sfx: Node2D

var dead = false

func _ready():
	g.hpChanged.connect(update)
	player.attacked.connect(rally)
	update()
	rally()

func update():
	value = g.hp * 100 / g.maxhp
	if g.hp < 1 and not dead:
		death()
		g.b_echoes -= g.b_echoes / 2

func rally():
	if value < rallyBar.value:
		if value + g.maxhp / 100 * 7 <= rallyBar.value:
			value += g.maxhp / 100 * 5
			g.hp += g.maxhp / 100 * 5
		else:
			value = rallyBar.value
			g.hp = g.maxhp / 100 * value

func death():
	player.dead = true
	g.dead = true
	dead = true
	deathscreen.update()
	sfx.effects("dead")
	player.animations.play("death")
	await player.animations.animation_finished
	deathscreen.visible = true
