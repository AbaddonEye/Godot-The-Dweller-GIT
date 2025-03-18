extends CharacterBody2D

@onready var animated_sprite_2d = $SpritePivot/AnimatedSprite2D
@onready var sprite_pivot = $SpritePivot
@onready var tilemap = get_node("/root/Livello 1/TileMapLayer/TileMap")
@onready var inv_ui = $Inv_UI  # UI inventario (modifica se si trova altrove)

const GRAVITY = 1000
const SPEED = 100
const JUMP_VELOCITY = -300

enum State { Idle, Run }
var current_state = State.Idle

@export var inv: Inv  # Risorsa inventario collegata


func _physics_process(delta):
	player_falling(delta)
	player_movement()
	move_and_slide()
	update_animation()

func player_falling(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func player_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		current_state = State.Run
		sprite_pivot.scale.x = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		current_state = State.Idle

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func update_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")

#
