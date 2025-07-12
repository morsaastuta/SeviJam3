class_name StickerBehaviour extends Sprite2D

var held: bool = false

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if not held and event.is_pressed(): grab()
		elif held and not event.is_pressed(): drop()

func _physics_process(delta) -> void:
	if not held: return
	global_position.x = lerp(global_position.x, get_global_mouse_position().x, 0.35)
	global_position.y = lerp(global_position.y, get_global_mouse_position().y, 0.35)

func grab() -> void:
	reparent(Global.fridge)
	held = true
	Global.fridge.show_stickers(false)
	
func drop() -> void:
	reparent(Global.fridge.group_stickers)
	held = false


func _on_area_2d_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
