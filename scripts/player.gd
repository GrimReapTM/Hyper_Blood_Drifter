extends CharacterBody2D

const bullet = preload("res://Scenes/entity scenes/bullet.tscn")


#player stats
@export var healthPoints = 200
@export var maxHealthPoints = 200

@export var stamina = 50
@export var maxStamina = 50


@export var damage = 4
@export var bullets = 20
@export var maxBullets = 20

signal healthChanged
signal bulletsChanged
signal attacked
signal staminaChanged


func littleTrolling():
	if Input.is_action_just_pressed("comedy"):
		healthPoints -= 30
		healthChanged.emit()
		print(healthPoints)
	if Input.is_action_just_pressed("non_comedy"):
		if healthPoints + 20 <= maxHealthPoints:
			healthPoints += 20
			healthChanged.emit()
			print(healthPoints)
		else:
			healthPoints = maxHealthPoints

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
var dashing = true

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



var global_index = 0
# I can attack
func attack():
	if Input.is_action_just_pressed("attackMelee") and not action and stamina > 5:
		action = true
		global_index = attack_calculation()
		attack_melee(global_index)

	if Input.is_action_just_pressed("attackRanged") and not action and stamina > 1 and bullets > 0:
		global_index = attack_calculation()
		attack_ranged(global_index)

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
	animations.play("attack_" + attackAnimations[index])
	animPlay = true
	#movement
	$meleeTimer.start()

func _on_melee_timer_timeout():
	$meleeTimer.stop()
	velocity = attackVectors[global_index] * 35
	move_and_slide()
	staminaChange("melee")
	await animations.animation_finished
	animPlay = false
	attacking = false
	action = false


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
	owner.add_child(instance)
	instance.position = position
	bullets -= 1
	bulletsChanged.emit()


# this is how you move
var savedDirection = Vector2(0,0)

func movement(delta):
	moveDirection = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	
	if moveDirection != Vector2(0,0):
		savedDirection = moveDirection
		
	if attacking == false:
		if Input.is_action_just_pressed("dash") and not action and stamina > 8:
			action = true
			staminaChange("dash")
			velocity = savedDirection * speed * 3
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


# this is how you ✨move✨
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
		if animPlay == false and attacking == false:
			animations.stop()


var staminaStop = false

func staminaChange(value):
	staminaChanged.emit()
	match value:
		"melee":
			staminaSubtract(8)
		"ranged":
			staminaSubtract(3)
		"dash":
			staminaSubtract(12)
	staminaStop = true
	$staminaStop.start()

func _on_stamina_stop_timeout():
	staminaStop = false


func staminaSubtract(num):
	if stamina - num >= 0:
		stamina -= num
	else:
		stamina = 0



func staminaRegen(delta):
	if stamina < maxStamina and not staminaStop:
		stamina += 1 * delta * 15


func _on_melee_hitboxes_area_entered(area):
	if area.name == "enemy_hurtbox":
		attacked.emit()

# this just happens or something
func _physics_process(delta):
	movement(delta)
	move_and_slide()
	movementAnimation()
	attack()
	littleTrolling()
	staminaRegen(delta)
