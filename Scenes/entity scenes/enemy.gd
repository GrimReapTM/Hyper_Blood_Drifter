extends CharacterBody2D

var aggro = false

var rng = RandomNumberGenerator.new()

const bullet = preload("res://Scenes/entity scenes/bullet.tscn")

@export var speed = 300
@onready var raycast = $vision_raycast

@export var fireParticles: AnimatedSprite2D
@export var default_pos: Marker2D
@export var player: CharacterBody2D
@onready var nav_agent = $CollisionShape2D/navigation_agent as NavigationAgent2D
@onready var animations = $AnimationPlayer

@export var hp = 50
@export var maxHp = hp
signal healthChanged
var damaged = false
var heavy = false
var staggered = false

var queue = null
var distance = "far"

func knockback(vector, strength):
	position = position - vector / strength

func _on_hurtbox_area_entered(area):
	match area.name:
		"melee_hitbox":
			aggro = true
			if not heavy:
				damaged = true
			$damagedTimer.start()
			hp -= g.melee_damage
			if player.fire_damage == true:
				fireParticles.visible = true
				$Fire.start()
				$FireDamage.start()
			healthChanged.emit()
			knockback(to_local(player.position), 10)
		"bullet_hitbox":
			if area.owner.ID == "player":
				aggro = true
				hp -= g.ranged_damage
				healthChanged.emit()
				knockback(to_local(player.position), 30)
		"knife_hitbox":
			aggro = true
			hp -= 15
			healthChanged.emit()
			knockback(to_local(player.position), 30)
		"fire_hitbox":
			aggro = true
			hp -= 1
			healthChanged.emit()
			fireParticles.visible = true
			$Fire.start()
			$FireDamage.start()


	if hp <= 0:
		queue_free()
		player.b_echoes += 52
		player.b_echoesChanged.emit()


func _on_damaged_timer_timeout():
	damaged = false

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
	instance_bullet()
	await animations.animation_finished
	animPlay = false
	attacking = false
	action = false
	
func instance_bullet():
	var instance = bullet.instantiate()
	instance.ID = "enemy"
	instance.position = position
	instance.direction = instance.position.direction_to(player.position)
	owner.add_child(instance)

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
var target = null

func walk_to(t, delta):
	if t != null:
		velocity = to_local(nav_agent.get_next_path_position()).normalized() * speed * delta
		if nav_agent.is_target_reached():
			target = null
			velocity = Vector2(0,0)
	else:
		velocity = Vector2(0,0)

# enemy keeps aggro if player is inside
func _on_keep_aggro_body_exited(body):
	if aggro:
		if body.name == "Player":
			distance = "-"
			aggro = false
			target = default_pos.position

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

# enemy either shoots, gets even closer or circles around the player
func _on_long_range_body_entered(body):
	if body.name == "Player":
		distance = "far"

# exiting long range - always runs towards the player
func _on_long_range_body_exited(body):
	if body.name == "Player":
		distance = "follow"
#---------------------------------------------------------------------------------------------
var cir_low = 25
var cir_high = 50
var back = 50

var circle_vectors1 = [Vector2(position.x - cir_high, position.y + cir_low), Vector2(position.x - cir_high, position.y - cir_low), Vector2(position.x - cir_low, position.y - cir_high), Vector2(position.x - cir_low, position.y - cir_high), Vector2(position.x + cir_low, position.y - cir_high), Vector2(position.x - cir_high, position.y - cir_low), Vector2(position.x - cir_high, position.y + cir_low), Vector2(position.x - cir_low, position.y + cir_high)]
var circle_vectors2 = [Vector2(position.x + cir_low, position.y - cir_high), Vector2(position.x + cir_high, position.y - cir_low), Vector2(position.x + cir_high, position.y + cir_low), Vector2(position.x - cir_low, position.y + cir_high), Vector2(position.x + cir_low, position.y + cir_high), Vector2(position.x + cir_low, position.y + cir_high), Vector2(position.x + cir_high, position.y + cir_low), Vector2(position.x + cir_high, position.y - cir_low)]
var back_off_vectors = [Vector2(position.x + back, position.y + back), Vector2(position.x, position.y + back), Vector2(position.x - back, position.y + back), Vector2(position.x + back, position.y), Vector2(position.x - back, position.y), Vector2(position.x + back, position.y - back), Vector2(position.x, position.y - back), Vector2(position.x - back, position.y - back)]

func circle():
	match rng.randi_range(1,2):
		1:
			target = position + circle_vectors1[attack_calculation()]
		2:
			target = position + circle_vectors2[attack_calculation()]
	if not nav_agent.is_target_reachable():
		target = player.position

func back_off():
	target = position + back_off_vectors[attack_calculation()]
	if not nav_agent.is_target_reachable():
		match rng.randi_range(1,2):
			1:
				circle()
			2:
				close_range()
		return
	rounds = 2

func _on_path_timer_timeout():
	if target != null:
		nav_agent.target_position = target

var rounds = 0

func dice_roll():
	var die1 = rng.randi_range(1, 6)
	var die2 = rng.randi_range(1, 6)
	return die1 + die2

func _on_action_timer_timeout():
	new_round(false)
	if aggro and not attacking and not damaged and not staggered:
		match distance:
			"attack":
				new_round(true)
				attack_melee(attack_calculation())
			"close":
				if rounds > 1:
					new_round(false)
				close_range()
			"mid":
				if not new_round(false):
					mid_range()
			"far":
				if not new_round(false):
					long_range()
			"follow":
				new_round(true)
				target = player.position

func new_round(bol):
	if bol:
		rounds = 0
		return false
	if rounds > 0:
		rounds -= 1
		return true
	else:
		return false

func close_range():
	target = null
	match dice_roll():
		2,3:
			circle()
		4,5,6,7,8,9,10,11:
			attack_melee(attack_calculation())
		12:
			back_off()

func mid_range():
	if target == player.position and dice_roll() >= 11:
		rounds = 1
		return
	else:
		target = null
		
	match dice_roll():
		2,3:
			attack_ranged(attack_calculation())
		4:
			circle()
		5,6,7,8,9,10,11:
			target = player.position
			rounds = 1
		12:
			back_off()

func long_range():
	if target == player.position and dice_roll() >= 4:
		rounds = 3
		return
	else:
		target = null
	
	match dice_roll():
		2,3,4:
			attack_ranged(attack_calculation())
			rounds = 1
		5:
			circle()
		6,7,8,9,10,11,12:
			target = player.position
			rounds = 2

func _on_stagger_body_entered(body):
	pass # Replace with function body

func _process(delta):
	if raycast.enabled:
		raycast.target_position = Vector2(player.position.x, player.position.y + 60) - position
		if raycast.is_colliding() and "Player" in str(raycast.get_collider()):
			aggro = true
			raycast.enabled = false

	walk_to(target, delta)
	move_and_slide()
	attack_calculation()
	movementAnimation()


func _on_fire_damage_timeout():
	hp -= 4
	healthChanged.emit()

func _on_fire_timeout():
	fireParticles.visible = false
	$Fire.stop()
	$FireDamage.stop()
