extends Node2D

const hunter = preload("res://Scenes/entity scenes/enemy.tscn")
const beast = preload("res://Scenes/entity scenes/beast.tscn")

@export var timer: Timer
@export var interval = 10

func _ready():
	timer.wait_time = interval


func _on_timer_timeout():
	owner.add_child(hunter.instantiate())
