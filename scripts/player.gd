extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@export var jump_buffer_dur := 0.1
@export var coyote_dur := 0.15
var is_dead := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var jumb_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_dead:
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		var coyote_jump := not coyote_timer.is_stopped()
		if is_on_floor() or coyote_jump:
			if coyote_jump:
				print("coyote")
			jump()
		else:
			jumb_buffer_timer.start(jump_buffer_dur)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")

	# Flip the sprite.
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations.
	if is_on_floor():
		var jump_buffered := not jumb_buffer_timer.is_stopped()
		if jump_buffered:
			jump()
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var was_on_floor := is_on_floor()
	move_and_slide()
	if was_on_floor and !is_on_floor():
		coyote_timer.start(coyote_dur)


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	animated_sprite.play("jump")
	jumb_buffer_timer.stop()
	coyote_timer.stop()


func on_killzone() -> void:
	is_dead = true
	death_audio.play()
	animated_sprite.play("death")
