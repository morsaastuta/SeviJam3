class_name DayBehaviour extends Area2D

@export var sprite: Sprite2D
@export var textures: Dictionary[Name.Effect, Texture2D]
@export var no_magnet: bool
@export var requirements: Dictionary[StringName, bool]
@export var magnet_marker: Marker2D
@export var animation_fade: AnimationPlayer
@export var progress_anim: float = -0.1:
	get:
		return progress_anim
	set(value):
		progress_anim = value
		if sprite.texture: sprite.set_instance_shader_parameter("progress", progress_anim)
	
var magnet_position: Vector2
var magnet_hover: MagnetBehaviour
var is_playing_backwards: bool 

var magnet_applied: MagnetBehaviour:
	get:
		return magnet_applied
	set(value):
		magnet_applied = value
		if magnet_applied: effect_applied = Name.Effect.RAIN
		else: effect_applied = Name.Effect.NONE

@export var effect_default: Name.Effect = Name.Effect.NONE

var will_animate: bool = true
var previous_effect_applied: Name.Effect

var effect_applied: Name.Effect:
	get:
		return effect_applied
	set(value):
		if effect_applied == value: return
		print(self,"PRE effect:",effect_applied, " value:",value ," previous:",previous_effect_applied)
		previous_effect_applied = effect_applied
		effect_applied = value
		print(will_animate)
		print(self,"POST effect:",effect_applied, " value:",value ," previous:",previous_effect_applied)
		
		if magnet_applied: 
			sprite.texture = textures[Name.Effect.NONE]
		else:
			if will_animate:
					if effect_applied == 0 : 
						is_playing_backwards = true
						animation_fade.play_backwards("fade")
					else: 
						sprite.texture = textures[effect_applied]
						animation_fade.play("fade")
			else:
				sprite.texture = textures[effect_applied]
				animation_fade.play("NORESET")
				will_animate = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET" or not is_playing_backwards:return
	sprite.texture = textures[effect_applied]
	is_playing_backwards = false

func _ready() -> void:
	animation_fade.play("RESET")
	if not no_magnet:
		Global.grabbed.connect(_on_magnet_grabbed)
		magnet_position = self.global_position
	Global.dropped.connect(_on_magnet_dropped)
	Global.check_day.connect(_self_check)
	effect_applied = effect_default
	
func _process(delta):
	if magnet_applied: magnet_applied.global_position = global_position

func _on_magnet_dropped(magnet: MagnetBehaviour) -> void:
	if (not magnet_hover) || magnet.day != null: return
	
	if no_magnet || effect_applied != Name.Effect.NONE:
		magnet_hover.abort()
	else:
		create_tween().tween_property(magnet_hover, "global_position", magnet_position, 0.15)
		#.from(magnet_hover.global_position)
		magnet_applied = magnet_hover
		magnet_applied.day = self
	
	magnet_hover = null
	Global.check_day.emit()

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
		requirements[key] = effect_applied == Global.effect_by_name(key)
		
func set_effect(e: Name.Effect, d:bool) -> void:
	if effect_applied != Name.Effect.NONE: return
	if e == previous_effect_applied and not d: will_animate = false
	effect_applied = e
	_self_check()

func rem_effect() -> void:
	if effect_default == Name.Effect.NONE && effect_applied != Name.Effect.NONE:
		effect_applied = Name.Effect.NONE
