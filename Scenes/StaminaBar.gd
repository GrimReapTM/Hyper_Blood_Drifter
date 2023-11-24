extends TextureProgressBar

@export var player: CharacterBody2D

func _ready():
	player.staminaChanged.connect(update)

func update():
	value = player.stamina * 100 / player.maxStamina
