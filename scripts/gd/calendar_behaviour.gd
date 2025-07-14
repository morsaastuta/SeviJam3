class_name CalendarBehaviour extends Node2D

@export var screen: ColorRect
@export var next: PackedScene
@export var sticker_quantity_rules: int
@export var rules: Array[String]
@export var sounder: AudioStreamPlayer

var selected_magnet: MagnetBehaviour
var held: bool = false
var month: Array[Array]

var sticker_is_achieved: bool
var mission_is_achieved: bool

var sounded: bool = false

func _ready() -> void:
	var index:int = 0
	for child in get_children():
		if child is WeekBehaviour:
			month.append([])
			for grandchild in child.get_children():
				if grandchild is DayBehaviour:
					month[index].append(grandchild)
			index += 1
	Global.fridge.screen = screen
	Global.grabbed.connect(_on_magnet_grabbed)
	Global.dropped.connect(_on_magnet_dropped)
	Global.aborted.connect(_on_magnet_dropped)

func _on_magnet_grabbed(magnet: MagnetBehaviour):
	generate_climate(false)
	mission_is_achieved = _mission_achieved()
	sticker_is_achieved = _sticker_achieved()
	Global.fridge.check_requisites()

func _on_magnet_dropped(magnet: MagnetBehaviour):
	generate_climate(true)
	mission_is_achieved = _mission_achieved()
	sticker_is_achieved = _sticker_achieved()
	Global.fridge.check_requisites()

func generate_climate(dropping: bool):
	var days: Array[DayBehaviour]
	days.append_array(get_tree().get_nodes_in_group(Name.DAYS))
	if !dropping:
		for day: DayBehaviour in days:
			if !day.magnet_applied: day.rem_effect()
	sounded = false
	for day: DayBehaviour in days:
		var idx: int = days.find(day)
		if day.effect_applied == Name.Effect.NONE:
			# DUPLICATE
			if (idx >= 14 &&
			days[idx-7].effect_applied == Name.Effect.RAINBOW):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, days[idx-14].effect_applied, dropping)
			# WIND
			elif (idx >= 2 &&
			days[idx-1].effect_applied == Name.Effect.RAIN &&
			days[idx-2].effect_applied == Name.Effect.RAIN):
				days[idx-14].effect_applied
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.WIND, dropping)
			# RAINBOW A
			elif (idx >= 2 &&
			days[idx-1].effect_applied == Name.Effect.RAIN &&
			days[idx-2].effect_applied == Name.Effect.SUN):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.RAINBOW, dropping)
			# RAINBOW B
			elif (idx >= 2 &&
			days[idx-1].effect_applied == Name.Effect.SUN &&
			days[idx-2].effect_applied == Name.Effect.RAIN):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.RAINBOW, dropping)
			# RAIN A
			elif (idx >= 2 &&
			days[idx-1].effect_applied == Name.Effect.STORM &&
			days[idx-2].effect_applied == Name.Effect.WIND):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.RAIN, dropping)
			# RAIN B
			elif (idx >= 8 &&
			days[idx-7].effect_applied == Name.Effect.STORM &&
			days[idx-8].effect_applied == Name.Effect.WIND):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.RAIN, dropping)
	for day: DayBehaviour in days:
		var idx: int = days.find(day)
		if day.effect_applied == Name.Effect.NONE:
			# STORM
			if (idx >= 1 && idx <= days.size()-2 &&
			days[idx-1].effect_applied == Name.Effect.RAIN &&
			days[idx+1].effect_applied == Name.Effect.RAIN):
				sounded = true
				if dropping: await get_tree().create_timer(0.1).timeout
				set_weather(day, Name.Effect.STORM, dropping)
	if dropping && sounded: sounder.play()
	
func set_weather(day: DayBehaviour, weather: Name.Effect, dropping: bool) -> void:
	day.set_effect(weather)

func _mission_achieved() -> bool:
	var evaluation := evaluator()
	var m_is_achieved: bool = true
	var n_is_achieved: bool = true
	for i in range(sticker_quantity_rules, evaluation[0].size()):
		if not evaluation[0][i]: m_is_achieved = false; break
	for n in evaluation[1]:
		if not n: n_is_achieved = false; break
	return n_is_achieved and m_is_achieved

func _sticker_achieved() -> bool:
	var evaluation := evaluator()[0]
	if sticker_quantity_rules >= 1:
		var sticker_is_achieved: bool = true
		for i in range(sticker_quantity_rules):
			if not evaluation[i]:
				sticker_is_achieved = false
				break
		return sticker_is_achieved
	else: return false

func evaluator() -> Array[Array]:
	var array_evaluations: Array[Array] = [[],[]]
	for rule in rules:
		var str_array: Array[String]
		str_array.append_array(rule.split("_"))
		
		var week_index: int
		match str_array[0]:
			"any": week_index = -1
			_: week_index = str_array[0].to_int()
				
		var how_many: int = str_array[1].to_int()
		
		var effect: String = str_array[2]
		if week_index >= 0:
			for day in month[week_index]:
				if day.effect_applied == Global.effect_by_name(effect):
					how_many -= 1
		else:
			for week in month:
				for day:DayBehaviour in week:
					if day.effect_applied == Global.effect_by_name(effect):
						how_many -= 1
		array_evaluations[0].append(how_many <= 0)  
	
	for week in month:
		for day: DayBehaviour in week:
			for requirement in day.requirements.values():
				array_evaluations[1].append(requirement)
	
	return array_evaluations
