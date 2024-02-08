extends Node2D

const hunter = preload("res://Scenes/entity scenes/enemy.tscn")
const beast = preload("res://Scenes/entity scenes/beast.tscn")

var rng = RandomNumberGenerator.new()

@export var timer: Timer
@export var interval = 10

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
				pass
				enemy = hunter.instantiate()
		if enemy != null:
			enemy.position = position
			enemy.aggro = true
			owner.add_child(enemy)


func _on_wave_timer_timeout():
	if interval != 1:
		interval -= 1
		timer.wait_time = interval
