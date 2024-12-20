extends Node

var active_listeners = []
var active_collisions = []

@onready
var game_node = get_tree().root.get_node("/root/Game")

func register(cane: RigidBody2D) -> void:
	maintain_active_listeners(cane)
	active_listeners.append(cane)
	cane.body_entered.connect(listen)
	cane.body_exited.connect(unlisten)
	pass

func maintain_active_listeners(new_cane) -> void:
	var canes_to_erase = []
	for cane in active_listeners:
		if !is_instance_valid(cane):
			canes_to_erase.append(cane)
	for cane in canes_to_erase:
		active_listeners.erase(cane)
	if new_cane != null:
		active_listeners.append(new_cane)
	

func print_active_listeners() -> String:
	var str = ""
	str += "act_list length: "
	str += str(active_listeners.size())
	var canes_to_erase = []
	for cane in active_listeners:
		if is_instance_valid(cane):
			str += cane.name
			str += ", "
		else:
			canes_to_erase.append(cane)
	for cane in canes_to_erase:
		active_listeners.erase(cane)
	return str

func listen(colliding_body: Node) -> void:
	if colliding_body.is_in_group("canes"):
		active_collisions.append(colliding_body)
	pass

func unlisten(exiting_body: Node) -> void:
	pass

func check_merge(new_collision: Array) -> void:
	if active_collisions.any(func(collision): return active_collisions.has([new_collision[1], new_collision[0]])):
		var spawn_pos = new_collision[0].global_position
		var level = new_collision[0].lvl
		var rotation = new_collision[0].rotation
		clean_active_listeners(new_collision)
		merge(spawn_pos, level, rotation)
		active_collisions.erase([new_collision[1], new_collision[0]])
		active_collisions.erase(new_collision)
		#clean_active_listeners()
	pass

func register_collision(cane_a, cane_b) -> void:
	active_collisions.append([cane_a, cane_b])
	call_deferred("check_merge", [cane_a, cane_b])

func merge(spawn_pos: Vector2, lvl: int, initial_rotation: float) -> void:
	if lvl >= 10 : lvl = -1
	var next_cane = load("res://entities/candyCanes/candy_cane_%s.tscn" % str(lvl+1)).instantiate()
	#var next_cane = next_levels[lvl].instantiate()
	next_cane.global_position = spawn_pos
	next_cane.move_allowed = false
	next_cane.rotation = initial_rotation
	game_node.add_child(next_cane)

func game_over():
	for cane in active_listeners:
		cane.queue_free()

func clean_active_listeners(fused_canes: Array) -> void:
	active_listeners.erase(fused_canes[0])
	active_listeners.erase(fused_canes[1])
	fused_canes[0].queue_free()
	fused_canes[1].queue_free()
