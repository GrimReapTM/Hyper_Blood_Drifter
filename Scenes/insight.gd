extends Label

@export var player: CharacterBody2D

func _ready():
	player.insightChanged.connect(update)
	update()

func update():
	text = str(player.insight)
