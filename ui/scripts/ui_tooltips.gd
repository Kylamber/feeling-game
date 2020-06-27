extends CanvasLayer

var tool_tips: Dictionary = {
			"english": {
				"dialogue" : "Press SPACE to interact",
				"key_found" : "You have found a key to the patient's heart",
				"dungeon_wrath_enter" : "Wrath's Feeling Dungeon",
				"dungeon_lone_enter" : "Lone's Feeling Dungeon",
				"dungeon_nycto_enter" : "Nyctophobe's Feeling Dungeon",
				"dungeon_depression_enter" : "Depression's Feeling Dungeon",
				"dungeon_door" : "Unlocked",
				"dungeon_finished" : "Dungeon cleared, returning to the real world",
				"dungeon_room_finished" : "Room cleared, find the key to the patient's heart",
				"dungeon_boss_defeated" : "Dungeon boss have been defeated, approach",
				"dungeon_boss_defeated2" : "Dungeon boss have been defeated, proceed",
				"wrath_sword_get" : "You've acquired WRATH SWORD",
				"void_get" : "You've acquired VOID",
				"darkcat_get" : "You've acquired NYCTOPHOBE",
				"darkness_get" : "You've acquired DARKNESS"
			},
			"indonesia": {
				"dialogue" : "Tekan SPACE untuk berinteraksi",
				"key_found" : "Kamu telah menemukan kunci ke hati pasien itu",
				"dungeon_wrath_enter" : "Dungeon Perasaan Amarah",
				"dungeon_lone_enter" : "Dungeon Perasaan Kesendirian",
				"dungeon_nycto_enter" : "Dungeon Perasaan Nyctophobe",
				"dungeon_depression_enter" : "Dungeon Perasaan Depresi",
				"dungeon_door" : "Terbuka",
				"dungeon_finished" : "Dungeon telah diselesaikan, kembali ke dunia asli",
				"dungeon_room_finished" : "Ruangan beres, carilah kunci ke hati pasien",
				"dungeon_boss_defeated" : "Dungeon boss telah dikalahkan, dekati",
				"dungeon_boss_defeated2" : "Dungeon boss telah dikalahkan, lanjut",
				"wrath_sword_get" : "Kamu mendapatkan WRATH SWORD",
				"void_get" : "Kamu mendapatkan VOID",
				"darkcat_get" : "Kamu mendapatkan NYCTOPHOBE",
				"darkness_get" : "Kamu mendapatkan DARKNESS"
			}
		}

onready var _master_node: Control = $control_tooltips

# Tooltips
onready var _animation_tooltips: AnimationPlayer = $tooltips_animation
onready var _container_tooltips: CenterContainer = $control_tooltips/centercontainer_tooltips
onready var _label_tooltips: Label = $control_tooltips/centercontainer_tooltips/label_tooltips

# Game over
onready var _colorrect_dark_overlay: ColorRect = $control_tooltips/colorrect_dark_overlay
onready var _container_dark_overlay: CenterContainer = $control_tooltips/centercontainer_dark_overlay
onready var _label_dark_overlay: Label = $control_tooltips/centercontainer_dark_overlay/label_dark_overlay

# Title screen
onready var _colorrect_title_screen: ColorRect = $control_tooltips/colorrect_title_screen
onready var _container_title_screen: CenterContainer = $control_tooltips/centercontainer_title
onready var _label_title: Label = $control_tooltips/centercontainer_title/vbox_title_container/label_chapter_title
onready var _label_subtitle: Label = $control_tooltips/centercontainer_title/vbox_title_container/label_chapter_subtitle

func _ready() -> void:
	_master_node.hide()
	_hide_all()


func show_tooltips(type: String, text: String, text2:String = "") -> void:
	_master_node.show()
	match type:
		"tooltips":
			_container_tooltips.show()
			_label_tooltips.text = text
			_animation_tooltips.play("tooltips_fade")
			yield(get_tree().create_timer(2), "timeout")
			_hide_tooltips()
		"dark_overlay":
			_container_dark_overlay.show()
			_label_dark_overlay.text = text
			_animation_tooltips.play("dark_overlay_fade")
			yield(get_tree().create_timer(2), "timeout")
			_hide_tooltips()
		"title":
			_colorrect_title_screen.show()
			_container_title_screen.show()
			_label_title.text = text
			_label_subtitle.text = text2
			yield(get_tree().create_timer(2), "timeout")
			_hide_tooltips()


func _hide_tooltips() -> void:
	_animation_tooltips.play_backwards("tooltips_fade")
	yield(_animation_tooltips, "animation_finished") # Wait
	_master_node.hide()
	_hide_all()


func _hide_all() -> void:
	_container_tooltips.hide()
	_container_title_screen.hide()
	_colorrect_title_screen.hide()
	_container_dark_overlay.hide()
	_colorrect_dark_overlay.hide()
