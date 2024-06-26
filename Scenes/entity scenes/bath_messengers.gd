extends StaticBody2D

@export var ID = "blood"
@export var player: CharacterBody2D

@export var a_laugh: AudioStreamPlayer2D
@export var a_cry: AudioStreamPlayer2D

var activated = false
var isActivating = false
var inTrigger = false

signal open
signal disable

func _ready():
	a_cry.play()
	disable.connect(close)

func _on_interaction_area_entered(area):
	if area.name == "player_hurtbox":
		inTrigger = true
		if not isActivating:
			$E/Sprite2D.visible = true
			$AnimationPlayer.play("wake_up")
			$AnimationPlayer.queue("idle")
	interact()
	
func _on_interaction_area_exited(area):
	if area.name == "player_hurtbox":
		inTrigger = false
		$E/Sprite2D.visible = false
		$AnimationPlayer.play_backwards("wake_up")
		$AnimationPlayer.queue("RESET")
		player.paused = false

func interact():
	if Input.is_action_just_pressed("interact") and inTrigger and not player.paused:
		$AnimationPlayer.play("interact")
		$AnimationPlayer.play("interact_idle")
		$E/Sprite2D.visible = false
		player.paused = true
		activated = true
		open.emit()
		g.openShop.emit()
		a_laugh.play()

func close():
	if activated:
		$E/Sprite2D.visible = true
		$AnimationPlayer.play("idle")
		activated = false


func _physics_process(_delta):
	interact()
