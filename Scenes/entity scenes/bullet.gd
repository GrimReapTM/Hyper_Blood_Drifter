extends Area2D

@export var speed = 2500
var direction = Vector2()
var spawned = true
var wait = false


func _physics_process(delta):
	if spawned:
		direction = position.direction_to(get_global_mouse_position())
		spawned = false
	position = position + speed * direction * delta
	wait = true


func _on_bullet_hitbox_body_entered(body):
	if wait and body.name != "Player":
		queue_free()

