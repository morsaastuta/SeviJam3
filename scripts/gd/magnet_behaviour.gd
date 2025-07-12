class_name MagnetBehaviour extends RigidBody2D

@export var area: Area2D
var origin: Vector2
var held: bool = false

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if !Global.fridge.calendar.held and !held and event.is_pressed(): grab()
		elif Global.fridge.calendar.held and held and !event.is_pressed(): drop()

func _physics_process(delta) -> void:
	if !Global.fridge.calendar.held || !held: return
	global_position.x = lerp(global_position.x, get_global_mouse_position().x, 0.35)
	global_position.y = lerp(global_position.y, get_global_mouse_position().y, 0.35)

func grab() -> void:
	origin = global_position
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	held = true
	Global.fridge.calendar.held = true
	Global.grabbed.emit(self)
	
func drop() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	held = false
	Global.fridge.calendar.held = false
	Global.dropped.emit(self)

func abort() -> void:
	held = false
	Global.fridge.calendar.held = false
	create_tween().tween_property(self, "global_position", origin, 0.5)
	Global.dropped.emit(self)

func set_input_pickable(p: bool) -> void:
	area.input_pickable = p
