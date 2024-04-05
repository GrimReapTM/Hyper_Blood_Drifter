extends Area2D

const fire_scene = preload("res://Scenes/entity scenes/fire.tscn")


var rng = RandomNumberGenerator.new()

@export var sprite: Sprite2D
@export var speed = 1000
var direction = Vector2()

var grav = 1


func _ready():
	var fire_count = 0
	for i in get_parent().get_children():
		if i.editor_description == "fire":
			fire_count += 1
	if fire_count >= 50:
		var delete = 40
		for j in get_parent().get_children():
			if delete != 0:
				if j.editor_description == "fire":
					j.queue_free()
					delete -= 1
	
	direction = position.direction_to(get_global_mouse_position())



func _on_molotov_hitbox_area_entered(area):
	if area.name == "enemy_hurtbox":
		combust()

func _on_molotov_hitbox_body_entered(body):
	if body.name != "Player":
		combust()

func _on_gravity_start_timeout():
	$Gravity.start()
	grav = 1

func _on_gravity_timeout():
	grav = grav / 1.5


func combust():
	for i in range(rng.randi_range(20,40)):
		var fire = fire_scene.instantiate()
		fire.position = position
		get_parent().call_deferred("add_child", fire)
	queue_free()


func _physics_process(delta):
	position = position + direction * speed * delta * grav
	
	if grav <= 0.5:
		combust()
	
	sprite.rotation += 0.01


