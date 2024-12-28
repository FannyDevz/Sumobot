extends CharacterBody2D

@export var speed: float = 200.0
@export var push_force: float = 390.0  # Daya dorong untuk power push
@export var push_duration: float = 0.3  # Durasi power push dalam detik

var is_pushing: bool = false
var push_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# Periksa apakah robot sedang melakukan power push
	if is_pushing:
		push_timer -= delta
		if push_timer <= 0.0:
			is_pushing = false  # Berhenti mendorong
		return  # Jangan izinkan kontrol lain selama power push

	# Kontrol gerakan normal
	var input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		push_force = 450
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		push_force = 450
		input_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		push_force = 450
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		push_force = 450
		input_direction.x += 1
	else:
		push_force = 390
	
	if Input.is_action_pressed("ui_accept"):
		push_force = 500

	# Gerakan berdasarkan input
	input_direction = input_direction.normalized()
	velocity = input_direction * speed
	move_and_slide()

func _process(delta: float) -> void:
	# Power Push: Menekan tombol "Space" untuk mendorong
	if Input.is_action_just_pressed("ui_accept") and not is_pushing:
		is_pushing = true
		push_timer = push_duration
		velocity = global_transform.x * push_force  # Dorong ke arah depan
