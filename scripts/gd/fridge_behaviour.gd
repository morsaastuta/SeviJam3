class_name FridgeBehaviour extends Node2D

@export var calendar_default: PackedScene
@export var group_stickers: CanvasGroup
@export var group_calendar: CanvasGroup
var calendar: CalendarBehaviour
var screen: ColorRect

func _ready():
	next_level()
	show_stickers(true)

func next_level() -> void:
	var calendar_next: CalendarBehaviour
	if calendar != null: calendar_next = calendar.next.instantiate()
	else: calendar_next = calendar_default.instantiate()
	group_calendar.add_child(calendar_next)
	# esperar a que cargue
	# animar calendar
	if calendar != null: calendar.queue_free()
	calendar = calendar_next

func show_stickers(on: bool) -> void:
	if on:
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(false)
		calendar.screen.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		create_tween().tween_property(screen, "color", Color(0,0,0,0.6), 0.5)
	else:
		create_tween().tween_property(screen, "color", Color.TRANSPARENT, 0.5)
		calendar.screen.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(true)
