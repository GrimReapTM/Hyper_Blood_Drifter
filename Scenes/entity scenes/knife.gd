extends Area2D

@export var marker: Marker2D
@export var speed = 1000
var direction = Vector2()

func _ready():
	direction = position.direction_to(get_global_mouse_position())
	marker.look_at(get_global_mouse_position())

func _on_knife_hitbox_area_entered(area):
	if area.name == "enemy_hurtbox":
		queue_free()

func _on_knife_hitbox_body_entered(body):
	if body.name != "Player":
		queue_free()

func _physics_process(delta):
	position = position + speed * direction * delta


