class_name DayBehaviour extends Area2D

@onready var selected_magnet: MagnetBehaviour = Global.fridge.calendar.selected_magnet
@export var sprite: Sprite2D
@export var textures: Dictionary[Effect, Texture2D]
@export var no_magnet: bool
@export var no_apply_drawing: bool
@export var requirements: Dictionary[StringName, bool]
@export var magnet_marker: Marker2D
var magnet_position: Vector2
var magnet_hover: MagnetBehaviour

var magnet_applied: MagnetBehaviour:
	get:
		return magnet_applied
	set(value):
		magnet_applied = value
		if magnet_applied: effect_applied = Effect.RAIN; no_apply_drawing = true
		else: effect_applied = Effect.NONE; no_apply_drawing = false

var effect_applied: Effect = Effect.NONE:
	get:
		return effect_applied
	set(value):
		effect_applied = value
		sprite.texture = textures[effect_applied]

func _ready() -> void:	
	if not no_magnet:
		Global.grabbed.connect(_on_magnet_grabbed)	
		if not magnet_marker: magnet_position = self.global_position
		else: magnet_position = magnet_marker.global_position
	Global.dropped.connect(_on_magnet_dropped)
	Global.check_day.connect(_self_check)

func _on_magnet_dropped(magnet: MagnetBehaviour) -> void:
	if not magnet_hover: return
	if not magnet_hover == selected_magnet: printerr("QUE COÑO?, day_behaviour.gd")
	
	if no_magnet or magnet_applied: 
		magnet_hover.abort() 
		if self.global_position == magnet_hover.origin: magnet_applied = magnet_hover
	else:
		create_tween().tween_property(magnet_hover, "global_position", magnet_position, 0.15)#.from(magnet_hover.global_position)
		magnet_applied = magnet_hover
	
	Global.check_day.emit(self)
	magnet_hover = null
	selected_magnet = null

func _on_magnet_grabbed(magnet: MagnetBehaviour) -> void:
	if not magnet_applied: return
	if magnet_hover: return
	
	magnet_hover = magnet_applied
	selected_magnet = magnet_hover
	magnet_applied = null
	Global.check_day.emit(self)

func _on_body_entered(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	magnet_hover = body as MagnetBehaviour
	
	if selected_magnet: return
	selected_magnet = body as MagnetBehaviour

func _on_body_exited(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	if not selected_magnet: return
	if not selected_magnet == body: return
	
	magnet_hover = null
	selected_magnet = null

func _self_check() -> void:
	for key in requirements.keys():
		match key:
			ReqName.RAIN: requirements[key] = effect_applied == Effect.RAIN 
			ReqName.SUN: requirements[key] = effect_applied == Effect.SUN
			ReqName.STORM: requirements[key] = effect_applied == Effect.STORM
			ReqName.RAINBOW: requirements[key] = effect_applied == Effect.RAINBOW
			ReqName.WIND: requirements[key] = effect_applied == Effect.WIND
