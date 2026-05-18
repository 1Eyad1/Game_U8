extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D

var is_dead = false


func _physics_process(delta: float) -> void:

	if is_dead:
		return

	# Death check (ONLY ONCE)
	if Game.player_health <= 0:
		death()
		return

	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	# Flip
	if direction != 0:
		anim.flip_h = direction < 0

	# Animation logic (IMPORTANT: only ONE place)
	if is_dead:
		pass
	elif not is_on_floor():
		anim.play("Jump")
	elif direction == 0:
		anim.play("Idle")
	else:
		anim.play("Run")

	move_and_slide()


func death():

	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO

	anim.play("Death")

	set_physics_process(false)

	await anim.animation_finished

	queue_free()
