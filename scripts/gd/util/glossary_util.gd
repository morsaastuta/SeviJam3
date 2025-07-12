class_name Name

# Groups
const MAGNETS: StringName = &"magnets"
const STICKERS: StringName = &"stickers"

# Required names
const RAIN: StringName = &"rain"
const SUN: StringName = &"sun"
const STORM: StringName = &"storm"
const RAINBOW: StringName = &"rainbow"
const WIND: StringName = &"wind"

# Enums
enum Effect {NONE, RAIN, SUN, STORM, RAINBOW, WIND}

func effect_by_name(effect_name: String) -> Effect:
	match effect_name:
		RAIN: return Effect.RAIN
		SUN: return Effect.SUN
		STORM: return Effect.STORM
		RAINBOW: return Effect.RAINBOW
		WIND: return Effect.WIND
		_: return Effect.NONE
