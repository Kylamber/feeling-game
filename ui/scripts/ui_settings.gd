extends Control

onready var language_options: OptionButton = $OptionButton

func _ready() -> void:
	_add_items()
	match global.system_language:
		"indonesia":
			language_options.select(0)
		"english":
			language_options.select(1)


func _add_items() -> void:
	language_options.add_item("Indonesia")
	language_options.add_item("English")


func _on_OptionButton_item_selected(id) -> void:
	match str(id):
		"0":
			save_and_load.data["settings"]["language"] = "indonesia"
			global.system_language = "indonesia"
		"1":
			save_and_load.data["settings"]["language"] = "english"
			global.system_language = "english"
	save_and_load.save_game()


func _on_btn_back_pressed() -> void:
	queue_free()


func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		queue_free()
