extends CharacterBody2D

@export var detection_range: float = 250.0  # Jarak deteksi untuk mendekati
@export var push_range: float = 50.0  # Jarak minimal untuk mendorong
@export var retreat_range: float = 30.0  # Jarak untuk mundur
@export var speed: float = 100.0  # Kecepatan gerakan
@export var push_force: float = 400.0  # Kekuatan dorongan
@export var push_duration: float = 0.3  # Durasi dorongan
@export var aggression_level: float = 1.0  # Tingkat agresi

@onready var robot_body: CharacterBody2D = $"."  # Referensi ke Robot2
@onready var opponent: CharacterBody2D = $"../Robot1"  # Referensi ke Robot1

var is_pushing: bool = false  # Apakah sedang mendorong
var push_timer: float = 0.0  # Timer untuk dorongan

func _ready() -> void:
	print(robot_body)

func _physics_process(delta: float) -> void:
	if robot_body == null or opponent == null:
		return

	# Hitung arah dan jarak ke lawan
	var direction_to_opponent: Vector2 = (opponent.global_position - robot_body.global_position).normalized()
	var distance_to_opponent: float = robot_body.global_position.distance_to(opponent.global_position)

	# Logika dorongan
	if is_pushing:
		push_timer -= delta
		if push_timer <= 0.0:
			is_pushing = false  # Berhenti mendorong
		return  # Jangan izinkan gerakan lain selama mendorong

	# Logika mundur jika terlalu dekat
	if distance_to_opponent < retreat_range:
		robot_body.velocity = -direction_to_opponent * speed * aggression_level
	# Logika mendorong jika berada dalam jarak dorong
	elif distance_to_opponent < push_range:
		is_pushing = true
		push_timer = push_duration
		robot_body.velocity = direction_to_opponent * push_force * aggression_level
	# Logika mendekat jika dalam jarak deteksi
	elif distance_to_opponent < detection_range:
		robot_body.velocity = direction_to_opponent * speed * aggression_level
	# Jika di luar jangkauan, diam
	else:
		robot_body.velocity = Vector2.ZERO

	# Gerakkan robot
	move_and_slide()
