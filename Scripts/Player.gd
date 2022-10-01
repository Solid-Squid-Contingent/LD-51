extends Area2D

onready var target = $Target
onready var moveTimer = $MoveTimer
onready var chargeProgressBar = $ChargeProgress
onready var moveRadiusSprite = $Radius

const riftScene = preload("res://Scenes/Rift.tscn")

const movementRange = 200

func _ready():
	moveRadiusSprite.modulate = Color.from_hsv(randf(), 1.0, 1.0, 0.5)
	self.get_tree().call_group('player', 'playerMoved')

func _input(event):
	if event.is_action_pressed('move') or (event is InputEventMouseMotion and Input.is_action_pressed('move')):
		moveTargetTo(event.position)

func _process(_delta):
	chargeProgressBar.value = 1 - moveTimer.time_left / moveTimer.wait_time

func moveTargetTo(targetPos):
	var dist = (targetPos - position).length()
	if dist < movementRange:
		for player in self.get_tree().get_nodes_in_group('player'):
			var d = (targetPos - player.position).length()
			if d < dist:
				return
		target.visible = true
		target.position = targetPos - position

func playerMoved():
	var index = 1
	for player in self.get_tree().get_nodes_in_group('player'):
		if player != self and not player.is_queued_for_deletion():
			moveRadiusSprite.material.set_shader_param("otherPlayerAlive" + String(index), true)
			moveRadiusSprite.material.set_shader_param("otherPlayerCenter" + String(index), to_local(player.global_position))
			index += 1
	for i in range(index, 2):
		moveRadiusSprite.material.set_shader_param("otherPlayerAlive" + String(i), false)

func spawnRift():
	var rift = riftScene.instance()
	rift.position = position
	get_parent().add_child(rift)

func _on_MoveTimer_timeout():
	if target.visible:
		spawnRift()
		position += target.position
		target.visible = false
		spawnRift()
		self.get_tree().call_group('player', 'playerMoved')


func _on_Player_area_entered(area):
	area.queue_free()
	queue_free()
	self.get_tree().call_group('player', 'playerMoved')
