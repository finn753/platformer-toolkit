extends Node2D

onready var sprite = $Sprite
onready var tween = $Tween

func _on_BounceArea_on_body_bounced():
	tween.remove_all()
	tween.interpolate_property(sprite,"scale",Vector2(1,0.5),Vector2(1,1),1.0,Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	tween.start()
