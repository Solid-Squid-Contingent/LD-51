extends Area2D

signal stopGraze
signal hit
signal died

onready var target = $Target
onready var moveTimer = $MoveTimer
onready var chargeProgressBar = $ChargeProgress
onready var moveRadiusSprite = $Radius
onready var sprite = $CollisionShape/Sprite
onready var collisionShape = $CollisionShape
onready var hearts3 = [$Heart1, $Heart2, $Heart3]
onready var hearts1 = [$Heart2]
var hearts = []
onready var orb = $CollisionShape/Orb

export var spriteName: String
export var spriteScale: float
export var halfSpriteDirection: Vector2
export var maxLives: int

onready var lives = maxLives

const riftScene = preload("res://Scenes/Rift.tscn")
const grazeScene = preload("res://Scenes/GrazeParticles.tscn")
const localClearScene = preload("res://Scenes/LocalClear.tscn")

const movementRange = 200

var gameOver = false

const spriteOffsets = {
	"Default" : Vector2(-2, -20),
	"UFO" : Vector2(-4, -10),
	"Spider" : Vector2(0, -20)
}

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

func _ready():
	moveRadiusSprite.material.set_shader_param("movementRange", movementRange)
	moveRadiusSprite.material.set_shader_param("instanceRandom", Color(randf(), randf(), randf(), randf()))
	sprite.frames = load("res://Resources/Graphics/Ships/" + spriteName + "/anim.tres")
	sprite.scale = Vector2(spriteScale, spriteScale)
	target.texture = load("res://Resources/Graphics/Ships/" + spriteName + "/outline.png")
	target.scale = Vector2(spriteScale, spriteScale)
	sprite.position = spriteOffsets[spriteName]
	if maxLives == 1:
		hearts = hearts1
	else:
		hearts = hearts3
	upTween()
	showHearts()
	updateRadii()
	updateRadii()

func upTween():
	$UpTween.interpolate_property(collisionShape, "position",
		Vector2(0,3), Vector2(0,-3),
		rand_range(1, 2), TRANS, EASE)
	$UpTween.start()
	
func downTween():
	$DownTween.interpolate_property(collisionShape, "position",
		Vector2(0,-3), Vector2(0,3),
		rand_range(1, 2), TRANS, EASE)
	$DownTween.start()

func _input(event):
	if gameOver:
		return
	
	if event.is_action_pressed('move') and !gameOver:
		moveTargetTo(event.position, true)
	elif (event is InputEventMouseMotion and Input.is_action_pressed('move')) and !gameOver:
		moveTargetTo(event.position)
	elif event.is_action_pressed('show_hitbox'):
		orb.visible = true
	elif event.is_action_released('show_hitbox'):
		orb.visible = false

func _process(_delta):
	chargeProgressBar.value = 1 - moveTimer.time_left / moveTimer.wait_time

func moveTargetTo(targetPos, sound = false):
	var dist = (targetPos - moveRadiusSprite.global_position).length()
	if dist < movementRange:
		for player in self.get_tree().get_nodes_in_group('player'):
			var d = (targetPos - player.moveRadiusSprite.global_position).length()
			if player != self && d < dist + 50:
				return
		target.visible = true
		target.position = to_local(targetPos) + spriteOffsets[spriteName]
		if sound:
			$LockInPlayer.play()

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
		$TeleportPlayer.play()
		position += target.position - spriteOffsets[spriteName]
		target.visible = false
		spawnRift()
		updateRadii()

func showHearts():
	for i in range(maxLives):
		hearts[i].show()

func _on_MoveTimer_timeout():
	move()

func spawnLocalClear():
	var clear = localClearScene.instance()
	clear.position = position
	get_parent().call_deferred("add_child", clear)
	
	
func loseLife():
	if gameOver:
		return
		
	lives -= 1
	showHearts()
	hearts[lives].disappear(lives > 0)
	
	if lives > 0:
		emit_signal("hit", self)
		spawnLocalClear()
		$IFrameTimer.start()
		$HitPlayer.play()
	else:
		sprite.visible = false
		chargeProgressBar.visible = false
		target.visible = false
		moveRadiusSprite.visible = false
		Base.spawnHalfSprites(self, spriteName, halfSpriteDirection, spriteScale)
		emit_signal("died", self)
		remove_from_group('player')
		updateRadii()
		$DeathPlayer.play()
	
	Base.spawnDeathParticles(self)
	
# Hit enemy
func impact():
	for _i in range(lives):
		loseLife()
	return true

func _on_Player_area_entered(area):
	if gameOver or area.is_queued_for_deletion() or not $IFrameTimer.is_stopped():
		return
		
	loseLife()
	area.impact()


func _on_GrazeArea_area_entered(area):
	var graze = grazeScene.instance()
	area.add_child(graze)
	# warning-ignore:return_value_discarded
	connect('stopGraze', graze, 'stopGraze')


func _on_GrazeArea_area_exited(area):
	emit_signal('stopGraze', area)


func _on_UpTween_tween_all_completed():
	downTween()


func _on_DownTween_tween_all_completed():
	upTween()
