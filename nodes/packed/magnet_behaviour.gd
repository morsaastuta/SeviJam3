class_name MagnetBehaviour extends Area2D

var held: bool = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed(): grab()
		elif event.is_released() or event.is_canceled(): drop()

func _physics_process(delta):
	if not held: return
	global_position = get_global_mouse_position()

func grab():
	if held: return
	held = true
	Global.grabbed.emit(self)
	
func drop():
	if not held: return
	held = false
	Global.dropped.emit(self)
