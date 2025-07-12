extends Node

signal grabbed(magnet: MagnetBehaviour)
signal dropped(magnet: MagnetBehaviour)
signal check_day(day: DayBehaviour)

@onready var fridge: FridgeBehaviour = get_node("../Fridge")
