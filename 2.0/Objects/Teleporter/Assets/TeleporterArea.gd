extends Area2D

export var require_jump = true
export(NodePath) var destination

var buffer = 0
var inside = null

func _ready():
	$JumpPrompt.visible = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("jump") && inside != null:
		teleport_body(inside)
		inside = null
		$JumpPrompt.visible = false

func _on_TeleporterArea_body_entered(body):
	if buffer > 0:
		buffer -= 1
		return
	
	if destination == null:
		printerr("Error: No destination selected")
		return
	
	if body.has_method("teleport"):
		if require_jump:
			inside = body
			$JumpPrompt.visible = true
			return
		
		teleport_body(body)

func teleport_body(body):
	var d_node = get_node(destination)
	if d_node.has_method("_on_TeleporterArea_body_entered"):
		d_node.buffer += 1
	body.teleport(d_node.position)

func _on_TeleporterArea_body_exited(body):
	if body == inside:
		inside = null
		$JumpPrompt.visible = false
