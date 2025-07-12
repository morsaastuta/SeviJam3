extends Area2D

@export var calendar: CalendarBehaviour
@export var magnet_marker: Marker2D
var magnet_position: Vector2

@export var no_magnet: bool
@export var restrictions: Dictionary[StringName, bool] = {
	
}

var magnet_hover: MagnetBehaviour
var magnet_applied: MagnetBehaviour

func _ready() -> void:
	if not calendar and get_parent() is CalendarBehaviour:
		calendar = get_parent()
	
	if not magnet_marker: magnet_position = self.global_position
	else: magnet_position = magnet_marker.global_position
	
	Global.grabbed.connect(_on_magnet_grabbed)
	Global.dropped.connect(_on_magnet_dropped)

func _on_magnet_dropped(magnet: MagnetBehaviour):
	if not magnet_hover: return
	if not magnet_hover == calendar.selected_magnet: printerr("QUE COÑO?, day_behaviour.gd")
	
	create_tween().tween_property(magnet_hover, "global_position", magnet_position, 0.15).set_delay(0.15)#.from(magnet_hover.global_position)
	magnet_applied = magnet_hover
	magnet_hover = null; calendar.selected_magnet = null

func _on_magnet_grabbed(magnet: MagnetBehaviour):
	if not magnet_applied: return
	if magnet_hover: return
	
	magnet_hover = magnet_applied
	calendar.selected_magnet = magnet_hover
	magnet_applied = null

func _on_body_entered(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	magnet_hover = body as MagnetBehaviour
	
	if calendar.selected_magnet: return
	calendar.selected_magnet = body as MagnetBehaviour

func _on_body_exited(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	if not calendar.selected_magnet: return
	if not calendar.selected_magnet == body: return
	
	magnet_hover = null
	calendar.selected_magnet = null
