extends Control
@export var Inventory: Control

@export var player: CharacterBody2D
@export var hud: Node2D
@export var Item_name: Label
@export var Item_sprite: Sprite2D

@export var hand_debug: Sprite2D
@export var hand_weapons: Sprite2D
@export var hand_armor: Sprite2D
@export var hand_quick_items: Sprite2D

@export var label_debug: Label
@export var label_weapons: Label
@export var label_armor: Label
@export var label_quick: Label

signal debug
signal weapons
signal armor
signal quickitems

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

var quick_slots = [null, null, null, null, null, null]
var equiped_slot = 0

func _ready():
	player.pause_pressed.connect(pause)
	check_quick(quick_slots[equiped_slot])

func pause():
	if player.paused:
		visible = true
	else:
		visible = false


func _input(event):
	if event.is_action_pressed("Q1"):
			check_quick(quick_slots[0])
	elif event.is_action_pressed("Q2"):
			check_quick(quick_slots[1])
	elif event.is_action_pressed("Q3"):
			check_quick(quick_slots[2])
	elif event.is_action_pressed("Q4"):
			check_quick(quick_slots[3])
	elif event.is_action_pressed("Q5"):
			check_quick(quick_slots[4])
	elif event.is_action_pressed("Q6"):
			check_quick(quick_slots[5])


func check_quick(slot):
	if slot != null:
		equiped_slot = slot
		match slot:
			"molotov_cocktail":
				change_quick("Molotov Cocktail", 1)
			"pebble":
				change_quick("Pebble", 2)
			"throwing_knife":
				change_quick("Throwing Knife", 3)
			"beast_pellet":
				change_quick("Beast Blood Pellet", 4)
			"hunters_mark":
				change_quick("Bold Hunter's Mark", 5)
			"bolt_paper":
				change_quick("Bolt Paper", 6)
			"coldblood_dew":
				change_quick("Coldblood Dew", 7)
			"fire_paper":
				change_quick("Fire Paper", 8)
			"lantern":
				change_quick("Lantern", 9)
			"iosefka_blood":
				change_quick("Iosefka's Blood", 10)
			"madmans_knowledge":
				change_quick("Madman's Knowledge", 11)
			"umbilical_cord":
				change_quick("One Third of Umbilical Cord", 12)

func change_quick(label, frame):
	Item_name.text = label
	Item_sprite.frame = frame

#--------------------------------------------------------------------------
func fdebug():
	if not hand_debug.visible:
		hide_hand()
		hand_debug.visible = true

func fweapons():
	if not hand_weapons.visible:
		hide_hand()
		hand_weapons.visible = true

func farmor():
	if not hand_armor.visible:
		hide_hand()
		hand_armor.visible = true

func fquickitems():
	if not hand_quick_items.visible:
		hide_hand()
		hand_quick_items.visible = true

func hide_hand():
	hand_debug.visible = false
	hand_weapons.visible = false
	hand_armor.visible = false
	hand_quick_items.visible = false

#debug
func _on_inventory_button_mouse_entered():
	fdebug()
	label_debug.text = "Inventory"

func _on_stats_button_mouse_entered():
	fdebug()
	label_debug.text = "Stats"

func _on_settings_button_mouse_entered():
	fdebug()
	label_debug.text = "Settings"

#weapons
func _on_r_1_mouse_entered():
	fweapons()
	label_weapons.text = "Right Hand 1"

func _on_r_2_mouse_entered():
	fweapons()
	label_weapons.text = "Right Hand 2"

func _on_l_1_mouse_entered():
	fweapons()
	label_weapons.text = "Left Hand 1"

func _on_l_2_mouse_entered():
	fweapons()
	label_weapons.text = "Left Hand 2"


#armor
func _on_head_mouse_entered():
	farmor()
	label_armor.text = "Head"

func _on_shoulders_mouse_entered():
	farmor()
	label_armor.text = "Torso"

func _on_knees_mouse_entered():
	farmor()
	label_armor.text = "Arms"

func _on_toes_mouse_entered():
	farmor()
	label_armor.text = "Boots"

#quickslots
func _on_q_1_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

func _on_q_2_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

func _on_q_3_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

func _on_q_4_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

func _on_q_5_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

func _on_q_6_mouse_entered():
	fquickitems()
	label_quick.text = "Empty"

#-----------------------------------------------------------------


func _on_inventory_button_pressed():
	visible = false
	Inventory.visible = true
