extends Node2D

@onready
var candy_cane_base = preload("res://entities/candyCanes/candy_cane_0.tscn")
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
	self.position.x = calc_horizontal_pos()

func calc_horizontal_pos() -> float:
	return min(max(get_node("../Container/LeftWall").position.x, get_global_mouse_position().x), get_node("../Container/RightWall").position.x)

func spawn_cane() -> void:
	current_cane = candy_cane_base.instantiate() 
	current_cane.body_entered.connect(on_cane_landed)
	cane_parent.add_child(current_cane)
	current_cane.spawn()
	cane_ready = true

func on_cane_landed(body: Node) -> void :
	if !cane_ready:
		current_cane.body_entered.disconnect(on_cane_landed)
		call_deferred("spawn_cane")
