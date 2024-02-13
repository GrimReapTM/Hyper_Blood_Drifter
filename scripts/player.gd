extends CharacterBody2D

var dead = false

const bullet = preload("res://Scenes/entity scenes/bullet.tscn")
const molotov = preload("res://Scenes/entity scenes/molotov.tscn")
const pebble = preload("res://Scenes/entity scenes/pebble.tscn")
const knife = preload("res://Scenes/entity scenes/knife.tscn")

const effect_scene = preload("res://Scenes/UI_scenes/status_effect.tscn")

@export var beastBar: Node2D
@export var fireParticles: AnimatedSprite2D
@export var beastBloodParticles: AnimatedSprite2D
@export var pauseMenu: Control
@export var HUD: Node2D
@export var StatusEffectContainer: HBoxContainer

var paused = false

#player stats
@export var healthPoints = 200
@export var maxHealthPoints = 200
@export var b_vials = g.vials
@export var max_b_vials = 20

@export var stamina = 75
@export var maxStamina = 75

@export var b_echoes = g.b_echoes
@export var insight = g.insight

@export var damage = 4
@export var bullets = g.bullets
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
signal beastBloodChanged

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
	if not dead:
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
					action = true
					animations.play("blood_bullet")
					await animations.animation_finished
					animations.play("RESET")
					healthPoints -= 65
					healthChanged.emit()
					b_bullets += 5
					b_bulletsChanged.emit()
					action = false
			elif event.is_action_pressed("heal"):
				if b_vials > 0:
					action = true
					animations.play("heal")
					await animations.animation_finished
					animations.play("RESET")
					if healthPoints + 50 <= maxHealthPoints:
						healthPoints += 40
					else:
						healthPoints = maxHealthPoints
					healthChanged.emit()
					b_vials -= 1
					g.vials -= 1
					vialsChanged.emit()
					action = false
			elif event.is_action_pressed("quick_use") and not paused:
				if g.equiped_slot != null:
					match g.equiped_slot:
						"molotov_cocktail":
							throw_item(molotov, attack_calculation())
						"pebble":
							throw_item(pebble, attack_calculation())
						"throwing_knife":
							throw_item(knife, attack_calculation())
						"beast_pellet":
							animations.play("consume")
							await animations.animation_finished
							status_effect("beast_pellet", 0, 60)
							beast_blood_pellet()
						"hunters_mark":
							animations.play("consume")
							await animations.animation_finished
							#teleport
						"bolt_paper":
							animations.play("paper")
							await animations.animation_finished
							status_effect("bolt_paper", 1, 45)
							paper("bolt")
						"coldblood_dew":
							animations.play("consume")
							await animations.animation_finished
							b_echoes += 1000
							b_echoesChanged.emit()
						"fire_paper":
							animations.play("paper")
							await animations.animation_finished
							status_effect("fire_paper", 2, 45)
							paper("fire")
						"lantern":
							animations.play("lantern")
							await animations.animation_finished
							#light
						"iosefka_blood":
							animations.play("drink")
							await animations.animation_finished
							healthPoints += 60
							healthChanged.emit()
						"madmans_knowledge":
							animations.play("consume")
							await animations.animation_finished
							insight += 1
							insightChanged.emit()
						"umbilical_cord":
							animations.play("consume")
							await animations.animation_finished
							insight += 3
							insightChanged.emit() 
					if g.equiped_slot != "lantern":
						g.inventory[g.equiped_slot] -= 1
						g.itemAmount.emit()

func status_effect(effect, frame, duration):
	var effect_index = 0
	for i in StatusEffectContainer.get_children():
		if effect == i.effect or ("_paper" in effect and "_paper" in i.effect):
			StatusEffectContainer.get_children()[effect_index].queue_free()
		effect_index += 1
	var instance = effect_scene.instantiate()
	instance.effect = effect
	instance.frame = frame
	instance.duration = duration
	StatusEffectContainer.add_child(instance)


func on_fire():
	fireParticles.visible = true
	$StatusEffects/Fire.start()
	$StatusEffects/FireDamage.start()

var fire_damage = false
func paper(effect):
	
	match effect:
		"fire":
			g.bonus_damage = 3
			fire_damage = true
		"bolt":
			g.bonus_damage = 15


var beast_blood = false
var resist = 0
func beast_blood_pellet():
	$StatusEffects/BeastBloodTimer.start()
	beastBar.visible = true
	beast_blood = true
	beastBloodParticles.visible = true


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
		g.bullets -= 1
		bulletsChanged.emit()

var throw_item_

func throw_item(item, index):
	throw_item_ = item
	animations.play("throw_" + attackAnimations[index])
	animPlay = true
	$throwTimer.start()

func _on_throw_timer_timeout():
	$throwTimer.stop()
	var instance
	staminaChange("ranged")
	instance = throw_item_.instantiate()
	instance.position = position
	owner.add_child(instance)
	await animations.animation_finished
	attacking = false
	animPlay = false



func _on_player_hurtbox_area_entered(area):
	match area.name:
		"enemy_attack":
			healthPoints -= 40 + resist
			healthChanged.emit()
		"bullet_hitbox":
			if area.owner.ID == "enemy":
				healthPoints -= 20 + resist
				healthChanged.emit()
		"fire_hitbox":
			status_effect("fire", 3, 9)
			healthPoints -= 1 + resist
			healthChanged.emit()
			on_fire()

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
	if not dead:
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
					if not dashing:
						velocity = Vector2(0,0)
		else:
			velocity = Vector2(0,0)
	else:
		velocity = Vector2(0,0)


func _on_dash_timer_timeout():
	$dashTimer.stop()
	velocity = Vector2(0,0)
	action = false
	dashing = false


# this is how you ✨move✨
func movementAnimation():
	if velocity.length() != 0 and not dashing and not action:
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
		if beast_blood == true:
			if g.beast_damage + 3 <= g.max_beast_damage:
				resist -= 3
				g.beast_damage += 3
			else:
				g.beast_damage = g.max_beast_damage
				resist -= 3
			beastBloodChanged.emit()

func _on_fire_timeout():
	fireParticles.visible = false
	$StatusEffects/Fire.stop()
	$StatusEffects/FireDamage.stop()

func _on_fire_damage_timeout():
	healthPoints -= 5 - resist
	healthChanged.emit()


func _on_paper_timer_timeout():
	g.bonus_damage = 0
	fire_damage = false


func _on_beast_blood_timer_timeout():
	beast_blood = false
	beastBloodParticles.visible = false
	beastBar.visible = false
	g.beast_damage = 0
	resist = 0
	beastBloodChanged.emit()


# this just happens or something
func _physics_process(delta):
	g.player_position = position
	movement(delta)
	move_and_slide()
	movementAnimation()
	staminaRecovery(delta)
	
	if beast_blood == true:
		resist -= 0.01
		g.beast_damage -= 0.01
		beastBloodChanged.emit()

