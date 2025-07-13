class_name FridgeBehaviour extends Node2D

@export var calendar_default: PackedScene
var calendar: CalendarBehaviour
@export var group_stickers: CanvasGroup
@export var group_calendar: CanvasGroup
var screen: ColorRect

func _ready():
	next_level()

func check_requisites() -> void:
	if calendar.mission_is_achieved:
		%ContinueButton.mouse_filter = Control.MOUSE_FILTER_STOP
		create_tween().tween_property(%ControlContinueBtn, "modulate", Color.WHITE, 0.5)
	else:
		create_tween().tween_property(%ControlContinueBtn, "modulate", Color.TRANSPARENT, 0.5)
		%ContinueButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func _on_continue_button_pressed() -> void:
	if not calendar.mission_is_achieved: return
	
	if calendar.sticker_is_achieved: show_stickers(true)
	else: next_level()
	
	create_tween().tween_property(%ControlContinueBtn, "modulate", Color.TRANSPARENT, 0.5).from(Color.WHITE)
	%ContinueButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

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
		screen.show()
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(false)
		create_tween().tween_property(screen, "color", Color(0,0,0,.6), 0.5)
	else:
		screen.color = Color.TRANSPARENT
		create_tween().tween_property(screen, "color", Color.TRANSPARENT, 0.5)
		await get_tree().create_timer(0.5).timeout
		screen.hide()
		for magnet: MagnetBehaviour in get_tree().get_nodes_in_group(Name.MAGNETS): magnet.set_input_pickable(true)
