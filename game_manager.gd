extends Node
var active_listeners = []
var active_collisions = []

@onready
var next_levels = [load("res://candy_cane_01.tscn"),
load("res://candy_cane_02.tscn"),
load("res://candy_cane.tscn")]


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func register(cane: RigidBody2D) -> void:
	active_listeners.append(cane)
	cane.body_entered.connect(listen)
	cane.body_exited.connect(unlisten)
	pass
	

func deregister() -> void:
	pass

func listen(colliding_body: Node) -> void:
	if colliding_body.is_in_group("canes"):
		active_collisions.append(colliding_body)
	pass

func unlisten(exiting_body: Node) -> void:
	pass

func check_merge(new_collision: Array) -> void:
	if active_collisions.any(func(collision): return active_collisions.has([new_collision[1], new_collision[0]])):
		merge(new_collision[0].global_position, new_collision[0].lvl)
		new_collision[0].queue_free()
		new_collision[1].queue_free()
		active_collisions.erase([new_collision[1], new_collision[0]])
		active_collisions.erase(new_collision)
	pass

func register_collision(cane_a, cane_b) -> void:
	active_collisions.append([cane_a, cane_b])
	call_deferred("check_merge", [cane_a, cane_b])

func merge(spawn_pos: Vector2, lvl: int) -> void:
	var next_cane = next_levels[lvl].instantiate()
	get_tree().root.get_child(1).add_child(next_cane)
	next_cane.global_position = spawn_pos
