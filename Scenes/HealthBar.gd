extends TextureProgressBar

@export var player: CharacterBody2D
@export var rallyBar: TextureProgressBar

func _ready():
	player.healthChanged.connect(update)
	player.attacked.connect(rally)
	update()
	rally()

func update():
	value = player.healthPoints * 100 / player.maxHealthPoints
	if player.healthPoints < 1:
		get_tree().change_scene_to_file("res://Scenes/areas/Dream.tscn")
		player.b_echoes -= player.b_echoes / 2

func rally():
	if value < rallyBar.value:
		if value + player.maxHealthPoints / 100 * 7 <= rallyBar.value:
			value += player.maxHealthPoints / 100 * 5
			player.healthPoints += player.maxHealthPoints / 100 * 5
		else:
			value = rallyBar.value
			player.healthPoints = player.maxHealthPoints / 100 * value

