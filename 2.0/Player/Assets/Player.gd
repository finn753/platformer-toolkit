extends KinematicBody2D

onready var rot_tween = $RotTween
onready var stween = $STween
onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer

export var speed = 200

export var jump_height = 64.0
export var jump_time_to_peak = 0.3
export var jump_time_to_descent = 0.35

export var can_climb = true
export var climb_speed = 150
export var can_double_jump = true
export(int, 1, 100) var jump_count = 2
export var can_glide = true
export var can_gravity = true

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var DEFAULT_GRAVITY = Vector2(0,1).rotated(deg2rad(0)) #TODO Make Const
var gravity_influence = {}
var gravity_normal = DEFAULT_GRAVITY
var gravity_zchanged = false
var wind_influence = {}

var movement_dir = 0
var climb_dir = 0
var inv_mov = 1
var velocity = Vector2()
var climb_origin

var jump = false
var jump_left = jump_count
var buffer_jump = false
var on_ground = false
var forced_jump = false

var boost_normal = Vector2()
var boost_strength = speed*4
var boost_duration = 0

enum STATES {Idle, Walk, Jump, Fall, Climb, Glide}
var state = STATES.Idle
var last_state = state

#func _ready():
#	check_abilities()

func _process(_delta):
	get_input()
	$Label.text = STATES.keys()[state]# + " -- " + str(rotation_degrees)

func _physics_process(delta):
	last_state = state
	state = get_state()
	calculate_sprite()
	var snap = 8
	climb_dir = 0
	
	#Speed Smoothing
	var n_speed = speed * movement_dir
	
	if is_on_floor():
		if abs(n_speed) > abs(velocity.x):
			velocity.x = (5*velocity.x + n_speed)/6
		else:
			if abs(velocity.x) > 5:
				velocity.x = (3*velocity.x + n_speed)/4
			else:
				velocity.x = 0
	elif state == STATES.Glide:
		velocity.x = (31*velocity.x + 0.5*n_speed)/31.5
	else:
		velocity.x = (7*velocity.x + n_speed)/8
	
	if is_on_floor() || (state == STATES.Climb):
		on_ground = true
		jump_left = jump_count
	else:
		if $Coyote.is_stopped() && on_ground == true:
			$Coyote.start()
		
		if last_state == STATES.Climb && state != STATES.Climb && velocity.y < 0:
			jump = true
	
	if jump  || (buffer_jump && (on_ground || (jump_left > 0 && can_double_jump))):
		jump = false
		buffer_jump = false
		on_ground = false
		jump_left -= 1
		snap = 0
		last_state = state
		state = STATES.Jump
		
		velocity.y = jump_velocity
		if audio.get_playback_position() == 0 || audio.get_playback_position() >= 0.1 || !audio.playing:
			audio.play()
	elif state == STATES.Glide:
		var w_vec = calculate_wind()
		
		velocity.y = w_vec.y
		
		if round(w_vec.x) != 0:
			velocity.x = w_vec.x + n_speed*0.5
		
		if velocity.y >= 0:
			velocity.y += get_gravity()
	elif state == STATES.Climb:
		jump_left = jump_count
		
		climb_dir = Input.get_vector("null","null","up","down").y * inv_mov
		
		var wall
		
		for i in range(get_slide_count()):
			var col = get_slide_collision(i)
			var b = col.collider
			
			var vec = col.position - position 
			var y_dist = abs(vec.y)
			
			if y_dist > 5:
				continue
			
			if b.has_method("get_vel"):
				wall = b
		
		var stick_vec = Vector2(0,0)
		
		if wall != null:
			if climb_origin == null || last_state != STATES.Climb:
				climb_origin = wall.position
			
			stick_vec = wall.position - climb_origin
			climb_origin = wall.position
		
		position += stick_vec
		
		var nc_speed = climb_speed * climb_dir
		velocity.y = nc_speed
		velocity.x = round(velocity.x)
		
		if climb_dir == 0:
			if velocity.y >= 0:
				velocity.y = 0
			else:
				velocity.y += get_gravity() * delta
	else:
		velocity.y += get_gravity() * delta
	
	var ca = [abs(jump_gravity), abs(fall_gravity)].max()
	velocity.y = clamp(velocity.y,jump_velocity,ca/3)
	
	if boost_duration > 0:
		boost_duration -= delta
		velocity = boost_normal * boost_strength
	
	#Move and Slide
	calculate_gravity_normal()
	var grav_rot = gravity_normal.angle_to(Vector2(0,1))
	
	velocity = move_and_slide_with_snap(velocity.rotated(-grav_rot),gravity_normal*snap,-gravity_normal,true,4,deg2rad(80)).rotated(grav_rot)
	#velocity = move_and_slide_with_snap(velocity,Vector2(0,snap),Vector2.UP)

func get_input(): 
	movement_dir = Input.get_vector("left","right","null","null").x
	
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right") :
		# -90 bis 90 normal
		if rotation_degrees > 92 || (rotation_degrees < -92 && rotation_degrees > -200):
			inv_mov = -1
		else:
			inv_mov = 1
	
	movement_dir *= inv_mov
	
	var try_jump = false
	
	if Input.is_action_just_pressed("jump") || (Input.is_action_just_pressed("up") && on_ground && is_on_wall()):
		try_jump = true
	elif Input.is_action_just_pressed("down") && gravity_normal.y < 0:
		try_jump = true
	
	if forced_jump:
		try_jump = false
	
	if try_jump && state != STATES.Climb:
		if on_ground:
			jump = true
		else:
			buffer_jump = true
			$BufferJump.start()

