extends CharacterBody2D

@export var step_px := 32
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_dir := Vector2.DOWN

func _physics_process(_delta):
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
			last_dir = dir
			play_walk(dir)
		else:
			play_idle()

	

func play_walk(dir: Vector2) -> void:
	if dir == Vector2.LEFT:
		anim.play("Walk")
	elif dir == Vector2.RIGHT:
		anim.play("Walk")
	elif dir == Vector2.UP:
		anim.play("Walk")
	elif dir == Vector2.DOWN:
		anim.play("Walk")


func play_idle() -> void:
	if last_dir == Vector2.LEFT:
		anim.play("idle")
	elif last_dir == Vector2.RIGHT:
		anim.play("idle")
	elif last_dir == Vector2.UP:
		anim.play("idle")
	elif last_dir == Vector2.DOWN:
		anim.play("idle")
