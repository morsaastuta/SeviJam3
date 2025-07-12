class_name FridgeBehaviour extends Node2D

@export var calendar_default: PackedScene
@export var group_stickers: CanvasGroup
@export var group_calendar: CanvasGroup
var calendar: CalendarBehaviour
var screen: ColorRect

func _ready():
	calendar = calendar_default.instantiate()
	next_level()

func next_level() -> void:
	var calendar_next: CalendarBehaviour = calendar.next.instantiate()
	group_calendar.add_child(calendar_next)
	# esperar a que cargue
	# animar calendar
	calendar.queue_free()
	calendar = calendar_next

func show_stickers(on: bool) -> void:
	var tween: Tween = create_tween()
	if on:
		calendar.screen.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		tween.tween_property(screen, "color:a", 0.6, 0.5)
		
	else:
		await tween.tween_property(screen, "color:a", 0, 0.5)
		#await get_tree().create_timer(0.5).timeout
		calendar.screen.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
