# Parts of the character controller are from
# Pefeper
# https://www.youtube.com/watch?v=IOe1aGY6hXA

extends KinematicBody2D

export var move_speed = 125

var velocity := Vector2.ZERO

export var jump_height = 50.0
export var jump_time_to_peak = 0.35
export var jump_time_to_descent = 0.3
export var extra_jump_count = 1

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

onready var sprite = $Sprite

var snap_normal = Vector2.DOWN

var buffer_jump = false
var on_ground = false
var extra_jumps_left = extra_jump_count

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if is_on_floor():
		on_ground = true
		extra_jumps_left = extra_jump_count
	else:
		if $Coyote.is_stopped() && on_ground == true:
			$Coyote.start()
	
	if on_ground:
		if Input.is_action_just_pressed("jump") || buffer_jump:
			buffer_jump = false
			jump()
	else:
		if Input.is_action_just_pressed("jump"):
			if extra_jumps_left >= 1:
				buffer_jump = false
				jump()
			else:
				buffer_jump = true
				$BufferJump.start()
	
	var snap_modify = 0
	if velocity.y >= 0:
		snap_modify = 8
	
	velocity = move_and_slide_with_snap(velocity, snap_normal * snap_modify, Vector2.UP, true)

func get_gravity() -> float:
	if Input.is_action_pressed("down"):
		return fall_gravity * 2
	
	if velocity.y < 0.0:
		var modifier = 0
		
		if Input.is_action_pressed("jump"):
			modifier = -velocity.y
		
		return jump_gravity - modifier
	else:
		return fall_gravity

func jump(free = false):
	$AudioStreamPlayer.play(0)
	velocity.y = jump_velocity
	
	if !free && !on_ground:
		extra_jumps_left -= 1
	
	on_ground = false
	
	if extra_jumps_left < 0:
		extra_jumps_left = 0

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	if horizontal < 0:
		sprite.flip_h = true
	elif horizontal > 0:
		sprite.flip_h = false
	
	return horizontal

func _on_Buffer_Jump_timeout():
	buffer_jump = false

func _on_Coyote_timeout():
	on_ground = is_on_floor()

func death():
	Global.restart_game()

func teleport(to: Vector2):
	set_position(to)

func is_player():
	return true
