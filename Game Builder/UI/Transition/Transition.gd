extends ColorRect

export var start_closed = false

onready var tween = $Tween

var queue
var queue_param = 1.0

func _ready():
	get_tree().get_root().connect("size_changed", self, "update_size")
	update_size()
	if start_closed:
		material.set_shader_param("circle_size",0)
	else:
		material.set_shader_param("circle_size",1.05)
	
	visible = true

func open(duration = 1.0, delay = 0.0):
	if delay != 0.0:
		queue = "open"
		queue_param = duration
		$Timer.start(delay)
		return
	
	tween.remove_all()
	tween.interpolate_property(material,"shader_param/circle_size",null,1.05,duration,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	tween.start()

func close(duration = 1.0, delay = 0.0):
	if delay != 0.0:
		queue = "close"
		queue_param = duration
		$Timer.start(delay)
		return
	
	tween.remove_all()
	tween.interpolate_property(material,"shader_param/circle_size",null,0.0,duration,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	tween.start()

func update_size():
	var window_size = get_viewport_rect().size
	
	material.set_shader_param("screen_width",window_size.x)
	material.set_shader_param("screen_height",window_size.y)

func _on_Timer_timeout():
	if queue == "open":
		open(queue_param)
	elif queue == "close":
		close(queue_param)
