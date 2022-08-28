extends Label

func _ready():
	visible = true
	rect_pivot_offset = rect_size / 2
	rect_scale = Vector2(0,0)

func _process(_delta):
	if text != Global.text_box:
		$Tween.remove_all()
		if Global.text_box == "":
			$Tween.interpolate_property(self,"rect_scale",null,Vector2(0,0),0.4,Tween.TRANS_SINE,Tween.EASE_OUT)
			$Off.play(0)
		else:
			$Tween.interpolate_property(self,"rect_scale",null,Vector2(1,1),0.4,Tween.TRANS_BACK,Tween.EASE_OUT)
			$On.play(0)
		text = Global.text_box
		$Tween.start()
