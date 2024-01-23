extends CharacterBody2D

const bullet = preload("res://Scenes/entity scenes/bullet.tscn")

@export var pauseMenu: Control
@export var HUD: Node2D

var paused = false

#player stats
@export var healthPoints = 200
@export var maxHealthPoints = 200
@export var b_vials = 20
@export var max_b_vials = 20

@export var stamina = 75
@export var maxStamina = 75

@export var b_echoes = 727
@export var insight = 0

@export var damage = 4
@export var bullets = 20
@export var b_bullets = 0
@export var maxBullets = 20

signal healthChanged
signal bulletsChanged
signal attacked
signal staminaChanged
signal b_bulletsChanged
signal vialsChanged
signal pause_pressed
signal insightChanged
signal b_echoesChanged

#variables for movement
@export var speed = 350
@export var attSpeed = 10
var attackMove = 20
var moveDirection = 0


#uhhh misc idk, this only affects animations
@onready var animations = $AnimationPlayer
var animPlay = false
var attacking = false
var action = false
var dashing = false


var consumables = []


#used for attacks
var attackAnimations = ["up_left", "up", "up_right", "left", "right", "down_left", "down", "down_right"]
var attackVectors = [Vector2(position.x - attackMove, position.y - attackMove), Vector2(position.x, position.y - attackMove), Vector2(position.x + attackMove, position.y - attackMove),Vector2(position.x - attackMove, position.y),Vector2(position.x + attackMove, position.y),Vector2(position.x - attackMove, position.y + attackMove),Vector2(position.x, position.y + attackMove),Vector2(position.x + attackMove, position.y + attackMove)]

# this is used to update the position of the points around the player used in the attack calculation below 
#(the attack function is kinda cool tbh)
func updateMousepos():
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


#inputs - self explanatory
func _input(event):
	if event.is_action_pressed("pause"):
		pause_pressed.emit()
	if not paused and not action:
		if event.is_action_pressed("attackMelee"):
			if not action and stamina > 5 and not paused:
				action = true
				global_index = attack_calculation()
				attack_melee(global_index)
		elif event.is_action_pressed("attackRanged"):
			if not action and stamina > 1 and bullets > 0 and not paused:
				global_index = attack_calculation()
				attack_ranged(global_index)
		elif event.is_action_pressed("blood_bullet"):
			if b_bullets == 0:
				animations.play("blood_bullet")
				await animations.animation_finished
				animations.play("RESET")
				healthPoints -= 65
				healthChanged.emit()
				b_bullets += 5
				b_bulletsChanged.emit()
		elif event.is_action_pressed("heal"):
			if b_vials > 0:
				animations.play("heal")
				await animations.animation_finished
				animations.play("RESET")
				if healthPoints + 50 <= maxHealthPoints:
					healthPoints += 40
				else:
					healthPoints = maxHealthPoints
				healthChanged.emit()
				b_vials -= 1
				vialsChanged.emit()
		elif event.is_action_pressed("quick_use") and not paused:
			if g.equiped_slot != null:
				if g.equiped_slot != "lantern":
					g.inventory[g.equiped_slot] -= 1
					g.itemAmount.emit()
				match g.equiped_slot:
					"molotov_cocktail":
						pass
					"pebble":
						pass
					"throwing_knife":
						pass
					"beast_pellet":
						pass
					"hunters_mark":
						pass
					"bolt_paper":
						pass
					"coldblood_dew":
						pass
					"fire_paper":
						pass
					"lantern":
						pass
					"iosefka_blood":
						pass
					"madmans_knowledge":
						pass
					"umbilical_cord":
						pass


var combo = false
var saved_index = -1
var global_index = 0

