extends TextureProgressBar

@export var enemy: CharacterBody2D

func _ready():
	enemy.healthChanged.connect(update)
	update()


func update():
	value = enemy.hp * 100 / enemy.maxHp
	if value < 100:
		visible = true
