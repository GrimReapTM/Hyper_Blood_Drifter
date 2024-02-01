extends Area2D

@export var speed = 1000
var direction = Vector2()
var grav = 1

func _ready():
	direction = position.direction_to(get_global_mouse_position())

func _on_pebble_hitbox_body_entered(body):
	if body.name != "Player":
		g.sound.emit()
		queue_free()

func _on_gravity_start_timeout():
	$Gravity.start()
	grav = 1

func _on_gravity_timeout():
	grav = grav / 1.3

func _physics_process(delta):
	position = position + speed * direction * delta * grav

	if grav <= 0.05:
		g.sound.emit()
		queue_free()

