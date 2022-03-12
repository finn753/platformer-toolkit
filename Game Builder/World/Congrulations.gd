extends Label

func _ready():
	visible = false

func _process(delta):
	if Global.current_coins == Global.max_coins:
		visible = true
