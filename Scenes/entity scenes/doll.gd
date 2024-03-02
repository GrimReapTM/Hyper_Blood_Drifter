extends StaticBody2D

@export var player: CharacterBody2D
@export var lvlup: Control
@export var a_open: AudioStreamPlayer

var inTrigger = false


func _on_interaction_area_entered(area):
	if area.name == "player_hurtbox":
		inTrigger = true
		$E.visible = true
	
func _on_interaction_area_exited(area):
	if area.name == "player_hurtbox":
		inTrigger = false
		$E.visible = false
		player.paused = false
		lvlup.visible = false

func interact():
	if Input.is_action_just_pressed("interact") and inTrigger and not player.paused:
		$E.visible = false
		player.paused = true
		lvlup.visible = true
		player.HUD.visible = false
		a_open.play()


func _physics_process(_delta):
	interact()
