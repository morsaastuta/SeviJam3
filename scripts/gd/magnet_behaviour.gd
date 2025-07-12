class_name MagnetBehaviour extends RigidBody2D

var held: bool = false

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not held and event.is_pressed(): grab()
			else: drop()

func _physics_process(delta) -> void:
	if not held: return
	print("is held")
	global_position.x = lerp(global_position.x, get_global_mouse_position().x, 0.35)
	global_position.y = lerp(global_position.y, get_global_mouse_position().y, 0.35)

func grab() -> void:
	print("grab")
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	held = true
	Global.grabbed.emit(self)
	
func drop() -> void:
	print("drop")
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	held = false
	Global.dropped.emit(self)
