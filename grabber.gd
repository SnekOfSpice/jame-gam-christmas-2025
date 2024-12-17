extends Node2D

@onready
var candy_cane_base = preload("res://candy_cane.tscn")
var current_cane

func _ready() -> void:
	spawn_cane()
	pass

func _input(event: InputEvent) -> void:
	if InputMap.action_has_event("drop", event) and event.is_pressed():
		current_cane.fall()
		spawn_cane()


func _process(delta: float) -> void:
	self.position.x = get_global_mouse_position().x
	


func spawn_cane() -> void:
	current_cane = candy_cane_base.instantiate() 
	add_child(current_cane)
