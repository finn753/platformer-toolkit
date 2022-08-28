extends Node

signal blocks_switched

var max_coins = 0
var current_coins = 0

var text_box = ""

var block_switch = true

func _unhandled_input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func init_coin():
	max_coins += 1

func collect_coin():
	current_coins += 1

func switch_blocks():
	block_switch = !block_switch
	emit_signal("blocks_switched")

func restart_game():
	max_coins = 0
	current_coins = 0
	block_switch = true
	text_box = ""
	
	var _error = get_tree().reload_current_scene()
