extends Label

var completed = false

func _ready():
	update_text()

func _process(_delta):
	update_text()

func update_text():
	text = str(Global.current_coins) + " ] " + str(Global.max_coins)
	
	if Global.current_coins == Global.max_coins:
		if completed:
			return
		completed = true
		$CPUParticles2D.emitting = true
		$AudioStreamPlayer.play(0)
		#Global.text_box = "Congrulations"
