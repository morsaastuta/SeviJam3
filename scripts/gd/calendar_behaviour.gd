class_name CalendarBehaviour extends Node2D

@export var screen: ColorRect
@export var next: PackedScene
var selected_magnet: MagnetBehaviour
var held: bool = false

func _mission_achieved():
	pass

func _on_area_2d_body_entered(area):
	pass

func _sticker_achieved():
	pass
