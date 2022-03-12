extends Area2D

onready var audio = $AudioStreamPlayer

var collected = false

func _ready():
	Global.init_coin()

func collect():
	if collected:
		return
	collected = true
	
	if Global.max_coins != 1:
		audio.pitch_scale = (float(Global.current_coins) / (Global.max_coins - 1)) + 1
	print(audio.pitch_scale)
	Global.collect_coin()
	audio.play(0)
	visible = false

func _on_Coin_body_entered(body):
	if body.has_method("is_player"):
		collect()

func _on_AudioStreamPlayer_finished():
	queue_free()
