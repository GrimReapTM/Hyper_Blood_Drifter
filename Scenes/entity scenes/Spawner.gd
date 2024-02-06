extends Node2D

const hunter = preload("res://Scenes/entity scenes/enemy.tscn")
const beast = preload("res://Scenes/entity scenes/beast.tscn")

var rng = RandomNumberGenerator.new()

@export var timer: Timer
@export var interval = 5

func _ready():
	timer.wait_time = interval


func _on_timer_timeout():
	match rng.randi_range(0, interval):
		0:
			owner.add_child(hunter.instantiate())
		1: 
			pass
			#owner.add_child(beast.instantiate())
