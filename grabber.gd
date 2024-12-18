extends Node2D

@onready
var candy_cane_base = preload("res://candy_cane.tscn")
var current_cane
var cane_ready := false
@onready
var cane_parent = $CaneSpawnPoint

func _ready() -> void:
	spawn_cane()

func _input(event: InputEvent) -> void:
	if InputMap.action_has_event("drop", event) and event.is_pressed() and cane_ready:
		cane_ready = false
		current_cane.fall()


func _process(delta: float) -> void:
	self.position.x = get_global_mouse_position().x
	

func spawn_cane() -> void:
	current_cane = candy_cane_base.instantiate() 
	current_cane.get_child(0).body_entered.connect(on_cane_landed)
	cane_parent.add_child(current_cane)
	cane_ready = true

func on_cane_landed(body: Node) -> void :
	if !cane_ready:
		current_cane.get_child(0).body_entered.disconnect(on_cane_landed)
		call_deferred("spawn_cane")
