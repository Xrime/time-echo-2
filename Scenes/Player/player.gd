extends CharacterBody2D

@export var step_px := 32       
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var last_dir := Vector2.DOWN

func _physics_process(_delta):
	if Global.step <= 0:
		
		return

	var dir := Vector2.ZERO

	if Input.is_action_just_pressed("ui_left"):
		dir = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		dir = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_up"):
		dir = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		dir = Vector2.DOWN


	if dir != Vector2.ZERO:
		var collision = move_and_collide(dir * step_px)
		if collision == null:
			Global.step -= 1        
			last_dir = dir
			

func play_walk(dir: Vector2):
	if dir == Vector2.LEFT:
		anim.play("walk_left")
	elif dir == Vector2.RIGHT:
		anim.play("walk_right")
	elif dir == Vector2.UP:
		anim.play("walk_up")
	elif dir == Vector2.DOWN:
		anim.play("walk_down")

func play_idle():
	if last_dir == Vector2.LEFT:
		anim.play("idle_left")
	elif last_dir == Vector2.RIGHT:
		anim.play("idle_right")
	elif last_dir == Vector2.UP:
		anim.play("idle_up")
	elif last_dir == Vector2.DOWN:
		anim.play("idle_down")