func attack_calculation():
		# we start attacking and setup the for loop below using the position in function above
	attacking = true
	var mouse_pos = get_global_mouse_position()
	var base = 999999999
	var move_pos = 0
	var index = 0
	var quadrants = updateMousepos()
		
	#ok so this part does a really funny thing, it takes the points that are defined above and it
	#calculates which point around the player is the closest to your cursor, and uses that point in the
	# next function (the next function is dumb af)
	for i in quadrants:
		var pos = mouse_pos.distance_to(i)
		if pos <= base:
			base = pos
			move_pos = index
		index += 1
	return move_pos


# actually does the attacking (the function above is boring af ^^^^)
func attack_melee(index):
	#ani maishn :3
	if saved_index == index and combo:
		animations.play_backwards("attack_" + attackAnimations[index])
		combo = false
	else:
		animations.play("attack_" + attackAnimations[index])
		combo = true
	$combo.stop()
	animPlay = true
	#movement
	$meleeTimer.start()

func _on_melee_timer_timeout():
	$meleeTimer.stop()
	velocity = attackVectors[global_index] * 35
	move_and_slide()
	staminaChange("melee")
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
	staminaChange("ranged")
	instance_bullet()
	await animations.animation_finished
	animPlay = false
	attacking = false
	action = false
	
func instance_bullet():
	var instance = bullet.instantiate()
	instance.ID = "player"
	instance.position = position
	owner.add_child(instance)
	if b_bullets != 0:
		b_bullets -= 1
		b_bulletsChanged.emit()
	else:
		bullets -= 1
		bulletsChanged.emit()

func _on_player_hurtbox_area_entered(area):
	match area.name:
		"enemy_attack":
			healthPoints -= 40
			healthChanged.emit()
		"bullet_hitbox":
			if area.owner.ID == "enemy":
				healthPoints -= 20
				healthChanged.emit()


# this is how you move
var savedDirection = Vector2(0,0)

func dash_dir():
	if savedDirection.x > 0:
		return "right"
	elif savedDirection.x < 0:
		return "left"
	elif savedDirection.y > 0:
		return "down"
	elif savedDirection.y < 0:
		return "up"

func movement(delta):
	moveDirection = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	
	if moveDirection != Vector2(0,0):
		savedDirection = moveDirection
		
	if attacking == false:
		if Input.is_action_just_pressed("dash") and not action and stamina > 8:
			action = true
			dashing = true
			staminaChange("dash")
			velocity = savedDirection * speed * 3
			animations.play("dash_" + dash_dir())
			$dashTimer.start()
		else:
			if action == false:
				velocity = moveDirection * delta * speed * 50
	else:
		velocity = Vector2(0,0)

func _on_dash_timer_timeout():
	$dashTimer.stop()
	velocity = Vector2(0,0)
	action = false
	dashing = false


# this is how you ✨move✨
func movementAnimation():
	if velocity.length() != 0 and not dashing:
		if velocity.x > 0:
			animations.play("walk_right")
		elif velocity.x < 0:
			animations.play("walk_left")
		elif velocity.y > 0:
			animations.play("walk_down")
		elif velocity.y < 0:
			animations.play("walk_up")
	else:
		if not animPlay and not attacking and "walk_" in animations.current_animation:
			animations.stop()


var staminaStop = false

func staminaChange(value):
	match value:
		"melee":
			staminaSubtract(8)
		"ranged":
			staminaSubtract(3)
		"dash":
			staminaSubtract(12)
	staminaStop = true
	staminaChanged.emit()
	$staminaStop.start()

func _on_stamina_stop_timeout():
	staminaStop = false


func staminaSubtract(num):
	if stamina - num >= 0:
		stamina -= num
	else:
		stamina = 0



func staminaRecovery(delta):
	if stamina < maxStamina and not staminaStop:
		stamina += 1 * delta * 20
		staminaChanged.emit()
		


func _on_melee_hitboxes_area_entered(area):
	if area.name == "enemy_hurtbox":
		attacked.emit()


# this just happens or something
func _physics_process(delta):
	movement(delta)
	move_and_slide()
	movementAnimation()
	staminaRecovery(delta)
