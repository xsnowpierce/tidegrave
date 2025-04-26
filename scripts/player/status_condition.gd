extends Resource

class_name StatusCondition

enum CONDITION {
	NORMAL
}

static func get_string_from_condition(condition : CONDITION) -> String:
	match(condition):
		CONDITION.NORMAL:
			return "NORMAL" 
	return "NORMAL"
