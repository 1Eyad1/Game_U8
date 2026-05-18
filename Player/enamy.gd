extends CharacterBody2D

var speed = 100
var gravity = 100

var player
var movement = false
var is_dead = false


func _ready():
	$AnimatedSprite2D.play("idle")
	player = get_node("../../Player")


func _physics_process(delta):

	#if is_dead:
		#return

	velocity.y += gravity * delta

	# safety check
	#if player == null:
		#return

	if movement == true:

		if $AnimatedSprite2D.animation != "death":
			$AnimatedSprite2D.play("run")

		# IMPORTANT FIX: avoid head stacking
		var direction = player.position - self.position
		direction.y = 0

		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
			velocity.x = speed

		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = false
			velocity.x = -speed

	else:

		if $AnimatedSprite2D.animation != "death":
			$AnimatedSprite2D.play("idle")

		velocity.x = 0

	move_and_slide()


# ----------------------------
# DETECTION
# ----------------------------

func _on_player_detection_body_entered(body: Node2D) -> void:

	if body.name == "Player":
		movement = true


func _on_player_detection_body_exited(body: Node2D) -> void:

	if body.name == "Player":
		movement = false


# ----------------------------
# DAMAGE PLAYER
# ----------------------------

func _on_player_hurt_body_entered(body):

	if body.name == "Player":

		Game.player_health -= 1
	
		# GAME OVER CHECK MUST BE FIRST
		#if Game.player_health <= 0:
			#get_tree().quit()
			#return
#
		get_tree().reload_current_scene()

# ----------------------------
# ENEMY DEATH TRIGGER
# ----------------------------

func _on_enemy_death_body_entered(body: Node2D) -> void:

	if body.name == "Player":
		death()


# ----------------------------
# DEATH FUNCTION
# ----------------------------

func death():

	#if is_dead:
		#return
#
	#is_dead = true
	movement = false
	velocity.x = 0
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
