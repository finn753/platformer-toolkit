extends Area2D

var prio = 0
export var def_gravity_normal = Vector2(0,1)
var static_grav = false
export var parent_rotation = true

onready var name_id = str(prio) +  str(gravity_normal)
onready var gravity_normal = def_gravity_normal.rotated(rotation)

func _process(_delta):
	if !static_grav:
		gravity_normal = def_gravity_normal.rotated(rotation)
		
		if parent_rotation:
			gravity_normal = gravity_normal.rotated(get_parent().rotation)
		
		for body in get_overlapping_bodies():
			if body.has_method("calculate_gravity_normal"):
				body.gravity_influence[name_id] = [prio,gravity_normal]

func _on_GravityArea_body_entered(body):
	if body.has_method("calculate_gravity_normal"):
		body.gravity_influence[name_id] = [prio,gravity_normal]

func _on_GravityArea_body_exited(body):
	if body.has_method("calculate_gravity_normal"):
		body.gravity_influence.erase(name_id)
