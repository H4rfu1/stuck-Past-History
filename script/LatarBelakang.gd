extends Control

onready var label = get_node("window/Label")
var message setget set_msg, get_msg
var page setget set_page, get_page
const click_sound = preload("res://scene/Music and Sounds/click.tscn")
const warning_sound = preload("res://scene/Music and Sounds/warning.tscn")
const cerita1 = preload("res://scene/Music and Sounds/cerita1.tscn")
const cerita2 = preload("res://scene/Music and Sounds/cerita2.tscn")

func _ready():
	if(Intro.playing):
		Intro.playing = false
	var Cerita1 = cerita1.instance()
	get_tree().current_scene.add_child(Cerita1)
	create(['Pada tahun 2045, Indonesia sudah kehilangan Identitasnya sebagai negara yang memiliki beragam budaya. Negara yang dahulu dikenal dengan budayanya yang melimpah saat ini hanya tinggal sejarah.',
		   'Harul merupakan seorang ilmuwan yang berhasil menciptakan mesin waktu. Ia ingin menelusuri serta mencari kebenaran budaya Indonesia secara langsung di masa lalu agar dapat menunjukannya kepada seluruh orang.',
		   'Namun dalam percobaan pertamanya Harul mendapatkan masalah. Mesin waktu yang Ia ciptakan mengalami kerusakan hingga membuatnya terjebak dimasa lalu. ',
		   'Untuk dapat memperbaiki mesin waktu tersebut, Harul diharuskan untuk mengumpulkan berbagai Replika peninggalan sejarah. Bisakah dirimu membantu Harul?'
		   ])






func set_msg(value):
	message = value
func get_msg():
	return message

func set_page(value):
	page = value
	$AnimationPlayer.play("page_"+str(page+1))
	for node in get_tree().get_nodes_in_group("scene"):
		node.hide()
		if node.name == "scene_"+str(page+1):
			node.show()
	if(page+1 == 3):
		$AnimationPlayer2.play("page_"+str(page+1))
	elif(page+1 == 4):
		var warningSound = warning_sound.instance()
		get_tree().current_scene.add_child(warningSound)
		var Cerita2 = cerita2.instance()
		get_tree().current_scene.add_child(Cerita2)
		get_node("cerita1").playing = false;

func get_page():
	return page

func create(message: Array):
	set_msg(message)
	set_page(0)
	label.percent_visible = 0
	label.visible_characters = 0
	label.set_bbcode(message[0])

func _on_Timer_timeout():
	label.set_visible_characters(label.visible_characters +1)

func _on_btn_skip_pressed():
	if(label.visible_characters > len(label.text)):
		message = get_msg()
		set_page(get_page()+1)
		if(len(message) == get_page()):
			_on_btn_close_pressed()
		else:
			var clickSound = click_sound.instance()
			get_tree().current_scene.add_child(clickSound)
			label.percent_visible = 0
			label.visible_characters = 0
			label.set_bbcode(message[get_page()])
	else:
		var clickSound = click_sound.instance()
		get_tree().current_scene.add_child(clickSound)
		label.visible_characters = 9999

func _on_btn_close_pressed():
	var clickSound = click_sound.instance()
	get_tree().current_scene.add_child(clickSound)
	get_tree().change_scene("res://scene/Menu/Main.tscn")
	if get_node("cerita2"):
		get_node("cerita2").playing = false;
	elif get_node("cerita1"):
		get_node("cerita1").playing = false;
