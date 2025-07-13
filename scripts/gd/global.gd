extends Node

signal grabbed(magnet: MagnetBehaviour)
signal dropped(magnet: MagnetBehaviour)
signal aborted(magnet: MagnetBehaviour)
signal check_day(day: DayBehaviour)


@onready var fridge: FridgeBehaviour = get_node("../Fridge")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		event.global_position 

func effect_by_name(effect_name: String) -> Name.Effect:
	match effect_name:
		Name.RAIN: return Name.Effect.RAIN
		Name.SUN: return Name.Effect.SUN
		Name.STORM: return Name.Effect.STORM
		Name.RAINBOW: return Name.Effect.RAINBOW
		Name.WIND: return Name.Effect.WIND
		_: return Name.Effect.NONE
