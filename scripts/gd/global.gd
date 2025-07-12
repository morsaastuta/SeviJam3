extends Node

signal grabbed(magnet: MagnetBehaviour)
signal dropped(magnet: MagnetBehaviour)

@onready var fridge: FridgeBehaviour = get_node("../Fridge")
