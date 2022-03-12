extends StaticBody2D

var add = null

func _on_Area2D_body_entered(body):
	if body.has_method("jump"):
		body.jump(true)
		add = body

func _physics_process(delta):
	if add != null:
		add.extra_jumps_left = add.extra_jump_count + 1
		add = null