func calculate_gravity_normal():
	var n_g = Vector2(0,0)
	
	if gravity_influence.empty() || !can_gravity:
		n_g = DEFAULT_GRAVITY
	else:
	#	var mk = ""
	#	for k in gravity_influence.keys():
	#		if mk == "":
	#			mk = k
	#			continue
	#
	#		if gravity_influence[k][0] > gravity_influence[mk][0]:
	#			mk = k
		
		var sum = Vector2()
		var d = 0
		
		for k in gravity_influence.keys():
			sum += gravity_influence[k][1]
			d += 1
		
		n_g = (sum/d).normalized()
	#	var n_g = gravity_influence[mk][1]
	if n_g != gravity_normal:
		gravity_normal = (7*gravity_normal + n_g)/8
		gravity_zchanged = true

func calculate_wind() -> Vector2:
	var wind_vec = Vector2(0,0)
	
	for v in wind_influence:
		wind_vec += wind_influence[v]
	
	return wind_vec

func calculate_sprite():
	sprite.playing = true
	sprite.speed_scale = 1
	
	var n_rot = rad2deg(gravity_normal.angle()) - 90
	rotation_degrees = n_rot
	
	if movement_dir < 0:
		sprite.flip_h = true
	elif movement_dir > 0:
		sprite.flip_h = false
	
	if state == STATES.Idle:
		sprite.animation = "idle"
	elif state == STATES.Walk:
		sprite.animation = "walk"
		if movement_dir == 0:
			sprite.speed_scale = clamp((abs(velocity.x) / speed)*4,0,1)
	elif state == STATES.Climb:
		sprite.animation = "climb"
		if climb_dir == 0:
			sprite.playing = false
	elif state == STATES.Jump:
		sprite.scale = (sprite.scale + Vector2(1.18,0.85))/2
		
#		if last_state != STATES.Jump:
#			print("Jump")
#			stween.remove_all()
#			stween.interpolate_property(sprite,"scale",null,Vector2(1.25,0.8),0.3,Tween.TRANS_SINE,Tween.EASE_OUT)
#			stween.start()
		sprite.animation = "jump"
	elif state == STATES.Fall:
		if !last_state == STATES.Climb && !is_on_ceiling():
			if last_state != STATES.Fall:
				stween.remove_all()
				stween.interpolate_property(sprite,"scale",null,Vector2(0.85,1.18),0.35,Tween.TRANS_SINE,Tween.EASE_OUT)
				stween.start()
			sprite.animation = "fall"
	elif state == STATES.Glide:
		sprite.animation = "walk"
	
	if state != STATES.Jump && state != STATES.Fall && sprite.scale != Vector2(1,1):
		if last_state == STATES.Jump || last_state == STATES.Fall:
			stween.remove_all()
		
		if !stween.is_active():
			stween.remove_all()
			stween.interpolate_property(sprite,"scale",null,Vector2(1,1),0.2,Tween.TRANS_BACK,Tween.EASE_OUT)
			stween.start()


func get_state():
	var n_state = STATES.Idle
	
	if is_on_floor() && velocity.x != 0:
		n_state = STATES.Walk
	elif !is_on_floor() && velocity.y < 0 && state != STATES.Climb:
		n_state = STATES.Jump
	elif (!is_on_floor() && velocity.y > 0) || state == STATES.Climb:
		n_state = STATES.Fall
	
	if last_state == STATES.Glide && Input.is_action_pressed("jump") && !Input.is_action_just_pressed("jump") && !wind_influence.empty() && can_glide:
		n_state = STATES.Glide
	
	if n_state == STATES.Fall:
		if is_on_wall() && state != STATES.Glide && can_climb:
			n_state = STATES.Climb
		elif Input.is_action_pressed("jump") && !Input.is_action_just_pressed("jump") && state != STATES.Climb && can_glide:
			n_state = STATES.Glide
	
	return n_state

func get_gravity():
	if state == STATES.Jump:
		if !Input.is_action_pressed("jump"):
			return jump_gravity*1.5
		return jump_gravity
	
	if state == STATES.Glide:
		return fall_gravity / 20
	
	return fall_gravity

func force_jump():
	jump_left = jump_count
	jump = true
	
	if !forced_jump:
		forced_jump = true
		$ForceJump.start()
		return true
	return false

func boost():
	boost_normal.x = sign(round(velocity.x))
	boost_normal.y = sign(round(velocity.y))
	boost_normal = boost_normal.normalized()
	
	if round(boost_normal.x) == 0 && round(boost_normal.y) == 0:
		return false
	
	if boost_normal.y > 0:
		boost_normal.y /= -4
	else:
		boost_normal.y /=2
	
	boost_duration = 0.1
	return true

func check_abilities():
	can_climb = Global.has_ability("climb")
	can_double_jump = Global.has_ability("double_jump")
	can_glide = Global.has_ability("glide")
	can_gravity = Global.has_ability("gravity")

func _on_Coyote_timeout():
	on_ground = is_on_floor()
	if !on_ground && jump_left == jump_count:
		jump_left = jump_count - 1

func _on_BufferJump_timeout():
	buffer_jump = false

func _on_ForceJump_timeout():
	forced_jump = false

func death():
	Global.restart_game()

func teleport(to: Vector2):
	set_position(to)

func is_player():
	return true
