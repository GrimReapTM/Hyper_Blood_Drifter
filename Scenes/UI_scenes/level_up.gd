extends Control

@export var player: CharacterBody2D
@export var a_ok: AudioStreamPlayer
@export var a_confirm: AudioStreamPlayer
@export var a_close: AudioStreamPlayer
@export var Paused: Control

@export var confirmButton: Button
@export var confirm: Sprite2D
@export var confirm_label: Label

@export var HP: Label
@export var ST: Label
@export var W1: Label
@export var W2: Label
@export var Beast: Label

@export var Lv: Label
@export var In: Label
@export var Req: Label
@export var Vit: Label
@export var End: Label
@export var Str: Label
@export var Bld: Label

@export var HPpr: Label
@export var STpr: Label
@export var W1pr: Label
@export var W2pr: Label
@export var Beastpr: Label

@export var Lvpr: Label
@export var Inpr: Label
@export var Reqpr: Label
@export var Vitpr: Label
@export var Endpr: Label
@export var Strpr: Label
@export var Bldpr: Label


@export var VitBg: Sprite2D
@export var EndBg: Sprite2D
@export var StrBg: Sprite2D
@export var BldBg: Sprite2D


@export var VitUp: TextureButton
@export var VitDwn: TextureButton

@export var EndUp: TextureButton
@export var EndDwn: TextureButton

@export var StrUp: TextureButton
@export var StrDwn: TextureButton

@export var BldUp: TextureButton
@export var BldDwn: TextureButton

var cost = 0
var nextReq = g.ReqInsight
var nextLvl = g.Level

func assign():
	HP.text = str(g.maxhp)
	ST.text = str(g.maxst)
	W1.text = str(g.melee_damage)
	W2.text = str(g.ranged_damage)
	Beast.text = str(g.max_beast_damage)
	
	Lv.text = str(g.Level)
	In.text = str(g.insight)
	Req.text = str(int(g.ReqInsight * 1.2))
	Vit.text = str(g.Vitality)
	End.text = str(g.Endurance)
	Str.text = str(g.Strength)
	Bld.text = str(g.Bloodtinge)
	
	HPpr.text = str(g.maxhp) + " >"
	STpr.text = str(g.maxst) + " >"
	W1pr.text = str(g.melee_damage) + " >"
	W2pr.text = str(g.ranged_damage) + " >"
	Beastpr.text = str(g.max_beast_damage) + " >"
	
	Lvpr.text = str(g.Level) + " >"
	Inpr.text = str(g.insight) + " >"
	Reqpr.text = str(int(g.ReqInsight)) + " >"
	Vitpr.text = str(g.Vitality) + " >"
	Endpr.text = str(g.Endurance) + " >"
	Strpr.text = str(g.Strength) + " >"
	Bldpr.text = str(g.Bloodtinge) + " >"

func _on_visibility_changed():
	reset()
	confirm.frame = 0
	confirm_label.label_settings.font_color = Color("e3d7c179")
	assign()
	nextReq = g.ReqInsight
	
	
	update()

func update():
	if g.insight - cost >= int(nextReq*1.2):
		VitBg.visible = true
		EndBg.visible = true
		StrBg.visible = true
		BldBg.visible = true
		
		VitUp.disabled = false
		EndUp.disabled = false
		StrUp.disabled = false
		BldUp.disabled = false
		
	else:
		VitBg.visible = false
		EndBg.visible = false
		StrBg.visible = false
		BldBg.visible = false
		
		VitUp.disabled = true
		EndUp.disabled = true
		StrUp.disabled = true
		BldUp.disabled = true



func _ready():
	player.pause_pressed.connect(close)


func close():
	if visible:
		a_close.play()
		visible = false
		player.HUD.visible = true
		player.paused = false
		reset()

func _on_confirm_button_pressed():
	a_confirm.play()
	
	g.Level = nextLvl
	g.insight -= int(cost)
	g.ReqInsight = nextReq
	g.iChanged.emit()
	
	g.Vitality = int(VitNext)
	g.Endurance = int(EndNext)
	g.Strength = int(StrNext)
	g.Bloodtinge = int(BldNext)
	
	g.maxhp = int(HPNext)
	g.hp = g.maxhp
	g.hpChanged.emit()
	g.maxhpChanged.emit()
	
	g.maxst = int(StNext)
	g.stChanged.emit()
	g.maxstChanged.emit()
	
	g.melee_damage = int(MeleNext)
	g.ranged_damage = int(RngNext)
	
	reset()


func reset():
	cost = 0
	nextReq = g.ReqInsight
	nextLvl = g.Level
	on_click()
	HP.label_settings.font_color = Color("eee6d8")
	Vit.label_settings.font_color = Color("eee6d8")
	ST.label_settings.font_color = Color("eee6d8")
	End.label_settings.font_color = Color("eee6d8")
	W1.label_settings.font_color = Color("eee6d8")
	Str.label_settings.font_color = Color("eee6d8")
	W2.label_settings.font_color = Color("eee6d8")
	Bld.label_settings.font_color = Color("eee6d8")
	
	assign()
	
	HPpr.visible = false
	STpr.visible = false
	W1pr.visible = false
	W2pr.visible = false
	
	
	VitNext = g.Vitality
	HPNext = g.hp
	EndNext = g.Endurance
	StNext = g.stamina
	StrNext = g.Strength
	MeleNext = g.melee_damage
	BldNext = g.Bloodtinge
	RngNext = g.ranged_damage
	
	Vitpr.visible = false
	Endpr.visible = false
	Strpr.visible = false
	Bldpr.visible = false
	
	VitDwn.visible = false
	EndDwn.visible = false
	StrDwn.visible = false
	BldDwn.visible = false



