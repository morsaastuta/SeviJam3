extends Sprite2D

func _ready() -> void:
	self.set_instance_shader_parameter("mouse_screen_pos",self.global_position)
	self.set_instance_shader_parameter("hovering",1)
	Global.grabbed.connect(_on_grabbed_magnet)
	Global.dropped.connect(_on_dropped_magnet)
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		self.set_instance_shader_parameter("mouse_screen_pos",get_global_mouse_position())
	
func _on_grabbed_magnet(magnet: MagnetBehaviour):
	if not self.get_parent() == magnet: return
	create_tween().tween_property(self, "scale", Vector2.ONE*0.115, 0.2)
	self.set_instance_shader_parameter("hovering",0.1)
	

func _on_dropped_magnet(magnet: MagnetBehaviour):
	if not self.get_parent() == magnet: return
	create_tween().tween_property(self, "scale", Vector2.ONE*0.1, 0.2)
	self.set_instance_shader_parameter("hovering",1)
	
	
