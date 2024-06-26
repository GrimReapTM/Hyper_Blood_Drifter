extends Node

var dead = false
var score = 0
var highscore = 0

var beast_damage = 0
var max_beast_damage = 40
var bonus_damage = 0
var melee_damage = 22 + bonus_damage + beast_damage
var ranged_damage = 4

var inventory = {}
var quick_slots = [null, null, null, null, null, null]
var equiped_slot = null
var old_slot = null
var slot = 0
var next_slot = 0


var player_position = Vector2()

var vials = 20
var max_vials = 20
signal vialsChanged

var bullets = 20
var max_bullets = 20
signal bulletsChanged

var next_item = ""

signal itemAmount
signal changeSprite
signal equiped_null
signal nullSprite
signal showHud
signal sound
signal addItem
signal openShop


# player
var fire_damage = false
var b_echoes = 0
signal beChanged
signal maxvialsChanged
signal maxbulletsChanged

var insight = 0
signal iChanged

var hp = 200
var maxhp = 200
signal hpChanged
signal maxhpChanged

var stamina = 75
var maxst = 75
signal stChanged
signal maxstChanged


#Stats
var Level = 1

var Vitality = 10
var Endurance = 10
var Strength = 10
var Bloodtinge = 10

var ReqInsight = 1
var LevelQuo = 1.25

func _ready():
	itemAmount.connect(check_inv)

var item_ids = {"molotov_cocktail":1, "pebble":2, "throwing_knife":3, "beast_pellet":4, "hunters_mark":5, "bolt_paper":6, "coldblood_dew":7, "fire_paper":8, "lantern":9, "iosefka_blood":10, "madmans_knowledge":11, "umbilical_cord":12}

func check_inv():
	for i in inventory:
		if inventory[i] <= 0:
			inventory.erase(i)
			if equiped_slot not in inventory:
				nullSprite.emit()
				equiped_slot = null
				equiped_null.emit()

func get_item(parameter, action):
	var ID = null
	var item_name = ""
	var item_description = ""
	var item_frame = 0
	var price = 0
	if typeof(parameter) == TYPE_INT:
		ID = quick_slots[parameter]
	else:
		ID = parameter
	
	match ID:
		"molotov_cocktail":
			item_name = "Molotov Cocktail"
			item_description = "Molotov cocktail that explodes violently when thrown."
			item_frame = 1
			price = 80
		"pebble":
			item_name = "Pebble"
			item_description = "Used to get the attention of a single enemy."
			item_frame = 2
			price = 30
		"throwing_knife":
			item_name = "Throwing Knife"
			item_description = "Finely serrated throwing knife."
			item_frame = 3
			price = 40
		"beast_pellet":
			item_name = "Beast Blood Pellet"
			item_description = "Enables Beasthood, increasing the damage a hunter deals\nand receives with increasing intensity as they bathe in blood."
			item_frame = 4
			price = 200
		"hunters_mark":
			item_name = "Bold Hunter's Mark"
			item_description = "Allows you to reawaken at a lamp without losing your\nBlood Echoes."
			item_frame = 5
			price = 400
		"bolt_paper":
			item_name = "Bolt Paper"
			item_description = "Temporarily adds 80 bolt damage to right-hand weapon."
			item_frame = 6
			price = 250
		"coldblood_dew":
			item_name = "Coldblood Dew"
			item_description = "Can be consumed to acquire Blood Echoes."
			item_frame = 7
			price = 1000
		"fire_paper":
			item_name = "Fire Paper"
			item_description = "Temporarily adds 80 fire damage to right-hand weapon."
			item_frame = 8
			price = 250
		"lantern":
			item_name = "Hand Lantern"
			item_description = "Use Weapons in both hands while illuminating the dark."
			item_frame = 9
			price = 500
		"iosefka_blood":
			item_name = "Iosefka's Blood"
			item_description = "Consume to gain a larger amount of HP."
			item_frame = 10
			price = 150
		"madmans_knowledge":
			item_name = "Madman's Knowledge"
			item_description = "Use to gain 1 Insight."
			item_frame = 11
			price = 1000
		"umbilical_cord":
			item_name = "One Third of Umbilical Cord"
			item_description = "Consume to gain insight, so they say, eyes on the inside."
			item_frame = 12
			price = 3000
		"vial":
			item_name = "Blood Vial"
			item_description = "Special blood used in ministration. Restores HP."
			item_frame = 13
			price = 20
		"bullet":
			item_name = "Quicksilver Bullet"
			item_description = "Special bullets used with hunter firearms."
			item_frame = 14
			price = 20



	match action:
		"name":
			return item_name
		"description":
			return item_description
		"frame":
			return item_frame
		"price":
			return price

'''
molotov_cocktail - 1
pebble - 2
throwing_knife - 3
beast_pellet - 4
hunter's mark - 5
bolt_paper - 6
coldblood_dew - 7
fire_paper - 8
lantern - 9
iosefka_blood - 10
madmans_knowledge - 11
umbilical_cord - 12
'''
