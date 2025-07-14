extends Button

func _on_mouse_entered() -> void: create_tween().tween_property(self, "scale", Vector2.ONE*1.10, 0.1)

func _on_mouse_exited() -> void: create_tween().tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_button_down() -> void: create_tween().tween_property(self, "scale", Vector2.ONE*0.9, 0.025)

func _on_button_up() -> void: create_tween().tween_property(self, "scale", Vector2.ONE, 0.05)

func _on_pressed(): %ButtonSound.play(); print("A")
