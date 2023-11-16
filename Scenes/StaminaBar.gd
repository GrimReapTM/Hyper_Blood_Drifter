extends TextureProgressBar

@export var player: CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = player.stamina * 100 / player.maxStamina

