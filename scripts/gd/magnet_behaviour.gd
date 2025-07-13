class_name MagnetBehaviour extends RigidBody2D

@export var area: Area2D
var origin: Vector2
var held: bool = false
var day: DayBehaviour

func _ready():
	origin = global_position

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if !Global.fridge.calendar.held and !held and event.is_pressed(): grab()
		elif Global.fridge.calendar.held and held and !event.is_pressed(): drop()

func _physics_process(delta) -> void:
	if !Global.fridge.calendar.held || !held: return
	global_position.x = lerp(global_position.x, get_global_mouse_position().x, 0.35)
	global_position.y = lerp(global_position.y, get_global_mouse_position().y, 0.35)

func grab() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	grab_commons()
	Global.grabbed.emit(self)
	
func drop() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	drop_commons()
	Global.dropped.emit(self)

func abort() -> void:
	drop_commons()
	create_tween().tween_property(self, "global_position", origin, 0.25)
	Global.aborted.emit(self)

func grab_commons() -> void:
	held = true
	Global.fridge.calendar.selected_magnet = self
	Global.fridge.calendar.held = true

func drop_commons() -> void:
	held = false
	Global.fridge.calendar.selected_magnet = null
	Global.fridge.calendar.held = false

func set_input_pickable(p: bool) -> void:
	area.input_pickable = p
