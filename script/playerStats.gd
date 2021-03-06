extends Node

export(int) var max_health = 3 setget set_max_health
var health = max_health setget set_health
var status = "ongoing"
var baju = "" setget set_baju, get_baju

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func get_heath():
	return health

func _ready():
	self.health = max_health

func set_baju(args):
	baju = args
func get_baju():
	return baju

