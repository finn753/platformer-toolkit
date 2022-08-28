extends Area2D

export var strength = 64

onready var name_id = str(get_instance_id()) +  str(strength)

onready var particle = $Particles2D

const SPEED = 1.5
const SCALE = 0.1

func _ready():
	adjust_particle()

func adjust_particle():
	particle.scale = (Vector2(1,1) / scale) * Vector2(SCALE,1)
	particle.emission_rect_extents.x = 8 * scale.x * (1/SCALE)
	particle.scale_amount = 1/SCALE
	particle.initial_velocity = strength * SPEED
	particle.lifetime = (16*scale.y)/strength/SPEED
	particle.amount = ceil(scale.x * scale.y * SCALE) + 8

func get_wind_vector():
	return Vector2(0,-strength).rotated(rotation)

func _on_Wind_body_entered(body):
	if body.has_method("calculate_wind"):
		body.wind_influence[name_id] = get_wind_vector()

func _on_Wind_body_exited(body):
	if body.has_method("calculate_wind"):
		body.wind_influence.erase(name_id)
