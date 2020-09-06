
extends CanvasLayer


func _ready():
	for i in get_parent().get_children():
		print(i.name)
	set_visible(false)
	$setting_window/window/pause.show()
	$setting_window/window/btn_close.hide()
	$setting_window/window/contain.hide()
	$setting_window/window/name.hide()
	$setting_window/window/username.hide()
	$setting_window/window/btn_confirm.hide()
	$setting_window/window/pause/Continue.connect("pressed", self, "_on_Continue_pressed")
	$setting_window/window/pause/Menu.connect("pressed", self, "_on_Menu_pressed")

func _input(event):
	if event.is_action_pressed("pause"): # escape button by default
		set_visible(!get_tree().paused) # if not pause then hide
		get_tree().paused = !get_tree().paused # toggle pause status

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible



func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)


func _on_Menu_pressed():
	_on_Continue_pressed()
	get_tree().change_scene("res://scene/Menu/Chapter/Ch"+str(GlobalVar.get_jilid())+".tscn")
