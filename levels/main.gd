extends Node2D  # Nodo principale è un Node2D

var show_collision_shapes := false  # Variabile per attivare/disattivare la visualizzazione delle collisioni

func _ready():
	# Inizializza e forza il ridisegno della scena
	pass  # Non c'è bisogno di fare nulla all'inizio

# Gestisce l'input per attivare/disattivare la visualizzazione delle collisioni
func _input(event):
	if event.is_action_pressed("toggle_collision_debug"):  # Se premi il tasto per il debug
		show_collision_shapes = !show_collision_shapes  # Alterna il valore

# Disegna le collisioni se show_collision_shapes è vero
func _draw():
	if show_collision_shapes:
		# Cicla attraverso i figli del nodo principale e disegna le forme di collisione
		for child in get_children():
			if child is CharacterBody2D:  # Se il nodo è un personaggio (o un altro corpo fisico)
				draw_collision_shapes(child)  # Disegna le collisioni per quel nodo

# Funzione che disegna le collisioni di un oggetto fisico (come CharacterBody2D)
func draw_collision_shapes(body: CharacterBody2D):
	# Verifica se il nodo ha un CollisionShape2D
	var collision_shape = body.get_node("CollisionShape2D")  # Assumiamo che sia un figlio diretto
	if collision_shape:
		var shape = collision_shape.shape
		if shape is RectangleShape2D:
			# Disegna un rettangolo rosso semi-trasparente
			draw_rect(Rect2(body.position - shape.extents, shape.extents * 2), Color(1, 0, 0, 0.5))
		elif shape is CircleShape2D:
			# Disegna un cerchio verde semi-trasparente
			draw_circle(body.position, shape.radius, Color(0, 1, 0, 0.5))
