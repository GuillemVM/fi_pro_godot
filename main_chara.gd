extends KinematicBody2D

var grounded

const velocitat = 100;
var moviment = Vector2();
const jump = -200;
const up = Vector2(0, -1)
const gravity = 10

var max_hp = 100
var hp = 100 
var attacking = false
var death = false
var direction = 1

onready var _animate_player = $pers
onready var sprite = $pers

func _ready():
	$sword_attack/sword_left.disabled = true
	$sword_attack/sword_right.disabled = true

func _physics_process(delta):
	if death == false:
		hp += 1 * delta
		hp = clamp(hp, 0, max_hp)
		if is_on_floor():
			grounded = true
		else:
			grounded = false
		moviment.y += gravity
		if Input.is_action_pressed("ui_right") && attacking == false:
			moviment.x = velocitat
		elif Input.is_action_pressed("ui_left") && attacking == false:
			moviment.x = -velocitat
		else:
				moviment.x = 0
				if grounded == true && attacking == false:
					_animate_player.play("idle")
		if  moviment.x < 0:
			direction = -1
			if grounded == true:
				sprite.flip_h = true
				_animate_player.play("run")
		elif moviment.x > 0:
			direction = 1
			$main_hitbox/hitbox_left.disabled = false
			$main_hitbox/hitbox_right.disabled = true
			if grounded == true:
				sprite.flip_h = false
				_animate_player.play("run");
		else:
			false
		if direction == -1:
			$main_hitbox/hitbox_left.disabled = false
			$main_hitbox/hitbox_right.disabled = true
		elif direction == 1:
			$main_hitbox/hitbox_left.disabled = true
			$main_hitbox/hitbox_right.disabled = false
		if grounded == true && Input.is_action_pressed("ui_up") && attacking == false:
			moviment.y = jump
		elif grounded == false && moviment.y < 0:
			_animate_player.play("jump")
		if Input.is_action_just_pressed("ui_basic_attack"):
			attacking = true
			_animate_player.play("attack")
			if direction == -1:
				$sword_attack/sword_left.disabled = false
				$sword_attack/sword_right.disabled = true
			elif direction == 1:
				$sword_attack/sword_left.disabled = true
				$sword_attack/sword_right.disabled = false
		moviment = move_and_slide(moviment, up)
	elif death == true:
		_animate_player.play("death")

func hp():
	if hp <= 0:
		death = true
		
func _on_pers_animation_finished():
	if $pers.animation == "attack":
		if direction == -1:
			$sword_attack/sword_left.disabled = true
		elif direction == 1:
			$sword_attack/sword_right.disabled = true
		attacking = false
	if $pers.animation == "death":
		queue_free()
func _on_main_hitbox_area_entered(area):
	if area.is_in_group("lanza"):
		hp = hp - 20
	
