extends CharacterBody2D

var aggro = false

const bullet = preload("res://Scenes/entity scenes/bullet.tscn")

@export var speed = 300
@onready var raycast = $vision_raycast

@export var defalut_pos: Marker2D
@export var player: CharacterBody2D
@onready var nav_agent = $CollisionShape2D/navigation_agent as NavigationAgent2D
@onready var animations = $AnimationPlayer

@export var hp = 50
@export var maxHp = hp
signal healthChanged

var queue = null
var distance = "far"

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

func _on_vision_body_entered(body):
	if body.name == "Player" and not aggro:
		raycast.enabled = true
		player = body


func _on_vision_body_exited(body):
	if body.name == "Player":
		raycast.enabled = false



#Beneath lies an indescribable abyss, a realm where shadows whisper untold secrets 
#and unseen horrors lurk in the shifting darkness. It is a place where the very essence
#of despair takes form, defying description, as malevolent forces manifest in shapes 
#that elude comprehension. This is an abyss that beckons only the bravest souls to 
#fathom its enigmatic depths.
#--------------------------------------------------------------------------------------------

# attack (literally the same as player's
var attackMove = 20
var animPlay = false
var attacking = false
var action = false

#used for attacks
var attackAnimations = ["up_left", "up", "up_right", "left", "right", "down_left", "down", "down_right"]
var attackVectors = [Vector2(position.x - attackMove, position.y - attackMove), Vector2(position.x, position.y - attackMove), Vector2(position.x + attackMove, position.y - attackMove),Vector2(position.x - attackMove, position.y),Vector2(position.x + attackMove, position.y),Vector2(position.x - attackMove, position.y + attackMove),Vector2(position.x, position.y + attackMove),Vector2(position.x + attackMove, position.y + attackMove)]

func updatePlayerpos():
	var upLeft = Vector2(position.x - 45, position.y - 45)
	var upMiddle = Vector2(position.x,position.y -60)
	var upRight = Vector2(position.x + 45, position.y - 45)

	var middleLeft = Vector2(position.x - 60, position.y)
	var middleRight = Vector2(position.x + 60, position.y)

	var bottomLeft = Vector2(position.x - 45, position.y + 45)
	var bottomMiddle = Vector2(position.x, position.y + 60)
	var bottomRight = Vector2(position.x + 45, position.y + 45)

	var quadrants = [upLeft, upMiddle, upRight, middleLeft, middleRight, bottomLeft, bottomMiddle, bottomRight]	
	return quadrants
	
var combo = false
var saved_index = -1
var global_index = 0

func attack_calculation():
	var player_pos = player.position
	var base = 999999999
	var move_pos = 0
	var index = 0
	var quadrants = updatePlayerpos()
		
	for i in quadrants:
		var pos = player_pos.distance_to(i)
		if pos <= base:
			base = pos
			move_pos = index
		index += 1
	return move_pos


func attack_melee(index):
	attacking = true
	if saved_index == index and combo:
		animations.play_backwards("attack_" + attackAnimations[index])
		combo = false
	else:
		animations.play("attack_" + attackAnimations[index])
		combo = true
	$combo.stop()
	global_index = index
	animPlay = true
	#movement
	$meleeTimer.start()


func _on_melee_timer_timeout():
	$meleeTimer.stop()
	await animations.animation_finished
	if combo:
		$combo.start()

	animPlay = false
	attacking = false
	action = false
	saved_index = global_index

func _on_combo_timeout():
	$combo.stop()
	combo = false
	match global_index:
		0, 3, 5:
			animations.play("walk_left")
		1:
			animations.play("walk_up")
		2, 4, 7:
			animations.play("walk_right")
		6:
			animations.play("walk_down")
	animPlay = false
	attacking = false
	action = false
	saved_index = global_index

# does the attacking but *pew pew*
func attack_ranged(index):
	# animation
	animations.play("ranged_" + attackAnimations[index])
	animPlay = true
	$rangedTimer.start()
	
	#movement but backwards
func _on_ranged_timer_timeout():
	$rangedTimer.stop()
	velocity = -attackVectors[global_index] * 30
	move_and_slide()
	instance_bullet()
	await animations.animation_finished
	animPlay = false
	attacking = false
	action = false
	
func instance_bullet():
	var instance = bullet.instantiate()
	owner.add_child(instance)
	instance.position = position

func movementAnimation():
	if velocity.length() != 0:
		if velocity.y > 0:
			animations.play("walk_down")
		if velocity.x < 0:
			animations.play("walk_left")
		elif velocity.x > 0:
			animations.play("walk_right")
		elif velocity.y < 0:
			animations.play("walk_up")
	else:
		if not animPlay and not attacking and "walk_" in animations.current_animation:
			animations.stop()

#-----------------------------------------------------
# direction states

# enemy keeps aggro if player is inside
func _on_keep_aggro_body_exited(body):
	if aggro:
		if body.name == "Player":
			distance = "-"
			aggro = false
			#nav_agent.target_position = defalut_pos

# always starts aggro
func _on_aggro_range_body_entered(body):
	if body.name == "Player":
		aggro = true

# the enemy always attacks when player is in this range
func _on_always_attack_body_entered(body):
	if body.name == "Player":
		distance = "attack"

# exiting always attack
func _on_always_attack_body_exited(body):
	if body.name == "Player":
		distance = "close"

# enemy either attacks (50%), gets even closer (25%) or circles around the player (25%)
func _on_close_range_body_entered(body):
	if body.name == "Player":
		distance = "close"

# exiting close range
func _on_close_range_body_exited(body):
	if body.name == "Player":
		distance = "mid"

# enemy either shoots (25%), gets even closer (25%) or circles around the player (50%)
func _on_mid_range_body_entered(body):
	if body.name == "Player":
		distance = "mid"

func _on_mid_range_body_exited(body):
	if body.name == "Player":
		distance = "far"

# enemy either shoots (25%), gets even closer (50%) or circles around the player (25%)
func _on_long_range_body_entered(body):
	if body.name == "Player":
		distance = "far"

# exiting long range - always runs towards the player
func _on_long_range_body_exited(body):
	if body.name == "Player":
		distance = "follow"
#---------------------------------------------------------------------------------------------

func _on_path_timer_timeout():
	nav_agent.target_position = player.position

func _process(_delta):
	if raycast.enabled:
		raycast.target_position = Vector2(player.position.x, player.position.y + 60) - position
		if raycast.is_colliding() and "Player" in str(raycast.get_collider()):
			aggro = true
			raycast.enabled = false

func _physics_process(delta):
	velocity = to_local(nav_agent.get_next_path_position()).normalized() * speed * delta
	if aggro and not attacking:
		match distance:
			"attack":
				pass
			"close":
				pass
			"mid":
				pass
			"far":
				pass
			"follow":
				pass

	move_and_slide()
	attack_calculation()
	print("player position: " + str(player.position))
	print("target position: " + str(nav_agent.target_position))
	print("velocity: " + str(velocity))
	print("next path position: " + str(nav_agent.get_next_path_position()))
	print("position: " + str(position))
	print("is reachable: " + str(nav_agent.is_target_reachable()))
	print("is reached: " + str(nav_agent.is_target_reached()))
	print("is finished: " + str(nav_agent.is_navigation_finished()))
	print("-----------------------------------")
