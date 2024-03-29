extends Node2D

const hunter = preload("res://Scenes/entity scenes/enemy.tscn")
const beast = preload("res://Scenes/entity scenes/beast.tscn")

var rng = RandomNumberGenerator.new()

@export var timer: Timer
@export var interval = 4

func _ready():
	timer.wait_time = interval
	timer.start()

func _on_timer_timeout():
	if not g.dead:
		var enemy
		match rng.randi_range(0, interval):
			0:
				enemy = hunter.instantiate()
			1: 
				enemy = hunter.instantiate()
		if enemy != null:
			enemy.position = Vector2(position.x + random(), position.y + random())
			if rng.randi_range(0,1) > 0:
				enemy.aggro = true
			owner.add_child(enemy)

func random():
	match rng.randi_range(0,1):
		0:
			return 30
		1:
			return -30


func _on_wave_timer_timeout():
	if interval != 1:
		interval -= 1
		timer.wait_time = interval
