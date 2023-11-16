extends CharacterBody2D


@export var hp = 50
@export var maxHp = hp
signal healthChanged


func _on_hurtbox_area_entered(area):
	match area.name:
		"melee_hitboxes":
			hp -= globalStats.melee_damage
			print("---melee---")
			healthChanged.emit()
			print(hp)
		"bullet_hitbox":
			hp -= globalStats.ranged_damage
			print("---ranged---")
			healthChanged.emit()
			area.owner.queue_free()
	if hp <= 0:
		queue_free()
