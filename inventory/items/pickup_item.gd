extends Area2D

@export var item_data: InvItem

func _ready():
	$Sprite2D.texture = item_data.texture
	monitoring = true  # Per sicurezza
	connect("body_entered", Callable(self, "_on_body_entered"))  # Importante!

func _on_body_entered(body):
	print("🟢 TOCCATO DA:", body.name)  # Debug: deve stampare "Player"
	if body.has_method("add_item_to_inventory"):
		body.add_item_to_inventory(item_data)
		queue_free()
