extends Node2D
class_name Game

@onready
var candy_cane_base = preload("res://entities/candyCanes/candy_cane_0.tscn")
var current_cane
var cane_ready := false

var just_started := true

@onready
var grabber := $Grabber
@onready
var container := $Container
@onready
var next_cane_slot := $NextCaneSlot
@onready
var score_display := $ScoreDisplayBorder

var force := 0.0
var building_up_force := false

var combo := 1

func _ready() -> void:
	GameManager.game = self
	set_background("bg1")
	grabber.set_extents(container.get_extents())
	spawn_cane()

func _input(event: InputEvent) -> void:
	if InputMap.action_has_event("drop", event):
		if event.is_pressed():
			if cane_ready:
				launch_cane()

func _process(delta: float) -> void:
	print(get_force())
	$LauchPower.value = get_force()

func get_force():
	var mult = clamp(abs(find_child("Grabber").get_local_mouse_position().y) / 160, 1, 5)
	return clamp(abs(find_child("Grabber").get_local_mouse_position().y), 5, 5000) * mult

func launch_cane():
	building_up_force = false
	cane_ready = false
	combo = 1
	current_cane.fall(get_force())
	$LauchPower.value = 0.0

func spawn_cane() -> void:
	current_cane = next_cane_slot.get_next_cane()
	current_cane.reparent(self)
	current_cane.set_extents(container.get_extents())
	current_cane.body_entered.connect(on_cane_landed)
	current_cane.spawn()
	next_cane_slot.randomize_next_cane()
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

func calculate_score(achieved_level : int) -> void:
	var score = achieved_level * combo * 100 + force/10
	combo += 1
	score_display.set_score(score)

func win():
	print("you win")

func _on_death_zone_body_entered(body):
	if body.is_in_group("canes"):
		print("GAMEOVER") 
		GameManager.game_over()
	pass
