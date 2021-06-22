extends Control

export var alive := true
var stats = EntityStats.new()


var moveset = null

func _ready():
	SaveManager.register(self)
	
func on_load():
	var temp_battle_stats #= stats

# Called upon enemy's defeat
func deactivate_enemy():
	# Indicate enemy's defeat and remove sprite from party
	pass 
	
func save():
	return {
		"alive" : alive, 
	}
