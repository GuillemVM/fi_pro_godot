extends KinematicBody2D

const gravity = 10
const speed = 50 
const _floor = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var dead = false
var hp = 100
var dmg_taken = 30
var attack = false

onready var _animated_player = $skel1
onready var sprite = $skel1
onready var timer = Timer

func _ready():
	pass

func _physics_process(delta):
	if dead == false && attack == false:
		scale.x = 1
		$area_final/CollisionShape2D.disabled = true
		velocity.x = speed * direction
		velocity.y += gravity
		velocity = move_and_slide(velocity, _floor)
		actual_hp()
		if direction == 1:
			scale.x = 1
			_animated_player.play("walk")
			sprite.flip_h = false
		else:
			scale.x = -1
			_animated_player.play("walk")
			sprite.flip_h = true
		if is_on_wall():
			direction = direction * -1
		if $RayCast2D.is_colliding() == true:
			direction = direction * -1
	elif dead == true:
		_animated_player.play("dead")

func actual_hp():
	if hp <= 0:
		dead = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("sword"):
		hp = hp - dmg_taken

func _on_skel1_animation_finished():
	if _animated_player.animation == "dead":
		queue_free()
	if _animated_player.animation == "attack 1":
		attack = false
		$attack_final/CollisionShape2D.disabled = true

func _on_attack_area_entered(area):
	attack = true
	_animated_player.play("attack 1")
	$attack_final/CollisionShape2D.disabled = false

