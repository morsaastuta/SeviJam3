class_name CalendarBehaviour extends Node2D

@export var screen: ColorRect
@export var next: PackedScene
var selected_magnet: MagnetBehaviour
var held: bool = false

@export var rules: Array[String]

@export var 
func _ready() -> void:
	pass

func _mission_achieved():
	pass

func _on_area_2d_body_entered(area):
	pass

func _sticker_achieved():
	pass

func string_to_calendar(str:String):
	var str_array := str.split("_")
	match str_array[0]:
		"any":
			pass
		"all":
			pass
		_:
			var n:int = str_array[0].to_int()
			
	
