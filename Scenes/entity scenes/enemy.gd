extends CharacterBody2D

var aggro = false

@onready var raycast = $vision_raycast


@export var hp = 50
@export var maxHp = hp
signal healthChanged

func _on_hurtbox_area_entered(area):
	match area.name:
		"melee_hitbox":
			hp -= globalStats.melee_damage
			healthChanged.emit()
		"bullet_hitbox":
			hp -= globalStats.ranged_damage
			healthChanged.emit()
			area.owner.queue_free()
	if hp <= 0:
		queue_free()


var player = null 
func _on_vision_body_entered(body):
	if body.name == "Player" and not aggro:
		raycast.enabled = true
		player = body


func _on_vision_body_exited(body):
	if body.name == "Player":
		raycast.enabled = false



func _process(delta):
	print(str(raycast.get_collider()))
	if raycast.enabled:
		raycast.target_position = Vector2(player.position.x, player.position.y + 60) - position
		if raycast.is_colliding() and str(raycast.get_collider()) == "Player:<CharacterBody2D#37094425938>":
			aggro = true
			raycast.enabled = false
