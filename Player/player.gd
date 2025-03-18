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

func _ready():
	print("=== TILESET DEBUG ===")
	if tilemap.tile_set == null:
		print("❌ TileSet NON assegnato!")
	else:
		print("✅ TileSet trovato:", tilemap.tile_set)

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

# 🔹 Aggiunge oggetto all'inventario
func add_item_to_inventory(item: InvItem):
	inv.items.append(item)
	inv_ui.update_slots()
	print("✅ Raccolto:", item.name)
	print("👜 Oggetti in inventario:", inv.items.size())

# 🔹 Interazione per distruggere tile e droppare oggetto
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tilemap.local_to_map(mouse_pos)
		var tile_data = tilemap.get_cell_tile_data(0, tile_pos)

		print("=== DEBUG INTERACT ===")
		print("Mouse Posizione:", mouse_pos)
		print("TileMap Posizione:", tile_pos)
		print("Tile Presente:", tile_data != null)

		if tile_data != null:
			_start_tile_destruction_delay(tile_pos)
			print("💥 Avviato distruzione tile in:", tile_pos)



# Timer per ritardare distruzione tile
func _start_tile_destruction_delay(tile_pos):
	var timer = Timer.new()
	timer.wait_time = 1  # 1 secondo
	timer.one_shot = true
	timer.timeout.connect(Callable(self, "_on_tile_destruction_timeout").bind(tile_pos))
	add_child(timer)
	timer.start()

# Quando il timer scade, distrugge tile e droppa oggetto
func _on_tile_destruction_timeout(tile_pos):
	tilemap.erase_cell(0, tile_pos)
	print("💥 Tile distrutto in:", tile_pos)

	var world_pos = tilemap.map_to_local(tile_pos)
