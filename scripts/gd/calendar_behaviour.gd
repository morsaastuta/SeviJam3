class_name CalendarBehaviour extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children().filter(func(c): return c as Area2D):
		child = child as Area2D
		child.body_entered.connect(_on_area_2d_body_entered).bind(child)
		child.body_exited.connect(_on_area_2d_body_exited).bind(child)

func _on_area_2d_body_entered(area):
	pass

func _on_area_2d_body_exited(area):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
