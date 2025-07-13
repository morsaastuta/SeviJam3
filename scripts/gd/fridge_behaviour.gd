class_name FridgeBehaviour extends Node2D

@export var calendar_default: PackedScene
var calendar: CalendarBehaviour
var calendar_next: CalendarBehaviour
@export var group_stickers: CanvasGroup
@export var group_calendar: CanvasGroup
var screen: ColorRect

func _ready():
	next_level()

func next_level() -> void:
	if not calendar: calendar_next = calendar_default.instantiate()
	else: calendar_next = calendar.next.instantiate()
	
	group_calendar.add_child(calendar_next)
	# esperar a que cargue
	# animar calendar
	if calendar: calendar.queue_free()
	calendar = calendar_next

func show_stickers(on: bool) -> void:
	if on:
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(false)
		create_tween().tween_property(screen, "color", Color(0,0,0,0.6), 0.5)
	else:
		create_tween().tween_property(screen, "color", Color.TRANSPARENT, 0.5)
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(true)
