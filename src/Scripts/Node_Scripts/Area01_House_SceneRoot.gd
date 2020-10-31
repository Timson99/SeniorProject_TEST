extends Node


export var camera_bounds = {"is_static": false,
							"max_x" : 100000, 
							"min_x" : -100000,
							"max_y" : -100000,
							"min_y" : 100000,
							}

#export var music_track_path = "res://Assets/Music/No_Place_Like_Home (temp).ogg"


onready var closet = $TileMap/YSort/Closet
onready var main_door_lock = $TileMap/Warp_Outside/MainDoor/CollisionShape2D
onready var main_door_dialogue = $TileMap/Warp_Outside/Dialogue/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	closet.connect("used", self, "open_main_door")
	#BgEngine.facilitate_track_changes(music_track_path)
 

func open_main_door():
	main_door_lock.disabled = true
	main_door_dialogue.disabled = true
	

