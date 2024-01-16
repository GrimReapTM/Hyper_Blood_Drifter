extends Control

@export var Sprite: Sprite2D
@export var Amount: Label
@export var Description: Label
@export var Name: Label

@export var ID = ""

func _ready():
	g.itemAmount.connect(change_amount)

func item():
	Amount.text = str(g.inventory[ID])
	match ID:
		"molotov_cocktail":
			Name.text = "Molotov Cocktail"
			Description.text = "Molotov cocktail that explodes violently when thrown."
			Sprite.frame = 1
		"pebble":
			Name.text = "Pebble"
			Description.text = "Used to get the attention of a single enemy."
			Sprite.frame = 2
		"throwing_knife":
			Name.text = "Throwing Knife"
			Description.text = "Finely serrated throwing knife"
			Sprite.frame = 3
		"beast_pellet":
			Name.text = "Beast Blood Pellet"
			Description.text = "Enables Beasthood, increasing the damage a hunter deals and receives with increasing intensity as they bathe in blood."
			Sprite.frame = 4
		"hunters_mark":
			Name.text = "Bold Hunter's Mark"
			Description.text = "Allows you to reawaken at a lamp without losing your Blood Echoes."
			Sprite.frame = 5
		"bolt_paper":
			Name.text = "Bolt Paper"
			Description.text = "Temporarily adds 80 bolt damage to right-hand weapon."
			Sprite.frame = 6
		"coldblood_dew":
			Name.text = "Coldblood Dew"
			Description.text = "Can be consumed to acquire Blood Echoes."
			Sprite.frame = 7
		"fire_paper":
			Name.text = "Fire Paper"
			Description.text = "Temporarily adds 80 fire damage to right-hand weapon."
			Sprite.frame = 8
		"lantern":
			Name.text = "Hand Lantern"
			Description.text = "Use Weapons in both hands while illuminating the dark."
			Sprite.frame = 9
		"iosefka_blood":
			Name.text = "Iosefka's Blood"
			Description.text = "Consume to gain a larger amount of HP."
			Sprite.frame = 10
		"madmans_knowledge":
			Name.text = "Madman's Knowledge"
			Description.text = "Use to gain 1 Insight"
			Sprite.frame = 11
		"umbilical_cord":
			Name.text = "One Third of Umbilical Cord"
			Description.text = "Consume to gain insight, so they say, eyes on the inside"
			Sprite.frame = 12

func change_amount():
	if ID in g.inventory:
		Amount.text = str(g.inventory[ID])
	else:
		queue_free()
