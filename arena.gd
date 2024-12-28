extends Node2D

@export var arena_radius: float = 320.0

@onready var robot_1: CharacterBody2D = $Robots/Robot1
@onready var robot_2: CharacterBody2D = $Robots/Robot2

var battle = false
func _ready() -> void:
	_draw()
	_draw_gizmo()
	reset_positions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_out_arena(robot_1.position):
		print("Robot 2 Wins.")
		reset_positions()
	elif is_out_arena(robot_2.position): 
		print("Robot 1 Wins.")
		reset_positions()
		
	var distance = robot_1.global_position.distance_to(robot_2.global_position)
	
	if distance < 123:  # Jarak minimal untuk interaksi
		battle = true
		resolve_push()

func resolve_push() -> void:
	# Hitung arah dan jarak relatif
	var direction_to_robot2 = (robot_2.position - robot_1.position).normalized()
	var distance = robot_1.global_position.distance_to(robot_2.global_position)

	# Ambil kekuatan dorongan masing-masing robot
	var robot_1_push = robot_1.push_force
	var robot_2_push = robot_2.push_force

	# Tentukan siapa yang menang
	if robot_1_push > robot_2_push:
		print("Robot 1 wins the push!")
		robot_2.position += direction_to_robot2 * (robot_1_push - robot_2_push) * 0.1
	elif robot_2_push > robot_1_push:
		print("Robot 2 wins the push!")
		robot_1.position -= direction_to_robot2 * (robot_2_push - robot_1_push) * 0.1
	else:
		print("It's a tie! Both robots are equally strong.")
		
func reset_positions():
	robot_1.position = Vector2(-200, 0)
	robot_2.position = Vector2(200, 0)
	battle = false

func is_out_arena(position: Vector2) -> bool:
	return position.length() > arena_radius 

func _draw() -> void: 
	draw_circle(Vector2.ZERO, arena_radius, Color.TURQUOISE)

func _draw_gizmo() -> void: 
	draw_circle(Vector2.ZERO, arena_radius, Color.TURQUOISE)
