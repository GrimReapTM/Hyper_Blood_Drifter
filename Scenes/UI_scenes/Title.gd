extends Sprite2D

@onready var animations = $AnimationPlayer
@export var menu: Control
@export var buttons: Node2D

func _ready():
	menu.press.connect(wake_up)
	animations.play("idle")
	

func wake_up():
	animations.play("wake_up")
	await animations.animation_finished
	buttons.visible = true
	animations.queue("woke_idle")
