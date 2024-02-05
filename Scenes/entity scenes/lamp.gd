extends StaticBody2D

@export var ID = 0

var inTrigger = false
var activated = false
var isActivating = false

func _on_interaction_area_entered(area):
	if area.name == "player_hurtbox":
		if not isActivating:
			inTrigger = true
			$E/Sprite2D.visible = true
	interact()
	
func _on_interaction_area_exited(_area):
	inTrigger = false
	$E/Sprite2D.visible = false

func interact():
	if Input.is_action_just_pressed("interact") and inTrigger:
		if activated == false:
			isActivating = true
			$AnimationPlayer.play("light_up")
			$E/Sprite2D.visible = false
			$AnimationPlayer.queue("lit_idle")
			activated = true
			isActivating = false
		else:
			get_tree().change_scene_to_file("res://Scenes/areas/Dream.tscn")
			
func _physics_process(_delta):
	interact()


