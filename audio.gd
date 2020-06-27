extends Node

var _current_sfx: String = ""


func play(sfx = null):
	if sfx and sfx != _current_sfx:
		get_node(sfx).play()
		if _current_sfx != "":
			get_node(_current_sfx).stop()
		_current_sfx = sfx


func stop():
	if _current_sfx != "":
		get_node(_current_sfx).stop()
