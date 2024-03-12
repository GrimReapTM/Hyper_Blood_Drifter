extends Control

@export var Master_slider: HSlider
var Master
@export var SFX_slider: HSlider
var SFX
@export var Music_slider: HSlider
var Music

@export var player: CharacterBody2D
@export var a_close: AudioStreamPlayer
@export var Paused: Control

func _ready():
	Master = AudioServer.get_bus_index("Master")
	SFX = AudioServer.get_bus_index("SFX")
	Music = AudioServer.get_bus_index("Music")
	player.pause_pressed.connect(close)
	
	Master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Master))
	SFX_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX))
	Music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Music))


func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(Master, linear_to_db(value))

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(SFX, linear_to_db(value))

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(Music, linear_to_db(value))


func close():
	if visible:
		a_close.play()
		visible = false
		Paused.visible = true
		player.HUD.visible = true
		player.paused = true


#vypne hru 👍
func _on_button_pressed():
	get_tree().quit()
