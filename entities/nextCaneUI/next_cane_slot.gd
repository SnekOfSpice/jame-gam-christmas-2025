extends NinePatchRect

var next_cane

func _ready():
	randomize_next_cane()
	#var next_cane = load("res://entities/candyCanes/candy_cane_%s.tscn" % str(lvl+1)).instantiate()

func randomize_next_cane():
	var lvl:int
	var r = randf()
	if r <= 0.5:
		lvl = 0
	elif r <= 0.75:
		lvl = 1
	elif r <= 0.9:
		lvl = 2
	else:
		lvl = 3
	next_cane = load("res://entities/candyCanes/candy_cane_%s.tscn" % str(lvl)).instantiate()
	next_cane.freeze = true
	$CaneParent.add_child(next_cane)

func get_next_cane():
	if next_cane == null:
		randomize_next_cane()
	return next_cane

#
	#current_cane = candy_cane_base.instantiate()
	#current_cane.set_extents($Container.get_extents())
	#current_cane.body_entered.connect(on_cane_landed)
	#current_cane.spawn()
	#add_child(current_cane)
	#cane_ready = true
