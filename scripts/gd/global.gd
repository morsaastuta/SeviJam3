extends Node

signal grabbed(magnet: MagnetBehaviour)
signal dropped

@onready var fridge: FridgeBehaviour = get_node("Fridge")
@onready var fridge_stickers: FridgeBehaviour = get_node("Fridge/GroupStickers")
@onready var fridge_calendar: FridgeBehaviour = get_node("Fridge/GroupCalendar")
@onready var fridge_tray: 
