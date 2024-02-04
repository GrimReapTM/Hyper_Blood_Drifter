extends TextureProgressBar

@export var player: CharacterBody2D

func _ready():
	player.beastBloodChanged.connect(update)

func update():
	value = g.beast_damage * 100 / g.max_beast_damage
