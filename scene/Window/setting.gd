extends Control

var sound_state = true

func _ready():
	pass # Replace with function body.


func _on_btn_help_pressed():
	$dialog_window.create(["???\nComing soon"])

func _on_btn_credit_pressed():
	$dialog_window.create(["Game ini dibuat oleh Kelompok Tapesoft, Universitas Jember \nOur Teams: \nHigh concept: M Amri Zaman \nMain programmer: M Fahrul Hafidz \nArtist & programmer: Hartawan Bahari M "])

func _on_lisensi_pressed():
	$dialog_window.create(["???\nComing soon"])

func _on_btn_sound_pressed():
	var sound_btn = $window/contain/btn_group/btn_sound
	if(sound_state):
		sound_btn.texture_normal  = load("res://assets/UI/button/sound_mute.png")
		sound_btn.texture_pressed = load("res://assets/UI/button/sound_mute_press.png")
		sound_btn.texture_hover   = load("res://assets/UI/button/sound_mute_press.png")
	else:
		sound_btn.texture_normal  = load("res://assets/UI/button/sound.png")
		sound_btn.texture_pressed = load("res://assets/UI/button/sound_press.png")
		sound_btn.texture_hover   = load("res://assets/UI/button/sound_press.png")
	sound_state = !sound_state

func _on_btn_close_pressed():
	$".".visible = false
