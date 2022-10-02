extends Area2D

signal stopGraze
signal died

onready var target = $Target
onready var moveTimer = $MoveTimer
onready var chargeProgressBar = $ChargeProgress
onready var moveRadiusSprite = $Radius

export var halfSprite1: Texture
export var halfSprite2: Texture

const riftScene = preload("res://Scenes/Rift.tscn")
const grazeScene = preload("res://Scenes/GrazeParticles.tscn")

const movementRange = 200

func _ready():
	moveRadiusSprite.material.set_shader_param("movementRange", movementRange)
	moveRadiusSprite.material.set_shader_param("instanceRandom", Color(randf(), randf(), randf(), randf()))
	self.get_tree().call_group('player', 'playerMoved')

func _input(event):
	if event.is_action_pressed('move') or (event is InputEventMouseMotion and Input.is_action_pressed('move')):
		moveTargetTo(event.position)

func _process(_delta):
	chargeProgressBar.value = 1 - moveTimer.time_left / moveTimer.wait_time

func moveTargetTo(targetPos):
	var dist = (targetPos - moveRadiusSprite.global_position).length()
	if dist < movementRange:
		for player in self.get_tree().get_nodes_in_group('player'):
			var d = (targetPos - player.moveRadiusSprite.global_position).length()
			if player != self && d < dist + 70:
				return
		target.visible = true
		target.position = to_local(targetPos)

func playerMoved():
	var index = 1
	for player in self.get_tree().get_nodes_in_group('player'):
		if player != self and not player.is_queued_for_deletion():
			moveRadiusSprite.material.set_shader_param("otherPlayerAlive" + String(index), true)
			var playerPos = moveRadiusSprite.to_local(player.moveRadiusSprite.global_position)
			moveRadiusSprite.material.set_shader_param("otherPlayerCenter" + String(index), playerPos)
			index += 1
	for i in range(index, 3):
		moveRadiusSprite.material.set_shader_param("otherPlayerAlive" + String(i), false)

func spawnRift():
	var rift = riftScene.instance()
	rift.position = position
	get_parent().add_child(rift)

func updateRadii():
	self.get_tree().call_group('player', 'playerMoved')

func move():
	if target.visible:
		spawnRift()
		position += target.position
		target.visible = false
		spawnRift()
		updateRadii()

func _on_MoveTimer_timeout():
	move()


func _on_Player_area_entered(area):
	if not is_queued_for_deletion():
		area.queue_free()
		queue_free()
		emit_signal("died", self)
		updateRadii()
		Base.spawnDeathParticles(self)
		Base.spawnHalfSprites(self, halfSprite1, halfSprite2)


func _on_GrazeArea_area_entered(area):
	var graze = grazeScene.instance()
	area.add_child(graze)
	# warning-ignore:return_value_discarded
	connect('stopGraze', graze, 'stopGraze')


func _on_GrazeArea_area_exited(area):
	emit_signal('stopGraze', area)
