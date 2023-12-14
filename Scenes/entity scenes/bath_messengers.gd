extends StaticBody2D

@export var ID = 0


var activated = false
var isActivating = false

func _on_interaction_area_entered(area):
	if area.name == "player_hurtbox":
		if not isActivating:
			$E/Sprite2D.visible = true
			$AnimationPlayer.play("wake_up")
			$AnimationPlayer.queue("idle")
	interact()
	
func _on_interaction_area_exited(area):
	if area.name == "player_hurtbox":
			$E/Sprite2D.visible = false
			$AnimationPlayer.play_backwards("wake_up")
			$AnimationPlayer.queue("RESET")

func interact():
	pass
			
func _physics_process(_delta):
	interact()
