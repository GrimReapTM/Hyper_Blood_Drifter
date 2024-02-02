extends StaticBody2D

var rng = RandomNumberGenerator.new()
var speed = 750
var direction
var grav = 1

@export var sprite1 = AnimatedSprite2D
@export var sprite2 = AnimatedSprite2D
@export var sprite3 = AnimatedSprite2D

@export var hitbox1 = CollisionShape2D
@export var hitbox2 = CollisionShape2D
@export var hitbox3 = CollisionShape2D

@export var timer: Timer

func _ready():
	timer.wait_time = rng.randi_range(2, 10)
	timer.start()
	match rng.randi_range(1, 3):
		1:
			sprite1.visible = true
			hitbox1.visible = true
		2:
			sprite2.visible = true
			hitbox2.visible = true
		3:
			sprite3.visible = true
			hitbox3.visible = true
	
	direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1))

func _on_fire_hitbox_area_entered(area):
	g.onFire.emit()

func _on_collision_body_entered(body):
	if body.name != "enemy" and body.name != "Player":
		queue_free()

func _on_timer_timeout():
		queue_free()

func _on_gravity_timeout():
	grav = grav / rng.randf_range(1, 3)

func _physics_process(delta):
	position = position + speed * direction * delta * grav


