extends Control

var effect
var frame
var duration

@export var sprite: Sprite2D
@export var durationTimer: Timer

func _ready():
	sprite.frame = frame
	durationTimer.wait_time = duration
	durationTimer.start()


func _on_duration_timeout():
	queue_free()
