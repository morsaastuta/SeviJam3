extends Node

signal grabbed(magnet: MagnetBehaviour)
signal dropped(magnet: MagnetBehaviour)

@onready var fridge: FridgeBehaviour = get_node("../Fridge")
@onready var fridge_stickers: CanvasGroup = get_node("../Fridge/GroupStickers")
@onready var fridge_calendar: CanvasGroup = get_node("../Fridge/GroupCalendar")
