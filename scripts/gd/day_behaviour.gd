class_name DayBehaviour extends Area2D

@export var sprite: Sprite2D
@export var textures: Dictionary[Name.Effect, Texture2D]
@export var no_magnet: bool
@export var requirements: Dictionary[StringName, bool]
@export var magnet_marker: Marker2D
var magnet_position: Vector2
var magnet_hover: MagnetBehaviour

var magnet_applied: MagnetBehaviour:
	get:
		return magnet_applied
	set(value):
		magnet_applied = value
		if magnet_applied: effect_applied = Name.Effect.RAIN
		else: effect_applied = Name.Effect.NONE

@export var effect_default: Name.Effect = Name.Effect.NONE
var effect_applied: Name.Effect:
	get:
		return effect_applied
	set(value):
		effect_applied = value
		if magnet_applied: sprite.texture = textures[0]
		else: sprite.texture = textures[effect_applied]

func _ready() -> void:
	if not no_magnet:
		Global.grabbed.connect(_on_magnet_grabbed)
		if not magnet_marker: magnet_position = self.global_position
		else: magnet_position = magnet_marker.global_position
	Global.dropped.connect(_on_magnet_dropped)
	Global.check_day.connect(_self_check)
	effect_applied = effect_default

func _on_magnet_dropped(magnet: MagnetBehaviour) -> void:
	if (not magnet_hover) || magnet.day != null: return
	
	if no_magnet or magnet_applied: 
		magnet_hover.abort()
		if self.global_position == magnet_hover.origin: magnet_applied = magnet_hover
	else:
		create_tween().tween_property(magnet_hover, "global_position", magnet_position, 0.15)
		#.from(magnet_hover.global_position)
		magnet_applied = magnet_hover
		magnet_applied.day = self
	
	Global.check_day.emit()
	magnet_hover = null

func _on_magnet_grabbed(magnet: MagnetBehaviour) -> void:
	if (not magnet_applied) || magnet_applied != magnet: return
	
	magnet_hover = magnet_applied
	magnet_applied.day = null
	magnet_applied = null
	Global.check_day.emit()

func _on_body_entered(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	magnet_hover = body as MagnetBehaviour

func _on_body_exited(body: Node2D) -> void:
	if not body is MagnetBehaviour: return
	magnet_hover = null

func _self_check() -> void:
	for key in requirements.keys():
		requirements[key] = effect_applied == key
		
func set_effect(e: Name.Effect):
	if effect_applied != Name.Effect.NONE: return
	effect_applied = e

func rem_effect():
	if effect_default == Name.Effect.NONE && effect_applied != Name.Effect.NONE:
		print("removing")
		effect_applied = Name.Effect.NONE
