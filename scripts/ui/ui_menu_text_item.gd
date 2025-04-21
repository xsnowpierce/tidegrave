extends HBoxContainer

class_name UIMenuTextItem

@onready var value: Label = $Value
@onready var string: Label = $String

func set_text(label : String, amount : String) -> void:
	value.text = amount
	string.text = label
