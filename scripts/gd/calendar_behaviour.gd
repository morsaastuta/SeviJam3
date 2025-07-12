class_name CalendarBehaviour extends Node2D

@export var screen: ColorRect
@export var next: PackedScene
var selected_magnet: MagnetBehaviour
var held: bool = false

@export var rules: Array[String]

var month: Array[Array]

func _ready() -> void:
	var index:int = 0
	for child in get_children():
		month.append([])
		for grandchild in child.get_children():
			month[index].append(grandchild)
		index += 1

func _mission_achieved():
	pass

func _on_area_2d_body_entered(area):
	pass

func _sticker_achieved():
	pass

func evaluator() -> Array[bool]:
	var array_evaluations: Array[bool]
	for rule in rules:
		var str_array: Array[String] = rule.split("_")
		
		var week_index: int
		match str_array[0]:
			"any":
				week_index = -1
			_:
				week_index = str_array[0].to_int()
				
		var how_many: int = str_array[1].to_int()
		
		var effect: String = str_array[2]
		match effect:
			Name.RAIN:
				for day: DayBehaviour in month[week_index]:
					if day.effect_applied == Name.Effect.RAIN:
						how_many -= 1
		array_evaluations.append(how_many <= 0)  
	
	return array_evaluations
