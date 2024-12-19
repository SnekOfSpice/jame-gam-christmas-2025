extends Node2D

@onready
var candy_cane_base = preload("res://entities/candyCanes/candy_cane_0.tscn")
var current_cane
var cane_ready := false
@onready
var cane_parent = $CaneSpawnPoint

var move_limits:Vector2

func _ready() -> void:
	#spawn_cane()
	pass

func set_extents(value:Vector2):
	move_limits = value


func _physics_process(delta: float) -> void:
	self.position.x = calc_horizontal_pos()

func calc_horizontal_pos() -> float:
	return clamp(get_global_mouse_position().x, move_limits.x, move_limits.y)

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
