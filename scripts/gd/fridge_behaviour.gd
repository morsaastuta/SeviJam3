class_name FridgeBehaviour extends Node2D

@export var screen: CanvasModulate
@export var calendar_current: CalendarBehaviour
var calendar_next: CalendarBehaviour

func set_level(calendar_next: CalendarBehaviour) -> void:
	self.add_child(calendar_next)
	# esperar a que cargue
	# animar calendar_current

func show_stickers(on: bool) -> void:
	var tween: Tween = create_tween()
	if on:
		tween.tween_property(screen, "color:a", 0.6, 0.5)
		
	else:
		tween.tween_property(screen, "color:a", 0, 0.5)
