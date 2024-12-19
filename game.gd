extends Node2D

@onready
var candy_cane_base = preload("res://entities/candyCanes/candy_cane_0.tscn")
var current_cane
var cane_ready := false


func _ready() -> void:
	set_background("bg1")
	$Grabber.set_extents($Container.get_extents())
	spawn_cane()

func _input(event: InputEvent) -> void:
	if InputMap.action_has_event("drop", event) and event.is_pressed() and cane_ready:
		cane_ready = false
		current_cane.fall()

func spawn_cane() -> void:
	current_cane = candy_cane_base.instantiate()
	current_cane.set_extents($Container.get_extents())
	current_cane.body_entered.connect(on_cane_landed)
	current_cane.spawn()
	add_child(current_cane)
	cane_ready = true


func set_background(background:String, fade_time := 0.0):
	var path = str("res://backgrounds/", background, ".png")
	if not FileAccess.file_exists(path):
		push_warning(str("COULDN'T FIND BACKGROUND ", background, "!"))
		return
	var new_background:Node2D
	var old_backgrounds:=$Background.get_children()
	if path.ends_with(".png") or path.ends_with(".jpg") or path.ends_with(".jpeg"):
		new_background = Sprite2D.new()
		new_background.texture = load(path)
		new_background.centered = false
	
	elif path.ends_with(".tscn"):
		new_background = load(path).instantiate()
	else:
		push_error(str("Background ", background, " does not end in .png, .jpg, .jpeg or .tscn."))
		return
	
	$Background.add_child(new_background)
	$Background.move_child(new_background, 0)
	
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var background_size := Vector2.ZERO
	if new_background is Sprite2D:
		background_size = new_background.texture.get_size()
	elif new_background.has_method("get_size"):
		background_size = new_background.get_size()
	
	var overshoot = background_size - Vector2(960, 540)
	if overshoot.x > 0:
		new_background.position.x = - overshoot.x * 0.5
	if overshoot.y > 0:
		new_background.position.y = - overshoot.y * 0.5
	
	
	for old_node : Node in old_backgrounds:
		var fade_tween := get_tree().create_tween()
		fade_tween.tween_property(old_node, "modulate:a", 0.0, fade_time)
		fade_tween.finished.connect(old_node.queue_free)

func on_cane_landed(_body: Node) -> void:
	if !cane_ready:
		current_cane.body_entered.disconnect(on_cane_landed)
		call_deferred("spawn_cane")

