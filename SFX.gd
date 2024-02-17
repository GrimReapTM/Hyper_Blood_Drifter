extends Node2D

var rng = RandomNumberGenerator.new()

#damage
@export var damage1: AudioStreamPlayer2D
@export var damage2: AudioStreamPlayer2D
@export var damage3: AudioStreamPlayer2D
@export var damage_bolt: AudioStreamPlayer2D
@export var damage_fire: AudioStreamPlayer2D
@export var kill1: AudioStreamPlayer2D
@export var kill2: AudioStreamPlayer2D
@export var stagger: AudioStreamPlayer2D

#Effects
@export var burn: AudioStreamPlayer2D
@export var dead: AudioStreamPlayer2D
@export var warp: AudioStreamPlayer2D

#ground
@export var dirt1: AudioStreamPlayer2D
@export var dirt2: AudioStreamPlayer2D
@export var dirt3: AudioStreamPlayer2D
@export var mud1: AudioStreamPlayer2D
@export var mud2: AudioStreamPlayer2D
@export var mud3: AudioStreamPlayer2D

#gun
@export var reload: AudioStreamPlayer2D
@export var shoot: AudioStreamPlayer2D

#items
@export var cold_blood_dew: AudioStreamPlayer2D
@export var bolt_paper: AudioStreamPlayer2D
@export var finger: AudioStreamPlayer2D
@export var heal: AudioStreamPlayer2D
@export var get_item: AudioStreamPlayer2D
@export var madmans_knowledge: AudioStreamPlayer2D
@export var use_item: AudioStreamPlayer2D

#action
@export var swing1: AudioStreamPlayer2D
@export var swing2: AudioStreamPlayer2D
@export var swing3: AudioStreamPlayer2D
@export var throw: AudioStreamPlayer2D


func damage(sound):
	match sound:
		"damage":
			match rng.randi_range(0,2):
				0:
					damage1.play()
				1:
					damage2.play()
				2:
					damage3.play()
		"bolt":
			damage_bolt.play()
		"fire":
			damage_fire.play()
		"kill":
			match rng.randi_range(0,1):
				0:
					kill1.play()
				1:
					kill2.play()
		"stagger":
			stagger.play()


func effects(sound):
	match sound:
		"burn":
			burn.play()
		"dead":
			dead.play()
		"warp":
			warp.play()

var next_sound = 0
func ground(sound):
	match sound:
		"dirt":
			match next_sound:
				0:
					dirt1.play()
					next_sound = 1
				1:
					dirt2.play()
					next_sound = 2
				2:
					dirt3.play()
					next_sound = 0
		"mud":
			match next_sound:
				0:
					mud1.play()
					next_sound = 1
				1:
					mud2.play()
					next_sound = 2
				2:
					mud3.play()
					next_sound = 0


func gun(sound):
	match sound:
		"reload":
			reload.play()
		"shoot":
			shoot.play()

func items(sound):
	match sound:
		"cold_blood_dew":
			cold_blood_dew.play()
		"bolt_paper":
			bolt_paper.play()
		"finger":
			finger.play()
		"heal":
			heal.play()
		"get_item":
			get_item.play()
		"madmans_knowledge":
			madmans_knowledge.play()
		"use_item":
			use_item.play()

func action(sound):
	match sound:
		"swing":
			match rng.randi_range(0,2):
				0:
					swing1.play()
				1:
					swing2.play()
				2:
					swing3.play()
		"throw":
			throw.play()
