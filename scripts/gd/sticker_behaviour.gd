class_name StickerBehaviour extends Sprite2D

@export var audio_grab: AudioStreamPlayer
@export var audio_drop: AudioStreamPlayer
@export var area: Area2D
var held: bool = false

func _ready() -> void:
	self.set_instance_shader_parameter("hovering",0.0)

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if !Global.fridge.calendar.held && !held && event.is_action_pressed("click"): grab()
		elif (Global.fridge.calendar.held && held && event.is_action_pressed("click") and 
		not area.has_overlapping_areas()): drop()

func _physics_process(delta) -> void:
	if !Global.fridge.calendar.held || !held: return
	global_position.x = lerp(global_position.x, get_global_mouse_position().x, 0.35)
	global_position.y = lerp(global_position.y, get_global_mouse_position().y, 0.35)

func _on_area_stay():
	pass

func grab() -> void:
	audio_grab.play()
	reparent(Global.fridge)
	held = true
	Global.fridge.calendar.held = true
	Global.fridge.show_stickers(false)
	create_tween().tween_property(self, "scale", Vector2.ONE*0.32, 0.2)

func drop() -> void:
	audio_drop.play()
	create_tween().tween_property(self, "scale", Vector2.ONE*0.3, 0.2)
	self.z_index = 0
	reparent(Global.fridge.group_stickers)
	held = false
	Global.fridge.calendar.held = false
	material = null
	set_input_pickable(false)
	Global.fridge.next_level()

func set_input_pickable(on: bool) -> void:
	area.input_pickable = on

func _on_area_2d_mouse_entered() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE*0.315, 0.2)

func _on_area_2d_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE*0.3, 0.2)
