extends Area2D

var death_body

func _on_DeathTrigger_body_entered(body):
	if body.has_method("death"):
		death_body = body
		$AudioStreamPlayer.play(0)

func _on_AudioStreamPlayer_finished():
	death_body.death()