func on_click():
	update()
	if nextLvl > g.Level:
		Reqpr.visible = true
		Req.label_settings.font_color = Color("6684c2")
		Req.text = str(int(nextReq*1.2))
		Lv.label_settings.font_color = Color("6684c2")
		Lv.text = str(nextLvl)
		Lvpr.visible = true
		confirmButton.disabled = false
		confirm.frame = 1
		confirm_label.label_settings.font_color = Color("e3d7c1")
		Inpr.visible = true
		In.text = str(int(g.insight - cost))
		In.label_settings.font_color = Color("d84747")
	else:
		Reqpr.visible = false
		Req.label_settings.font_color = Color("eee6d8")
		Req.text = str(int(nextReq))
		Lv.label_settings.font_color = Color("eee6d8")
		Lv.text = str(g.Level)
		Lvpr.visible = false
		confirmButton.disabled = true
		confirm.frame = 0
		confirm_label.label_settings.font_color = Color("e3d7c179")
		Inpr.visible = false
		In.text = str(g.insight)
		In.label_settings.font_color = Color("eee6d8")


func up():
	a_ok.play()
	nextReq *= 1.2
	cost += int(nextReq)
	nextLvl += 1

func down():
	a_ok.play()
	cost -= int(nextReq)
	nextReq /= 1.2
	nextLvl -= 1

var VitNext = g.Vitality
var HPNext = g.hp
func _on_vit_lv_up_pressed():
	up()
	VitDwn.visible = true
	Vitpr.visible = true
	Vit.label_settings.font_color = Color("6684c2")
	VitNext += 1
	HPNext *= 1.2
	Vit.text = str(VitNext)
	HP.text = str(int(HPNext))
	HP.label_settings.font_color = Color("6684c2")
	HPpr.visible = true
	on_click()

var EndNext = g.Endurance
var StNext = g.stamina
func _on_end_lv_up_pressed():
	up()
	EndDwn.visible = true
	Endpr.visible = true
	End.label_settings.font_color = Color("6684c2")
	EndNext += 1
	StNext *= 1.1
	End.text = str(EndNext)
	ST.text = str(int(StNext))
	ST.label_settings.font_color = Color("6684c2")
	STpr.visible = true
	on_click()

var StrNext = g.Strength
var MeleNext = g.melee_damage
func _on_str_lv_up_pressed():
	up()
	StrDwn.visible = true
	Strpr.visible = true
	Str.label_settings.font_color = Color("6684c2")
	StrNext += 1
	MeleNext *= 1.1
	Str.text = str(StrNext)
	W1.text = str(int(MeleNext))
	W1.label_settings.font_color = Color("6684c2")
	W1pr.visible = true
	on_click()

var BldNext = g.Bloodtinge
var RngNext = g.ranged_damage
func _on_bld_lv_up_pressed():
	up()
	BldDwn.visible = true
	Bldpr.visible = true
	Bld.label_settings.font_color = Color("6684c2")
	BldNext += 1
	RngNext *= 1.1
	Bld.text = str(BldNext)
	W2.text = str(int(RngNext))
	W2.label_settings.font_color = Color("6684c2")
	W2pr.visible = true
	on_click()


func _on_vit_lv_down_pressed():
	VitNext -= 1
	down()
	HPNext /= 1.2
	Vit.text = str(VitNext)
	HP.text = str(int(HPNext))
	if VitNext == g.Vitality:
		HP.label_settings.font_color = Color("eee6d8")
		HPpr.visible = false
		Vit.label_settings.font_color = Color("eee6d8")
		VitDwn.visible = false
		Vitpr.visible = false
	on_click()

func _on_end_lv_down_pressed():
	EndNext -= 1
	down()
	StNext /= 1.1
	End.text = str(EndNext)
	ST.text = str(int(StNext))
	if EndNext == g.Endurance:
		ST.label_settings.font_color = Color("eee6d8")
		STpr.visible = false
		End.label_settings.font_color = Color("eee6d8")
		EndDwn.visible = false
		Endpr.visible = false
	on_click()

func _on_str_lv_down_pressed():
	StrNext -= 1
	down()
	MeleNext /= 1.1
	Str.text = str(StrNext)
	W1.text = str(int(MeleNext))
	if StrNext == g.Strength:
		W1.label_settings.font_color = Color("eee6d8")
		W1pr.visible = false
		Str.label_settings.font_color = Color("eee6d8")
		StrDwn.visible = false
		Strpr.visible = false
	on_click()

func _on_bld_lv_down_pressed():
	BldNext -= 1
	down()
	RngNext /= 1.1
	Bld.text = str(BldNext)
	W2.text = str(int(RngNext))
	if BldNext == g.Bloodtinge:
		W2.label_settings.font_color = Color("eee6d8")
		W2pr.visible = false
		Bld.label_settings.font_color = Color("eee6d8")
		BldDwn.visible = false
		Bldpr.visible = false
	on_click()

