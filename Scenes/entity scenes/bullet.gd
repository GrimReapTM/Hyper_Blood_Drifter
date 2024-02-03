extends Area2D

@export var speed = 2500
var direction = Vector2()
@export var ID = ""

func _ready():
	if ID == "player":
		direction = position.direction_to(get_global_mouse_position())
	

func _on_bullet_hitbox_area_entered(area):
	if area.name == "enemy_hurtbox" or area.name == "player_hurtbox":
		if ID + "_hurtbox" != area.name:
			queue_free()

func _on_bullet_hitbox_body_entered(body):
	if body.name != "enemy" and body.name != "Player":
		queue_free()

func _physics_process(delta):
	position = position + speed * direction * delta
