class_name FridgeBehaviour extends Node2D

@export var calendar_current: CalendarBehaviour
var calendar_next: CalendarBehaviour

func set_level(calendar_next: CalendarBehaviour) -> void:
	self.add_child(calendar_next)
	# esperar a que cargue
	# animar calendar_current
