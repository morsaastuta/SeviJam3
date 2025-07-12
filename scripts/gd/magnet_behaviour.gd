class_name MagnetBehaviour extends RigidBody2D

var held: bool = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if not held and event.is_pressed(): grab()
		elif held and (event.is_released() or event.is_canceled()): drop()

func _physics_process(delta):
	if not held: return
	global_position = get_global_mouse_position()

func grab():
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	held = true
	Global.grabbed.emit(self)
	
func drop():
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	held = false
	Global.dropped.emit(self)
