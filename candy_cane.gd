extends Node2D

@export
var lvl := 0

@onready
var body = $RigidBody2D

@onready
var next_levels = [load("res://candy_cane_01.tscn"),
load("res://candy_cane_02.tscn"),
load("res://candy_cane.tscn")]

func _ready() -> void:
	body.freeze = true

func fall() -> void:
	reparent(get_tree().root.get_child(0))
	body.freeze = false

func _process(_delta: float) -> void:
	pass


@warning_ignore("shadowed_variable")
func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if(body is RigidBody2D and body.get_parent().lvl == lvl):
		call_deferred("merge", body)
	pass

func merge(partner: Node) -> void:
	#kill partner
	partner.get_parent().queue_free()
	#instantiate next level
	var next_cane = next_levels[lvl].instantiate()
	next_cane.global_position = self.global_position
	get_tree().root.get_child(0).add_child(next_cane)
	#kill self
	queue_free()
	pass
