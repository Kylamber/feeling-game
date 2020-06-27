extends Control

# Sounds
onready var _sfx_menu: AudioStreamPlayer = $sfx_menu

# Nodes
onready var _btn_continue: Button = $vbox_interface/vbox_buttons/btn_continue
onready var _btn_new_game: Button = $vbox_interface/vbox_buttons/btn_new_game
onready var _btn_settings: Button = $vbox_interface/vbox_buttons/btn_settings
onready var _btn_quit: Button = $vbox_interface/vbox_buttons/btn_quit


func _ready() -> void:
	pause.pausable = false
	audio.play("bgm_main_menu")
	if not File.new().file_exists("user://data.json"):
		_btn_continue.disabled = true


func _on_btn_new_game_pressed() -> void:
	_sfx_menu.play()
	save_and_load.new_game()
	fade.transition(save_and_load.data["level"]["level_path"], 0.5, global.player_appear_location)
	pause.pausable = true


func _on_btn_continue_pressed() -> void:
	_sfx_menu.play()
	save_and_load.load_game()
	fade.transition(save_and_load.data["level"]["level_path"], 0.5, global.player_appear_location) 
	pause.pausable = true


func _on_btn_quit_pressed() -> void:
	_sfx_menu.play()
	get_tree().quit()


func _on_btn_settings_pressed():
	_sfx_menu.play()
	var settings: Control = load("res://ui/ui_settings.tscn").instance()
	add_child(settings)


func _on_btn_credits_pressed():
	_sfx_menu.play()
	var settings: Control = load("res://ui/ui_credits.tscn").instance()
	add_child(settings)


func _set_text_lang():
	if global.system_language == "english":
		_btn_continue.text = "Continue"
		_btn_new_game.text = "New Game"
		_btn_quit.text = "Quit"
		_btn_settings.text = "Settings"
	elif global.system_language == "indonesia":
		_btn_continue.text = "Lanjut"
		_btn_new_game.text = "Game Baru"
		_btn_quit.text = "Keluar"
		_btn_settings.text = "Pengaturan"


