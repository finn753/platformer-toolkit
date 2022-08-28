extends Area2D

onready var cooldown = $Cooldown
onready var audio = $AudioStreamPlayer

var active = true

func _process(_delta):
	visible = active

func _on_BoostGem_body_entered(body):
	if !active:
		if cooldown.is_stopped():
			cooldown.start()
		return
	
	if body.has_method("boost"):
		cooldown.start()
		active = !body.boost()
		audio.play()

func _on_Cooldown_timeout():
	active = true
